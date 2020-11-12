#lang typed/racket
(require typed/rackunit)

;; Full project implemented

;; Data Definitions ==================================================================================

(define-type ExprC (U Real String Symbol IfC AppC FnC RecC))
(struct IfC ([f : ExprC] [t : ExprC] [e : ExprC]) #:transparent)
(struct AppC ([f : ExprC] [args : (Listof ExprC)]) #:transparent)
(struct FnC ([args : (Listof Symbol)] [tys : (Listof Ty)] [body : ExprC]) #:transparent)
(struct RecC ([name : Symbol] [fn : FnC] [ty : FnT] [body : ExprC]) #:transparent)

(define-type Ty (U 'num 'str 'bool FnT))
(struct FnT ([args : (Listof Ty)] [ret : Ty]) #:transparent)

(define-type TEnv (Env Ty))
(define-type Environment (Env Value))
(define-type (Env A) (Listof (Binding A)))
(struct (A) Binding ([name : Symbol] [value : A]) #:transparent)

(define-type Value (U Real String Boolean ClosV PrimV))
(define-type PrimV ((Listof Value) → Value))
(struct ClosV ([args : (Listof Symbol)] [body : ExprC] [env : Environment]) #:mutable #:transparent)

;; Functions =========================================================================================

;; Given a program in the surface language expressed as an s-expression, evaluates it and returns the
;; result, or raises an error if the program is malformatted
(define (top-interp [s : Sexp]) : String
  (define e (parse s))
  (type-check e base-tenv)
  (serialize (interp e base-env)))

;; Given a value, returns a string representation
(define (serialize [v : Value]) : String
  (match v
    [(? ClosV?) "#<procedure>"]
    [(? procedure?) "#<primop>"]
    [#t "true"]
    [#f "false"]
    [other (~v other)]))

;; Throws an error starting with "DXUQ" so that it is clear the error is not a failure of the
;; interpreter but instead a validly rasied issue with the program being interpreted
(define (dxuq-error [message : String] . [values : Any *]) : Nothing
  (apply error 'DXUQ message values))

;; Parseing ------------------------------------------------------------------------------------------

;; Converts an s-expression representing a program ExprC representation
;; All of the casts in this function should be ensured to succeed by the match patterns
(define (parse [s : Sexp]) : ExprC
  (match s
    [(or (? real? v) (? string? v) (? id? v)) (cast v ExprC)]
    [`{if ,f ,t ,e } (IfC (parse f) (parse t) (parse e))]
    [`{let {,tys ,(? id? ids) = ,vals } ... in ,e }
     (AppC (parse-FnC ids tys e) (map parse (cast vals (Listof Sexp))))]
    [`{fn {[,tys ,(? id? args)] ...} ,body } (parse-FnC args tys body)]
    [`{rec {{,(? id? name) [,tys ,(? id? args)] ...} : ,ret ,fbody } ,body }
     (parse-RecC name (parse-FnC args tys fbody) ret body)]
    [`{,f ,args ...} (AppC (parse f) (map parse (cast args (Listof Sexp))))]
    [other (dxuq-error "bad syntax in ~e" other)]))

;; Given a unparsed representation of a RecC and the parsed representation of it's function parses it
;; or throws an error if the name is also an argument
(define (parse-RecC [name : Symbol] [f : FnC] [ret : Sexp] [body : Sexp]) : RecC
  (if (member name (FnC-args f)) (dxuq-error "Recursive function ~e has confincting name" name)
      (RecC name f (FnT (FnC-tys f) (parse-type ret)) (parse body))))

;; Constructs a new FnC, ensuring that the args are unique
;; Casts in this function are guaranteed to succeed by the match in parse
(define (parse-FnC [args : (Listof Any)] [tys : (Listof Any)] [body : Sexp]) : FnC
  (if (check-duplicates args) (dxuq-error "Duplicate argument identifier")
      (FnC (cast args (Listof Symbol)) (map parse-type (cast tys (Listof Sexp))) (parse body))))

;; Given an s expression representing a type converts it to a type representation
;; All of the casts in this function should be ensured to succeed by the match patterns
(define (parse-type [s : Sexp]) : Ty
  (match s
    ['num 'num] ['bool 'bool] ['str 'str]
    [`{,args ... -> ,ret } (FnT (map parse-type (cast args (Listof Sexp))) (parse-type ret))]
    [other (dxuq-error "Invaid type ~e" other)]))

;; Checks if the argument is a valid id (symbol and not builtin name)
(: id? (Any → Boolean : #:+ Symbol))
(define (id? s)
  (and (symbol? s) (not (member s '(if let = in fn : rec)))))

;; Typing --------------------------------------------------------------------------------------------

;; Given an ExprC returns the type or raises an error if it is malformatted
(define (type-check [e : ExprC] [env : TEnv]) : Ty
  (match e
    [(? real?) 'num]
    [(? string?) 'str]
    [(? symbol? e) (lookup e env)]
    [(IfC f t e) (type-check-IfC (type-check f env) (type-check t env) (type-check e env))]
    [(FnC args tys body) (FnT tys (type-check body (make-env args tys env)))]
    [(RecC name (FnC args tys body) ty exp)
     (type-check-RecC (type-check body (make-env (cons name args) (cons ty tys) env))
                      (type-check exp (make-env* name ty env)) ty)]
    [(AppC f a) (type-check-AppC (type-check f env) (map (λ ([e : ExprC]) (type-check e env)) a))]))

;; Given the types for the three clauses of an if, ensures that they are valid and if so returns the
;; type that the if will return
(define (type-check-IfC [f : Ty] [t : Ty] [e : Ty]) : Ty
  (unless (equal? 'bool f) (dxuq-error "Expected 'bool got: ~e" f))
  (unless (equal? t e) (dxuq-error "Types of if clauses must match but got: ~e and ~e" t e))
  e)

;; Given the types of the body of the recursive function, the body of the expression for which the
;; recursive function is defined for, and the declared return type, checks to make sure the recursive
;; function acctually retuns the correct type, and if so returns the type of the whole expression
(define (type-check-RecC [body : Ty] [exp : Ty] [ty : FnT]) : Ty
  (unless (equal? body (FnT-ret ty)) (dxuq-error "Mismatched recursive return types: ~e" body))
  exp)

;; Given the type of a function and the types of it's arguments, ensures the function is acctually a
;; function and that the types of the args are as expected, returns the type of evaluating the app
(define (type-check-AppC [f : Ty] [args : (Listof Ty)]): Ty
  (unless (FnT? f) (dxuq-error "Could not call non function: ~e" f))
  (unless (equal? (FnT-args f) args)
    (dxuq-error "Could not apply function of ~e to types ~e" (FnT-args f) args))
  (FnT-ret f))

;; Interpreting --------------------------------------------------------------------------------------

;; Evaluates an expression represented as a ExprC and returns the value that results
(define (interp [e : ExprC] [env : Environment]) : Value
  (match e
    [(or (? real? v) (? string? v)) v]
    [(? symbol? s) (lookup s env)]
    [(IfC f t e) (if (interp f env) (interp t env) (interp e env))]
    [(FnC args _ body) (ClosV args body env)]
    [(RecC name (FnC args _ bd) _ e) (interp e (make-env* name (rec! name (ClosV args bd env)) env))]
    [(AppC f args) (apply-func (interp f env) (map (λ ([a : ExprC]) (interp a env)) args))]))

;; Applys a function (either a primative or a closure) and returns the value of the result or an error
(define (apply-func [f : Value] [args : (Listof Value)]) : Value
  (match f
    [(ClosV ids body env) (interp body (make-env ids args env))]
    [(? procedure? f) ((cast f PrimV) args)]))

;; Given a closure mutates it so that it's env contains a binding to itself at name
;; returns that closure for conveniance
(define (rec! [name : Symbol] [clo : ClosV]) : ClosV
  (set-ClosV-env! clo (make-env* name clo (ClosV-env clo)))
  clo)

;; Given a list of argument names and values, matches them into a list of bindings or raises an error
;; if the arity does not match. Preprends this to an existing environment
(define #:∀ (A) (make-env [ids : (Listof Symbol)] [vals : (Listof A)] [env : (Env A)]) : (Env A)
  (if (= (length ids) (length vals))
      (append (map (inst Binding A) ids vals) env)
      (dxuq-error "Function has wrong arity")))

;; Given a an argument name and value, creates a new binding and preprends this to an existing env
(define #:∀ (A) (make-env* [id : Symbol] [v : A] [env : (Env A)]) : (Env A)
  (make-env (list id) (list v) env))

;; Searches through a list of bindings for a given id, if the id is found the value in the binging is
;; returned, otherwise an unbound identifier error is raised
(define #:∀ (A) (lookup [id : Symbol] [env : (Env A)]) : A
  (define binding (findf (λ ([b : (Binding A)]) (equal? (Binding-name b) id)) env))
  (if binding (Binding-value binding) (dxuq-error "Unbound identifier ~e" id)))

;; Base Environment ----------------------------------------------------------------------------------

;; Given a function that expects 2 reals, creates a PrimV representation
;; Cast will succeed by our type checker
(define (binop-prim [f : (Real Real → Value)]) : PrimV
  (λ (l) (apply f (cast l (List Real Real)))))

;; A version of division that thows our error (instead of the racket error) when dividing by 0
(define (/-safe [l : Real] [r : Real]) : Real
  (if (zero? r) (dxuq-error "Cannot divide ~e by 0" l) (/ l r)))

;; Given a list of values containing 2 values returns whether the are equal
;; Cast will succeed by our type checker
(define (equal-prim [l : (Listof Value)]) : Boolean
  (apply equal? (cast l (List Value Value))))

;; Given a list of values cointaining a String (0) start index (1) and end index (2) returns the
;; substring from start to end if both are in the string and start <= end
;; Cast will succeed by our type checker
(define (substring-prim [l : (Listof Value)]) : String
  (let ([str (cast (first l) String)] [start (cast (second l) Real)] [end (cast (third l) Real)])
    (if (and (natural? start) (natural? end) (<= start end) (<= end (string-length str)))
        (substring str start end)
        (dxuq-error "Unable to take substring from ~e to ~e of ~e" start end str))))

;; Globally scoped top enviroment containing primops and boolean values and their types
(define base-full-env : (Listof (List Symbol Value Sexp))
  `((true #t bool)
    (false #f bool)
    (+ ,(binop-prim +) {num num -> num})
    (* ,(binop-prim *) {num num -> num})
    (- ,(binop-prim -) {num num -> num})
    (/ ,(binop-prim /-safe) {num num -> num})
    (<= ,(binop-prim <=) {num num -> bool})
    (num-eq? ,equal-prim {num num -> bool})
    (str-eq? ,equal-prim {str str -> bool})
    (substring ,substring-prim {str num num -> str})))

;; Base environment containing the types
(define base-tenv : TEnv
  (map (λ ([v : (List Symbol Value Sexp)]) (Binding (first v) (parse-type (third v)))) base-full-env))

;; Base environment containing the values
(define base-env : Environment
  (map (λ ([v : (List Symbol Value Sexp)]) (Binding (first v) (second v))) base-full-env))


;; TESTS =============================================================================================

;; top-interp
(check-equal? (top-interp '{+ 2 3}) "5")
(check-equal? (top-interp '{{fn {[num a] [num b]} {+ a b}} 2 3}) "5")
(check-equal? (top-interp '{let {num a = 2} {{num num -> num} f = {fn {[num x] [num y]} {* x y}}}
                             in {f a 3}}) "6")
(check-equal? (top-interp '{if true "hello" "hi"}) "\"hello\"")
(check-equal? (top-interp '{<= 2 2}) "true")
(check-equal? (top-interp '{str-eq? "abc" "abc"}) "true")
(check-equal? (top-interp '{substring "abcdef" 1 3}) "\"bc\"")
(check-equal? (top-interp '{rec {{fib [num n]} : num
                                               {if {<= n 2} 1 {+ {fib {- n 1}} {fib {- n 2}}}}}
                             {fib 5}}) "5")
(check-equal? (top-interp '{let {{{{num -> num} -> {num -> num}}
                                  -> {{{num -> num} -> {num -> num}}
                                      -> {{num -> num} -> {num -> num}}}}
                                 add = {fn {[{{num -> num} -> {num -> num}} nlf1]}
                                           {fn {[{{num -> num} -> {num -> num}} nlf2]}
                                               {fn {[{num -> num} f]} {fn {[num a]}
                                                                          {{nlf1 f} {{nlf2 f} a}}}}}}}
                             {{{num -> num} -> {num -> num}}
                              one = {fn {[{num -> num} f]} {fn {[num a]} {f a}}}}
                             {{{num -> num} -> {num -> num}}
                              two = {fn {[{num -> num} f]} {fn {[num a]} {f {f a}}}}}
                             {{num -> num}
                              double = {fn {[num x]} {* 2 x}}}
                             in {if {num-eq? {{{{add one} two} double} 1} 8}
                                    "Result Correct" "Result Incorrect"}}) "\"Result Correct\"")
(check-equal? (top-interp
               '{rec {{square-helper [num n]} : num {if {<= n 0} 0 {+ n {square-helper {- n 2}}}}}
                  {let {{num -> num} square = {fn {[num n]} {square-helper {- {* 2 n} 1}}}}
                    in {square 13}}})
              "169")

;; serialize
(check-equal? (serialize 5) "5")
(check-equal? (serialize "hello") "\"hello\"")
(check-equal? (serialize #t) "true")
(check-equal? (serialize #f) "false")
(check-equal? (serialize (binop-prim +)) "#<primop>")
(check-equal? (serialize (ClosV '(a b) 55 '())) "#<procedure>")

;; dxuq-error
(check-exn #px"DXUQ: test no args" (λ () (dxuq-error "test no args")))
(check-exn #px"DXUQ: test error: 3" (λ () (dxuq-error "test error: ~e" 3)))
(check-exn #px"DXUQ: test args: 3-'d" (λ () (dxuq-error "test args: ~e-~e" 3 'd)))

;; Parsing Tests -------------------------------------------------------------------------------------

;;; parse
(check-equal? (parse '2) 2)
(check-equal? (parse 'abc) 'abc)
(check-equal? (parse "abc") "abc")
(check-equal? (parse '{+ 2 2}) (AppC '+ '(2 2)))
(check-equal? (parse '{* 2 {+ -1 2}}) (AppC '* (list 2 (AppC '+ '(-1 2)))))
(check-equal? (parse '{if 0 0 {+ 2 2}}) (IfC 0 0 (AppC '+ '(2 2))))
(check-equal? (parse '{fn {[num x] [bool y]} {+ x y}}) (FnC '(x y) '(num bool) (AppC '+ '(x y))))
(check-equal? (parse '{{fn {[str x] [str y]} {+ x y}} 2 {+ 2 4}})
              (AppC (FnC '(x y) '(str str) (AppC '+ '(x y))) `(2 ,(AppC '+ '(2 4)))))
(check-equal? (parse '{let {num a = 2} in {+ a 3}}) (AppC (FnC '(a) '(num) (AppC '+ '(a 3))) '(2)))
(check-exn #px"bad syntax" (λ () (parse '{})))
(check-exn #px"bad syntax" (λ () (parse '{let {{num a 10} {str b 3} {way too many vals}} true})))

;; parse-RecC
(check-equal? (parse-RecC 'name (FnC '(a b) '(bool bool) 4) 'num '{+ 3 {name true false}})
              (RecC 'name (FnC '(a b) '(bool bool) 4) (FnT '(bool bool) 'num)
                    (AppC '+ (list 3 (AppC 'name '(true false))))))
(check-exn #px"Recursive function 'b has confincting name"
           (λ () (parse-RecC 'b (FnC '(a b) '(bool bool) 4) 'num '{name true false})))

;; parse-FnC
(check-equal? (parse-FnC '(a b c) '(num str {bool -> num}) '{+ 4 5})
              (FnC '(a b c) `(num str ,(FnT '(bool) 'num)) (AppC '+ '(4 5))))
(check-exn #px"Duplicate argument identifier" (λ () (parse-FnC '(a a b) '(bool) 4)))

;; parse-type
(check-equal? (parse-type 'bool) 'bool)
(check-equal? (parse-type '{num num {-> str} -> {str -> bool}})
              (FnT (list 'num 'num (FnT '() 'str)) (FnT '(str) 'bool)))
(check-exn #px"Invaid type 'garbage" (λ () (parse-type 'garbage)))
(check-exn #px"Invaid type ['][(]num ->[)]" (λ () (parse-type '{num ->})))

;; id?
(check-equal? (id? 'c) #t)
(check-equal? (id? 12) #f)
(check-equal? (id? 'fn) #f)

;; Typing Tests --------------------------------------------------------------------------------------

;; type-check
(check-equal? (type-check 3 '()) 'num)
(check-equal? (type-check "string" '()) 'str)
(check-equal? (type-check 'true base-tenv) 'bool)
(check-equal? (type-check (IfC 'true '+ '-) base-tenv) (FnT '(num num) 'num))
(check-equal? (type-check (FnC '(a b) '(num str) 3) '()) (FnT '(num str) 'num))
(check-equal? (type-check (RecC 'n (FnC '(a) '(num) 4) (FnT '(num) 'num) 'n) '()) (FnT '(num) 'num))
(check-equal? (type-check (AppC 'substring '("abc" -1 200)) base-tenv) 'str)

;; type-check-IfC
(check-equal? (type-check-IfC 'bool 'str 'str) 'str)
(check-exn #px"Expected 'bool got: 'str" (λ () (type-check-IfC 'str 'num 'num)))
(check-exn #px"Types of if clauses must match but got: 'bool and 'num"
           (λ () (type-check-IfC 'bool 'bool 'num)))

;; type-check-RecC
(check-equal? (type-check-RecC 'num 'bool (FnT '(str) 'num)) 'bool)
(check-exn #px"DXUQ: Mismatched recursive return types: 'str"
           (λ () (type-check-RecC 'str 'num (FnT '(str) 'num))))

;; type-check-AppC
(check-equal? (type-check-AppC (FnT '(num str) 'bool) '(num str)) 'bool)
(check-equal? (type-check-AppC (FnT '() 'bool) '()) 'bool)
(check-exn #px"Could not call non function: 'str" (λ () (type-check-AppC 'str '(num))))
(check-exn #px"Could not apply function of ['][(][)] to types ['][(]num[)]"
           (λ () (type-check-AppC (FnT '() 'str) '(num))))
(check-exn #px"Could not apply function of ['][(]bool num str[)] to types ['][(]str num bool[)]"
           (λ () (type-check-AppC (FnT '(bool num str) 'str) '(str num bool))))

;; Interpreting Tests --------------------------------------------------------------------------------

;; interp
(check-equal? (interp 4 '()) 4)
(check-equal? (interp "hello" '()) "hello")
(check-equal? (interp 'id (list (Binding 'id 5))) 5)
(check-equal? (interp (IfC 'true 1 2) base-env) 1)
(check-equal? (interp (IfC 'false 1 2) base-env) 2)
(check-equal? (interp (FnC '(a b c) '(str) "hello") (list (Binding 'id 5)))
              (ClosV '(a b c) "hello" (list (Binding 'id 5))))
(check-equal? (interp (AppC '+ (list 2 (AppC '- (list 10 (AppC '* (list 3 (AppC '/ '(3 1))))))))
                      base-env) 3)
(check-equal? (interp (AppC (FnC '(x y) '() (AppC '* '(x 10))) '(6 7)) base-env) 60)
(check-equal? (interp (RecC '! (FnC '(n) '(num)
                                    (IfC (AppC 'num-eq? '(n 0)) 1
                                         (AppC '* (list 'n (AppC '! (list (AppC '- '(n 1))))))))
                            (FnT '(num) 'num) (AppC '! '(7))) base-env) 5040)

;; rec!
(check-equal? (Binding-name (first (ClosV-env (rec! 'name (ClosV '(a) 4 '()))))) 'name)

;; apply-func
(check-equal? (apply-func (binop-prim +) '(1 2)) 3)
(check-equal? (apply-func (ClosV '(a b) 'a '()) '(1 2)) 1)
(check-equal? (apply-func (ClosV '(a) (AppC 'p '(a a)) (list (Binding 'p (binop-prim +)))) '(7)) 14)

;; make-env
(check-equal? (make-env '() '() '()) '())
(check-equal? (make-env '(a b c) '(4 5 6) (list (Binding 'g 4)))
              (list (Binding 'a 4) (Binding 'b 5) (Binding 'c 6) (Binding 'g 4)))
(check-exn #px"Function has wrong arity" (λ () (make-env '(x y) '(1) '())))

;; make-env*
(check-equal? (make-env* 'a #t '()) (list (Binding 'a #t)))

;; lookup
(check-equal? (lookup 'x (list (Binding 'x 10) (Binding 'y 20))) 10)
(check-exn #px"Unbound identifier" (λ () (lookup 'y (list (Binding 'x 10)))))

;; Base Environment Tests ----------------------------------------------------------------------------

;; binop-prim
(check-equal? ((binop-prim +) '(3 5)) 8)

;; /-safe
(check-equal? (/-safe 2 1) 2)
(check-exn #px"Cannot divide 3 by 0" (λ () (/-safe 3 0)))

;; equal-prim
(check-equal? (equal-prim '(3 5)) #f)
(check-equal? (equal-prim '(3 3)) #t)
(check-equal? (equal-prim '("t" "t")) #t)

;; substring-prim
(check-equal? (substring-prim '("alex" 1 2)) "l")
(check-exn #px"Unable to take substring" (λ () (substring-prim '("text" 2.4 3))))
(check-exn #px"Unable to take substring" (λ () (substring-prim '("text" -3 0))))
(check-exn #px"Unable to take substring" (λ () (substring-prim '("text" 0 200))))

