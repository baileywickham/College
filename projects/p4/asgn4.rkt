#lang typed/racket
(require typed/rackunit)

;; Full project implemented

;; Data Definitions ==================================================================================

(define-type ExprC (U IfC AppC Real Symbol String LamC))
(struct IfC ([f : ExprC] [t : ExprC] [e : ExprC]) #:transparent)
(struct LamC ([args : (Listof Symbol)] [body : ExprC]) #:transparent)
(struct AppC ([f : ExprC] [args : (Listof ExprC)]) #:transparent)

(define-type Environment (Listof Binding))
(struct Binding ([name : Symbol] [v : Value]) #:transparent)

(define-type Value (U Real String Boolean ClosV PrimV))
(struct ClosV ([args : (Listof Symbol)] [body : ExprC] [env : Environment]) #:transparent)
(struct PrimV ([f : ((Listof Value) -> (U Value Nothing))] [arity : Natural]) #:transparent)


;; Functions =========================================================================================



;; Given a program in the surface language expressed as an s-expression, evaluates it and returns the
;; result, or raises an error if the program is malformatted
(define (top-interp [s : Sexp]) : String
  (serialize (interp (parse s) top-env)))

;; Given a value, returns a string representation
(define (serialize [v : Value]) : String
    (match v
      [(? ClosV?) "#<procedure>"]
      [(? PrimV?) "#<primop>"]
      [(? boolean? b) (if b "true" "false")]
      [other (~v other)]))

;; Throws an error starting with "DXUQ" so that it is clear the error is not a failure of the
;; interpreter but instead a validly rasied issue with the program being interpreted
(define (dxuq-error [message : String] . [values : Any *]) : Nothing
  (apply error (cast (append (list 'DXUQ message) values) (List* Symbol String (Listof Any)))))

;; Parseing ------------------------------------------------------------------------------------------

;; Converts an s-expression representing the body of a function to an ExprC representation
(define (parse [s : Sexp]) : ExprC
  (match s
    [(? real? n) n]
    [(? string? s) s]
    [(? symbol? s) (validate-id s)]
    [(list 'vars (list (? list? vars) ...) e) (desugar-vars (cast vars (Listof (Listof Sexp))) e)]
    [(list 'if f t e) (IfC (parse f) (parse t) (parse e))]
    [(list 'lam (list (? symbol? args) ...) body) (LamC (map validate-id args) (parse body))]
    [(list f args ...) (AppC (parse f) (map parse args))]
    [other (dxuq-error "bad syntax in ~e" other)]))

;;
(define (desugar-vars [vars : (Listof (Listof Sexp))] [e : Sexp]) : AppC
  (define args (foldl (λ ([v : (Listof Sexp)] [l : (List (Listof Symbol) (Listof ExprC))]) : (List (Listof Symbol) (Listof ExprC))
            (if (= (length v) 2)
              (list (cons (validate-id (first v)) (first l))
                    (cons (parse (second v)) (second l)))
              (dxuq-error "Malformatted vars ~e" vars)))
         '(()()) vars))
  (AppC (LamC (first args) (parse e)) (second args)))

;; Given a representation of an id, ensures that it is a symbol does not conflict with a builtin name
(define (validate-id [s : Any]) : Symbol
  (if (and (symbol? s) (nor (equal? s 'if) (equal? s 'vars) (equal? s 'lam))) s
      (dxuq-error "Id invalid: ~e" s)))

;; Interpreting --------------------------------------------------------------------------------------

;; Evaluates an expression represented as a ExprC and returns the real that results
(define (interp [ex : ExprC]  [env : Environment]) : Value
  (match ex
    [(? real? n) n]
    [(? string? s) s]
    [(? symbol? s) (lookup s env)]
    [(IfC f t e) (if (check-boolean (interp f env)) (interp t env) (interp e env))]
    [(LamC args body) (ClosV args body env)]
    [(AppC f args) (apply-AppC (interp f env) args env)]))

(define (apply-AppC [f : Value] [args : (Listof ExprC)] [env : Environment]) : Value
  (define interp-args (map (λ ([_a : ExprC]) (interp _a env)) args))
  (match f
    [(PrimV o n) (if (= (length interp-args) n) (o interp-args) (dxuq-error "Wrong arity ~e" n))]
    [(ClosV ids body env2) (interp body (make-env ids interp-args env2))]
    [other dxuq-error "Unable to apply ~e" f]))


(define (check-real [v : Value]) : Real
  (if (real? v) v (dxuq-error "Type mismatch: ~e is not Real" v)))

(define (check-boolean [v : Value]) : Boolean
  (if (boolean? v) v (dxuq-error "Type mismatch: ~e is not Boolean" v)))
;; A version of division that thows our error (instead of the racket error) when dividing by 0
(define (/-safe [l : Real] [r : Real]) : Real
  (if (zero? r) (dxuq-error "Cannot divide ~e by 0" l) (/ l r)))

;; Given a list of argument names and values, matches them into a list of bindings or raises an error
;; if the arity does not match. Preprends this to an existing environment
(define (make-env [ids : (Listof Symbol)] [vals : (Listof Value)] [env : Environment]) : Environment
  (if (= (length ids) (length vals)) (append (map Binding ids vals) env)
      (dxuq-error "Function has wrong arity")))

;; Searches through a list of bindings for a given id, if the id is found the value in thebinging is
;; returned, otherwise an unbound identifier error is raised
(define (lookup [id : Symbol] [env : Environment]): Value
  (define binding (findf (λ ([b : Binding]) (equal? (Binding-name b) id)) env))
  (if binding (Binding-v binding) (dxuq-error "Unbound identifier ~e" id)))


(define (binop-prim [f : (Real Real -> Value)]) : PrimV
  (PrimV (λ  ([v : (Listof Value)]) (f (check-real (first v)) (check-real (second v)))) 2))

(define (dxuq-equal [v : (Listof Value)]) : Boolean
  (and (nor (ormap PrimV? v) (ormap ClosV? v)) (equal? (first v) (second v))))

(define (user-error [v : (Listof Value)]) : Nothing
  (dxuq-error "user error: ~e" (serialize (first v))))


(define top-env (list
                  (Binding 'true #t)
                  (Binding 'false #f)
                  (Binding '+ (binop-prim +))
                  (Binding '* (binop-prim *))
                  (Binding '- (binop-prim -))
                  (Binding '/ (binop-prim /-safe))
                  (Binding '<= (binop-prim <=))
                  (Binding '=? (PrimV dxuq-equal 2))
                  (Binding 'error (PrimV user-error 1))))

;; TESTS =============================================================================================

(check-equal? (top-interp '{+ 2 3}) "5")
(check-equal? (top-interp '{{lam {a b} {+ a b}} 2 3}) "5")
(check-equal? (top-interp '{vars {{a 2} {f {lam {x y} {* x y}}}} {f a 3}}) "6")
(check-equal? (top-interp '{if true "hello" "hi"}) "\"hello\"")
(check-equal? (top-interp '{<= 2 2}) "true")

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
(check-equal? (parse '{lam {x y} {+ x y}}) (LamC '(x y) (AppC '+ '(x y))))
(check-equal? (parse '{{lam {x y} {+ x y}} 2 {+ 2 4}})
              (AppC (LamC '(x y) (AppC '+ '(x y))) (list 2 (AppC '+ '(2 4)))))
(check-equal? (parse '{vars {{a 2}} {+ a 3}}) (AppC (LamC '(a) (AppC '+ '(a 3))) '(2)))
(check-exn #px"bad syntax" (λ () (parse '{})))

;; validate-id
(check-equal? (validate-id 'id) 'id)
(check-exn #px"Id invalid" (λ () (validate-id 'lam)))
(check-exn #px"Id invalid" (λ () (validate-id 23)))

;; Interpreting Tests --------------------------------------------------------------------------------

;;; interp
;(check-equal? (interp 4 '() '()) 4)
;(check-equal? (interp (BinopC '/ 10 5) '() '()) 2)
;(check-equal? (interp (IfC 3 4 5) '() '()) 5)
;(check-equal? (interp (IfC -3 4 5) '() '()) 4)
;(check-equal? (interp (AppC 'f '(5)) (list (FundefC 'f '(a) (BinopC '* 'a 2))) '()) 10)
;(check-equal? (interp "hello" '() '()) "hello")
;(check-exn #px"Unbound identifier" (λ () (interp 'a '() '())))

;; /-safe
(check-equal? (/-safe 2 1) 2)
(check-exn #px"Cannot divide 3 by 0" (λ () (/-safe 3 0)))

;; make-env
(check-equal? (make-env '() '() '()) '())
(check-equal? (make-env '(a b c) '(4 "g" #t) (list (Binding 'g 4)))
              (list (Binding 'a 4) (Binding 'b "g") (Binding 'c #t) (Binding 'g 4)))
(check-exn #px"Function has wrong arity" (λ () (make-env '(x y) '(1) '())))

;; lookup
(check-equal? (lookup 'x (list (Binding 'x 10) (Binding 'y 20))) 10)
(check-exn #px"Unbound identifier" (λ () (lookup 'y (list (Binding 'x 10)))))
