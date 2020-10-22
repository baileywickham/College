#lang typed/racket
(require typed/rackunit)

;; Full project implemented

;; Data Definitions ==================================================================================

(define-type ExprC (U Real String Symbol IfC AppC FnC MutC))
(struct IfC ([f : ExprC] [t : ExprC] [e : ExprC]) #:transparent)
(struct AppC ([f : ExprC] [args : (Listof ExprC)]) #:transparent)
(struct FnC ([args : (Listof Symbol)] [body : ExprC]) #:transparent)
(struct MutC ([var : Symbol] [val : ExprC]) #:transparent)

(define-type Environment (Listof Binding))
(struct Binding ([name : Symbol] [v : Natural]) #:transparent)

(define-type Store (Boxof (Listof Value)))

(define-type Value (U Real String Boolean ClosV PrimV Void ArrayV))
(struct ArrayV ([n : Natural] [len : Natural]) #:transparent)
(struct ClosV ([args : (Listof Symbol)] [body : ExprC] [env : Environment]) #:transparent)
(struct PrimV ([f : ((Listof Value) Store → (U Value Nothing))]
               [arity : (Option Natural)]) #:transparent)


;; Functions =========================================================================================

;; Given a program in the surface language expressed as an s-expression, evaluates it and returns the
;; result, or raises an error if the program is malformatted
(define (top-interp [s : Sexp]) : String
  (let-values ([(top-env top-sto) (init-globals)])
   (serialize (interp (parse s) top-env top-sto))))

;; Given a value, returns a string representation
(define (serialize [v : Value]) : String
  (match v
    [(? ClosV?) "#<procedure>"]
    [(? PrimV?) "#<primop>"]
    [(? ArrayV?) "#<array>"]
    [(? void?) "null"]
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
    [`{fn {,(? id? args) ...} ,body } (FnC+ (cast args (Listof Symbol)) (parse body))]
    [`{,(? id? var) <- ,val } (MutC var (parse val))]
    [`{,f ,args ...} (AppC (parse f) (map parse (cast args (Listof Sexp))))]
    [other (dxuq-error "bad syntax in ~e" other)]))

;; Checks if the argument is a valid id (symbol and not builtin name)
(: id? (Any → Boolean : #:+ Symbol))
(define (id? s)
  (and (symbol? s) (not (member s '(if let fn in <-)))))

;; Constructs a new FnC, ensuring that the args are unique
(define (FnC+ [args : (Listof Symbol)] [body : ExprC]) : FnC
  (if (check-duplicates args) (dxuq-error "Duplicate argument identifier") (FnC args body)))

;; Interpreting --------------------------------------------------------------------------------------

;; Evaluates an expression represented as a ExprC and returns the value that results
(define (interp [e : ExprC] [env : Environment] [sto : Store]) : Value
  (match e
    [(or (? real? v) (? string? v)) v]
    [(? symbol? s) (lookup-sto (lookup-env s env) sto)]
    [(MutC var val) (begin (mutate-sto (interp val env sto) sto (lookup-env var env)) (void))]
    [(IfC f t e) (if (boolean-E (interp f env sto)) (interp t env sto) (interp e env sto))]
    [(FnC args body) (ClosV args body env)]
    [(AppC f args)
     (apply-func (interp f env sto) (map (λ ([a : ExprC]) (interp a env sto) ) args) sto)]))

;; Applys a function (either a primative or a closure) and returns the value of the result or an error
(define (apply-func [f : Value] [args : (Listof Value)] [sto : Store]) : Value
  (match f
    [(PrimV o n) (if (or (not n) (= (length args) n)) (o args sto) (dxuq-error "Primative has wrong arity"))]
    [(ClosV ids body env) (interp body (make-env ids args env sto) sto)]
    [other (dxuq-error "Could not apply function ~a" (serialize other))]))

;; Given a list of argument names and values, matches them into a list of bindings or raises an error
;; if the arity does not match. Preprends this to an existing environment
(define (make-env [ids : (Listof Symbol)] [vals : (Listof Value)] [env : Environment] [sto : Store]) : Environment
  (if (= (length ids) (length vals)) (append (map (λ ([id : Symbol] [val : Value]) (Binding id (add-sto val sto))) ids vals) env)
      (dxuq-error "Function has wrong arity")))

(define (add-sto* [v : (Listof Value)] [sto : Store]) : Natural
  (define stovals (unbox sto))
  (set-box! sto (append stovals v))
  (length stovals))

(define (add-sto [v : Value] [sto : Store]): Natural
  (add-sto* (list v) sto))

(define (mutate-sto [v : Value] [sto : Store] [n : Natural])
  (set-box! sto (list-set (unbox sto) n v)))

(define (store) : Store (box '()))

;; Searches through a list of bindings for a given id, if the id is found the value in the binging is
;; returned, otherwise an unbound identifier error is raised
(define (lookup-env [id : Symbol] [env : Environment]): Natural
  (define binding (findf (λ ([b : Binding]) (equal? (Binding-name b) id)) env))
  (if binding (Binding-v binding) (dxuq-error "Unbound identifier ~e" id)))

(define (lookup-sto [i : Natural] [sto : Store]) : Value
  (list-ref (unbox sto) i))

(define (globals) : (Listof (List Symbol Value))
    (list
      (list 'true #t)
      (list 'false #f)
      (list 'null (void))
      (list '+ (binop-prim +))
      (list '* (binop-prim *))
      (list '- (binop-prim -))
      (list '/ (binop-prim /-safe))
      (list '<= (binop-prim <=))
      (list 'equal? (PrimV equal-prim 2))
      (list 'error (PrimV error-prim 1))
      (list 'new-array (PrimV new-array 2))
      (list 'array (PrimV create-array #f))
      (list 'aref (PrimV aref 2))
      (list 'aset! (PrimV aset! 3))
      (list 'begin (PrimV beg #f))))

(define (init-globals) : (Values Environment Store)
  (define sto : Store (store))
  (values (make-env (map (ann first ((List Symbol Value) → Symbol)) (globals))
                  (map (ann second ((List Symbol Value) → Value)) (globals)) '() sto) sto))

;; Given a function that expects 2 reals, creates a PrimV representation
(define (binop-prim [f : (Real Real → Value)]) : PrimV
  (PrimV (λ ([v : (Listof Value)] [_ : Store]) (f (real-E (first v)) (real-E (second v)))) 2))

;; Given a list containing 2 Values, returns whether they are both comparable and equal
(define (equal-prim [vals : (Listof Value)] [_ : Store]) : Boolean
  (and (andmap comparable? vals) (equal? (first vals) (second vals))))

;; Given a list containing 1 Value, raises an error containing DXUQ, user error, and the
;; serialization of the value
(define (error-prim [v : (Listof Value)] [_ : Store]) : Nothing
  (dxuq-error "user error: ~a" (serialize (first v))))

;; Given a value, determines whether it is comaprable, not a procedure
(define (comparable? [v : Value]) : Boolean
  (nor (PrimV? v) (ClosV? v)))

;; A version of division that thows our error (instead of the racket error) when dividing by 0
(define (/-safe [l : Real] [r : Real]) : Real
  (if (zero? r) (dxuq-error "Cannot divide ~e by 0" l) (/ l r)))


; number of copies, element
(define (new-array [l : (Listof Value)] [sto : Store]) : Value
  (create-array (make-list (natural-E (first l)) (second l)) sto))

(define (create-array [l : (Listof Value)] [sto : Store]) : ArrayV
  (if (empty? l) (dxuq-error "List of len 0 not allowed") (ArrayV (add-sto* l sto) (length l))))

(define (aref [l : (Listof Value)] [sto : Store]) : Value
  (define i (natural-E (second l)))
  (define arr (array-E (first l)))
  (if (>= i (ArrayV-len arr)) (dxuq-error "Index out of bounds") (lookup-sto (+ i (ArrayV-n arr)) sto)))

(define (aset! [l : (Listof Value)] [sto : Store]) : Value
  (define i (natural-E (second l)))
  (define arr (array-E (first l))) ;value sto index
  (if (>= i (ArrayV-len arr)) (dxuq-error "Index out of bounds") (mutate-sto (third l) sto (+ i (ArrayV-n arr)))))

(define (beg [l : (Listof Value)] [sto : Store])
  (if (empty? l) (dxuq-error "Empty begin not allowed") (last l)))

;; given a typechecking prediacte and a typename makes a wrapper function that ensures a value is of
;; that type and throws a type error otherwise
(define #:∀ (t) (type-check [f : (Value → Boolean : t)] [name : String]) : (Value → t)
  (λ ([v : Value]) (if (f v) v (dxuq-error "Type mismatch: ~a is not a ~a" (serialize v) name))))

(define real-E (type-check real? "Real"))
(define boolean-E (type-check boolean? "Boolean"))
(define natural-E (type-check natural? "Natural"))
(define array-E (type-check ArrayV? "Array"))


;; TESTS =============================================================================================

;;; top-interp
(check-equal? (top-interp 'true) "true")
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

(check-equal? (top-interp '{let {a = {array 1 2 3}} in {begin {aset! a 1 5} {+ {aref a 0} {aref a 1}}}}) "6")

(check-equal? (top-interp '{let {a = {new-array 3 "b"}} in {equal? a a}}) "true")
(check-equal? (top-interp '{let {a = {new-array 3 "b"}} {b = {new-array 3 "b"}} in {equal? a b}}) "false")

;; serialize
(check-equal? (serialize 5) "5")
(check-equal? (serialize "hello") "\"hello\"")
(check-equal? (serialize #t) "true")
(check-equal? (serialize #f) "false")
(check-equal? (serialize (binop-prim +)) "#<primop>")
(check-equal? (serialize (ClosV '(a b) 55 '())) "#<procedure>")
(check-equal? (serialize (ArrayV 0 0)) "#<array>")
(check-equal? (serialize (void)) "null")

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
(check-equal? (parse '{a <- (+ 2 3)}) (MutC 'a (AppC '+ '(2 3))))

;; id?
(check-equal? (id? 'c) #t)
(check-equal? (id? 12) #f)
(check-equal? (id? 'fn) #f)

;; FnC+
(check-equal? (FnC+ '(a b c) 4) (FnC '(a b c) 4))
(check-exn #px"Duplicate argument identifier" (λ () (FnC+ '(a a b) 4)))

;; Interpreting Tests --------------------------------------------------------------------------------

(check-equal? (interp 'id (list (Binding 'id 0)) (box '(33))) 33)
(check-equal? (interp (AppC (FnC '(x) 'x) '(22)) '() (store)) 22)
(check-equal? (interp (AppC (FnC '(x) (AppC (FnC '(a b) 'b) (list (MutC 'x 4) 'x))) '(10)) '() (store)) 4)
;
;; interp
;(check-equal? (interp 4 '()) 4)
;(check-equal? (interp "hello" '()) "hello")
;(check-equal? (interp 'id (list (Binding 'id 5))) 5)
;(check-equal? (interp (IfC 'true 1 2) (top-env)) 1)
;(check-equal? (interp (IfC 'false 1 2) (top-env)) 2)
;(check-equal? (interp (FnC '(a b c) "hello") (list (Binding 'id 5)))
;              (ClosV '(a b c) "hello" (list (Binding 'id 5))))
;(check-equal? (interp (AppC '+ (list 2 (AppC '- (list 10 (AppC '* (list 3 (AppC '/ '(3 1))))))))
;                      (top-env)) 3)
;(check-equal? (interp (AppC (FnC '(x y) (AppC '* '(x 10))) '(6 7)) (top-env)) 60)
;
;;; apply-func
;(check-equal? (apply-func (binop-prim +) '(1 2)) 3)
;(check-equal? (apply-func (ClosV '(a b) 'a '()) '(1 2)) 1)
;(check-equal? (apply-func (ClosV '(a) (AppC 'p '(a a)) (list (Binding 'p (binop-prim +)))) '(7)) 14)
;(check-exn #px"Primative has wrong arity" (λ () (apply-func (binop-prim +) '(1 2 4))))
;(check-exn #px"Could not apply function" (λ () (apply-func "nope" '(1 2 4))))
;
;;; make-env
;(check-equal? (make-env '() '() '()) '())
;(check-equal? (make-env '(a b c) '(4 "g" #t) (list (Binding 'g 4)))
;              (list (Binding 'a 4) (Binding 'b "g") (Binding 'c #t) (Binding 'g 4)))
;(check-exn #px"Function has wrong arity" (λ () (make-env '(x y) '(1) '())))
;
;;; lookup
;(check-equal? (lookup 'x (list (Binding 'x 10) (Binding 'y 20))) 10)
;(check-exn #px"Unbound identifier" (λ () (lookup 'y (list (Binding 'x 10)))))

;; binop-prim
(check-equal? (PrimV-arity (binop-prim +)) 2)
(check-equal? ((PrimV-f (binop-prim +)) '(3 4) (store)) 7)
(check-exn #px"Type mismatch: \"Q\" is not a Real" (λ () ((PrimV-f (binop-prim +)) '(3 "Q") (store))))

;; equal-prim
(check-equal? (equal-prim '(2 2) (store)) #t)
(check-equal? (equal-prim '(2 "II") (store)) #f)
(check-equal? (equal-prim (list (binop-prim +) #t) (store)) #f)
(check-equal? (equal-prim (list (binop-prim +) (binop-prim +)) (store)) #f)

;; error-prim
(check-exn #px"DXUQ: user error: true" (λ () (error-prim '(#t) (store))))
(check-exn #px"DXUQ: user error: #<procedure>" (λ () (error-prim (list (ClosV '() 1 '())) (store))))

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

