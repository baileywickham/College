#lang typed/racket
(require typed/rackunit)

;; Full project implemented

;; Data Definitions ==================================================================================

(define-type ExprC (U Real String Symbol IfC AppC FnC))
(struct IfC ([f : ExprC] [t : ExprC] [e : ExprC]) #:transparent)
(struct AppC ([f : ExprC] [args : (Listof ExprC)]) #:transparent)
(struct FnC ([args : (Listof Symbol)] [body : ExprC]) #:transparent)

(define-type Environment (Listof Binding))
(struct Binding ([name : Symbol] [v : Value]) #:transparent)

(define-type Value (U Real String Boolean ClosV PrimV))
(struct ClosV ([args : (Listof Symbol)] [body : ExprC] [env : Environment]) #:transparent)
(struct PrimV ([f : ((Listof Value) → (U Value Nothing))] [arity : Natural]) #:transparent)

;; Functions =========================================================================================

;; Given a program in the surface language expressed as an s-expression, evaluates it and returns the
;; result, or raises an error if the program is malformatted
(define (top-interp [s : Sexp]) : String
  (serialize (interp (parse s) (top-env))))

;; Given a value, returns a string representation
(define (serialize [v : Value]) : String
  (match v
    [(? ClosV?) "#<procedure>"]
    [(? PrimV?) "#<primop>"]
    [#t "true"]
    [#f "false"]
    [other (~v other)]))

;; Throws an error starting with "DXUQ" so that it is clear the error is not a failure of the
;; interpreter but instead a validly rasied issue with the program being interpreted
(define (dxuq-error [message : String] . [values : Any *]) : Nothing
  (apply error 'DXUQ message values))

;; Parseing ------------------------------------------------------------------------------------------

;; Converts an s-expression representing the body of a function to an ExprC representation
;; All of the casts in this function should be ensured to succeed by the match patterns
(define (parse [s : Sexp]) : ExprC
  (match s
    [(or (? real? v) (? string? v) (? id? v)) (cast v ExprC)]
    [`{let {,(? id? s) = ,v } ... in ,e }
     (AppC (FnC+ (cast s (Listof Symbol)) (parse e)) (map parse (cast v (Listof Sexp))))]
    [`{if ,f ,t ,e } (IfC (parse f) (parse t) (parse e))]
    [`{fn {,(? id? args) ... } ,body } (FnC+ (cast args (Listof Symbol)) (parse body))]
    [`{,f ,args ...} (AppC (parse f) (map parse (cast args (Listof Sexp))))]
    [other (dxuq-error "bad syntax in ~e" other)]))

;; Checks if the argument is a valid id (symbol and not builtin name)
(define (id? [s : Any]) : Boolean
  (and (symbol? s) (nor (equal? s 'if) (equal? s 'let) (equal? s 'fn) (equal? s 'in))))

;; Constructs a new FnC, ensuring that the args are unique
(define (FnC+ [args : (Listof Symbol)] [body : ExprC]) : FnC
  (if (check-duplicates args) (dxuq-error "Duplicate argument identifier") (FnC args body)))

;; Interpreting --------------------------------------------------------------------------------------

;; Evaluates an expression represented as a ExprC and returns the value that results
(define (interp [e : ExprC] [env : Environment]) : Value
  (match e
    [(or (? real? v) (? string? v)) v]
    [(? symbol? s) (lookup s env)]
    [(IfC f t e) (if (boolean-E (interp f env)) (interp t env) (interp e env))]
    [(FnC args body) (ClosV args body env)]
    [(AppC f args) (apply-func (interp f env) (map (λ ([a : ExprC]) (interp a env)) args))]))

;; Applys a function (either a primative or a closure) and returns the value of the result or an error
(define (apply-func [f : Value] [args : (Listof Value)]) : Value
  (match f
    [(PrimV o n) (if (= (length args) n) (o args) (dxuq-error "Primative has wrong arity"))]
    [(ClosV ids body env) (interp body (make-env ids args env))]
    [other (dxuq-error "Could not apply function ~a" (serialize other))]))

;; Given a list of argument names and values, matches them into a list of bindings or raises an error
;; if the arity does not match. Preprends this to an existing environment
(define (make-env [ids : (Listof Symbol)] [vals : (Listof Value)] [env : Environment]) : Environment
  (if (= (length ids) (length vals)) (append (map Binding ids vals) env)
      (dxuq-error "Function has wrong arity")))

;; Searches through a list of bindings for a given id, if the id is found the value in the binging is
;; returned, otherwise an unbound identifier error is raised
(define (lookup [id : Symbol] [env : Environment]): Value
  (define binding (findf (λ ([b : Binding]) (equal? (Binding-name b) id)) env))
  (if binding (Binding-v binding) (dxuq-error "Unbound identifier ~e" id)))

;; Globally scoped top enviroment containing primops and boolean values
;; (Made this a function, so it does not have to be below all the functions it calls)
(define (top-env) : Environment
  (list
   (Binding 'true #t)
   (Binding 'false #f)
   (Binding '+ (binop-prim +))
   (Binding '* (binop-prim *))
   (Binding '- (binop-prim -))
   (Binding '/ (binop-prim /-safe))
   (Binding '<= (binop-prim <=))
   (Binding 'equal? (PrimV equal-prim 2))
   (Binding 'error (PrimV error-prim 1))))

;; Given a function that expects 2 reals, creates a PrimV representation
(define (binop-prim [f : (Real Real → Value)]) : PrimV
  (PrimV (λ ([v : (Listof Value)]) (f (real-E (first v)) (real-E (second v)))) 2))

;; Given a list containing 2 Values, returns whether they are both comparable and equal
(define (equal-prim [vals : (Listof Value)]) : Boolean
  (and (andmap comparable? vals) (equal? (first vals) (second vals))))

;; Given a list containing 1 Value, raises an error containing DXUQ, user error, and the
;; serialization of the value
(define (error-prim [v : (Listof Value)]) : Nothing
  (dxuq-error "user error: ~a" (serialize (first v))))

;; Given a value, determines whether it is comaprable, not a procedure
(define (comparable? [v : Value]) : Boolean
  (nor (PrimV? v) (ClosV? v)))

;; A version of division that thows our error (instead of the racket error) when dividing by 0
(define (/-safe [l : Real] [r : Real]) : Real
  (if (zero? r) (dxuq-error "Cannot divide ~e by 0" l) (/ l r)))

;; Wraps a value and Ensures it is a Real, throwing an error otherwise
(define (real-E [v : Value]) : Real
  (if (real? v) v (dxuq-error "Type mismatch: ~a is not a Real" (serialize v))))

;; Wraps a value and Ensures it is a Boolean, throwing an error otherwise
(define (boolean-E [v : Value]) : Boolean
  (if (boolean? v) v (dxuq-error "Type mismatch: ~a is not a Boolean" (serialize v))))


;; TESTS =============================================================================================

;; top-interp
(check-equal? (top-interp '{+ 2 3}) "5")
(check-equal? (top-interp '{{fn {a b} {+ a b}} 2 3}) "5")
(check-equal? (top-interp '{let {a = 2} {f = {fn {x y} {* x y}}} in {f a 3}}) "6")
(check-equal? (top-interp '{if true "hello" "hi"}) "\"hello\"")
(check-equal? (top-interp '{<= 2 2}) "true")
(check-equal? (top-interp '{let {add = {fn {nlf1} {fn {nlf2}
                                                      {fn {f} {fn {a} {{nlf1 f} {{nlf2 f} a}}}}}}}
                             {one = {fn {f} {fn {a} {f a}}}}
                             {two = {fn {f} {fn {a} {f {f a}}}}}
                             {double = {fn {x} {* 2 x}}}
                             in {if {equal? {{{{add one} two} double} 1} 8}
                                    "Result Correct" "Result Incorrect"}}) "\"Result Correct\"")

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

;; parse
(check-equal? (parse '2) 2)
(check-equal? (parse 'abc) 'abc)
(check-equal? (parse "abc") "abc")
(check-equal? (parse '{+ 2 2}) (AppC '+ '(2 2)))
(check-equal? (parse '{* 2 {+ -1 2}}) (AppC '* (list 2 (AppC '+ '(-1 2)))))
(check-equal? (parse '{if 0 0 {+ 2 2}}) (IfC 0 0 (AppC '+ '(2 2))))
(check-equal? (parse '{fn {x y} {+ x y}}) (FnC '(x y) (AppC '+ '(x y))))
(check-equal? (parse '{{fn {x y} {+ x y}} 2 {+ 2 4}})
              (AppC (FnC '(x y) (AppC '+ '(x y))) (list 2 (AppC '+ '(2 4)))))
(check-equal? (parse '{let {a = 2} in {+ a 3}}) (AppC (FnC '(a) (AppC '+ '(a 3))) '(2)))
(check-exn #px"bad syntax" (λ () (parse '{})))
(check-exn #px"bad syntax" (λ () (parse '{let {{a 10} {b 3} {too many vals}} true})))

;; id?
(check-equal? (id? 'c) #t)
(check-equal? (id? 12) #f)
(check-equal? (id? 'fn) #f)

;; FnC+
(check-equal? (FnC+ '(a b c) 4) (FnC '(a b c) 4))
(check-exn #px"Duplicate argument identifier" (λ () (FnC+ '(a a b) 4)))

;; Interpreting Tests --------------------------------------------------------------------------------

;; interp
(check-equal? (interp 4 '()) 4)
(check-equal? (interp "hello" '()) "hello")
(check-equal? (interp 'id (list (Binding 'id 5))) 5)
(check-equal? (interp (IfC 'true 1 2) (top-env)) 1)
(check-equal? (interp (IfC 'false 1 2) (top-env)) 2)
(check-equal? (interp (FnC '(a b c) "hello") (list (Binding 'id 5)))
              (ClosV '(a b c) "hello" (list (Binding 'id 5))))
(check-equal? (interp (AppC '+ (list 2 (AppC '- (list 10 (AppC '* (list 3 (AppC '/ '(3 1))))))))
                      (top-env)) 3)
(check-equal? (interp (AppC (FnC '(x y) (AppC '* '(x 10))) '(6 7)) (top-env)) 60)

;; apply-func
(check-equal? (apply-func (binop-prim +) '(1 2)) 3)
(check-equal? (apply-func (ClosV '(a b) 'a '()) '(1 2)) 1)
(check-equal? (apply-func (ClosV '(a) (AppC 'p '(a a)) (list (Binding 'p (binop-prim +)))) '(7)) 14)
(check-exn #px"Primative has wrong arity" (λ () (apply-func (binop-prim +) '(1 2 4))))
(check-exn #px"Could not apply function" (λ () (apply-func "nope" '(1 2 4))))

;; make-env
(check-equal? (make-env '() '() '()) '())
(check-equal? (make-env '(a b c) '(4 "g" #t) (list (Binding 'g 4)))
              (list (Binding 'a 4) (Binding 'b "g") (Binding 'c #t) (Binding 'g 4)))
(check-exn #px"Function has wrong arity" (λ () (make-env '(x y) '(1) '())))

;; lookup
(check-equal? (lookup 'x (list (Binding 'x 10) (Binding 'y 20))) 10)
(check-exn #px"Unbound identifier" (λ () (lookup 'y (list (Binding 'x 10)))))

;; binop-prim
(check-equal? (PrimV-arity (binop-prim +)) 2)
(check-equal? ((PrimV-f (binop-prim +)) '(3 4)) 7)
(check-exn #px"Type mismatch: \"Q\" is not a Real" (λ () ((PrimV-f (binop-prim +)) '(3 "Q"))))

;; equal-prim
(check-equal? (equal-prim '(2 2)) #t)
(check-equal? (equal-prim '(2 "II")) #f)
(check-equal? (equal-prim (list (binop-prim +) #t)) #f)
(check-equal? (equal-prim (list (binop-prim +) (binop-prim +))) #f)

;; error-prim
(check-exn #px"DXUQ: user error: true" (λ () (error-prim '(#t))))
(check-exn #px"DXUQ: user error: #<procedure>" (λ () (error-prim (list (ClosV '(a b) 'a '())))))

;; comparable?
(check-equal? (comparable? 1) #t)
(check-equal? (comparable? (binop-prim +)) #f)

;; /-safe
(check-equal? (/-safe 2 1) 2)
(check-exn #px"Cannot divide 3 by 0" (λ () (/-safe 3 0)))

;; real-E
(check-equal? (real-E 10) 10)
(check-exn #px"Type mismatch: \"nah\" is not a Real" (λ () (real-E "nah")))

;; boolean-E
(check-equal? (boolean-E #t) #t)
(check-exn #px"Type mismatch: 3 is not a Boolean" (λ () (boolean-E 3)))

