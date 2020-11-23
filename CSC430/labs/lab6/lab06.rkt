#lang typed/racket
(require typed/racket/random)
(require typed/rackunit)



;; Data Definitions ==================================================================================

(define-type ExprC (U Real String Symbol Boolean IfC AppC FnC))
(struct IfC ([f : ExprC] [t : ExprC] [e : ExprC]) #:transparent)
(struct FnC ([args : (Listof Symbol)] [body : ExprC]) #:transparent)
(struct AppC ([f : ExprC] [args : (Listof ExprC)]) #:transparent)

;; Constants -----------------------------------------------------------------------------------------

(define symbols : (Listof Symbol) '(a b c d e f g h))
(define strings : (Listof String) '("!" "@" "#" "$" "%" "^" "&"))
(define difficulty : Natural 3)

;; Functions =========================================================================================

;; Runs a little quiz, printing the expression in the DXUQ syntax and returning the parsed
;; representation
(define (quiz) : ExprC
  (define e (random-term difficulty))
  (printf "Quiz:\n~a\n" (unparse e))
  e)

;; Given a parsed representation of a DUXQ expression returns an S-expression in the surface syntax
(define (unparse [e : ExprC]) : Sexp
  (match e
    [(or (? real? v) (? string? v) (? symbol? v) (? boolean? v)) v]
    [(IfC f t e) `{if ,(unparse f) ,(unparse t) ,(unparse e)}]
    [(FnC vars body) `{fn ,vars ,(unparse body)}]
    [(AppC f args) `{,(unparse f) ,@(map unparse args)}]))

;; Returns a random, likely invalid, ExprC term of depth at least max-depth
(define (random-term [max-depth : Natural]) : ExprC
  (if (zero? max-depth) (random-base-term)
      (let ([next-term (λ () (random-term (sub1 max-depth)))])
        (one-of-these
         (IfC (next-term) (next-term) (next-term))
         (FnC (list-of random-symbol (random 4)) (next-term))
         (AppC (next-term) (list-of next-term (random 4)))))))

;; Returns a random ExprC that contains no other ExprCs
(define (random-base-term) : ExprC
  (one-of-these
   (random 10)
   (random-symbol)
   (random-string)
   (random-boolean)))

;; Returns a list of a given length where each element is the result of calling f
(: list-of (∀ (a) ((-> a) Natural -> (Listof a))))
(define (list-of f n)
  (if (zero? n) '() (cons (f) (list-of f (sub1 n)))))

;; Given a set of expressions randomly returns the value of evaluating one of them
(define-syntax-rule (one-of-these e ...)
  ((random-ref (list
               (λ () e) ...))))

;; Returns a random symbol from the list of symbol constants
(define (random-symbol) : Symbol (random-ref symbols))

;; Returns a random string from the list of string constants
(define (random-string) : String (random-ref strings))

;; Returns a random string from the list of string constants
(define (random-boolean) : Boolean (random-ref '(#t #f)))

;; ---------------------------------------------------------------------------------------------------

(define secret (quiz))

;; Optional Super-PL Fuzzing Section =================================================================

;; Asgn 4 Copy + Paste -------------------------------------------------------------------------------

(define-type Environment (Listof Binding))
(struct Binding ([name : Symbol] [v : Value]) #:transparent)

(define-type Value (U Real String Boolean ClosV PrimV))
(struct ClosV ([args : (Listof Symbol)] [body : ExprC] [env : Environment]) #:transparent)
(struct PrimV ([f : ((Listof Value) → (U Value Nothing))] [arity : Natural]) #:transparent)

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

;; Wraps a value and Ensures it is a Boolean, throwing an error otherwise
(define (boolean-E [v : Value]) : Boolean
  (if (boolean? v) v (dxuq-error "Type mismatch: ~a is not a Boolean" (serialize v))))

;; Throws an error starting with "DXUQ" so that it is clear the error is not a failure of the
;; interpreter but instead a validly rasied issue with the program being interpreted
(define (dxuq-error [message : String] . [values : Any *]) : Nothing
  (apply error 'DXUQ message values))

;; Given a value, returns a string representation
(define (serialize [v : Value]) : String
  (match v
    [(? ClosV?) "#<procedure>"]
    [(? PrimV?) "#<primop>"]
    [#t "true"]
    [#f "false"]
    [other (~v other)]))

;; --------------------------------------------------------------------------------------------------

(define (run-trials [num : Natural] [e : (-> ExprC)]) : Natural
  (if (zero? num) 0
      (+ (run-trials (sub1 num) e)
         (with-handlers ([exn:fail? (lambda (v) 0)])
           (if (interp (e) '()) 1 1)))))

(define (random-closed-term [max-depth : Natural] [vars : (Listof Symbol)]) : ExprC
  (if (zero? max-depth) (random-closed-base-term vars)
      (let ([next-term (λ () (random-closed-term (sub1 max-depth) vars))])
        (one-of-these
         (IfC (next-term) (next-term) (next-term))
         (let ([args (list-of random-symbol (random 4))])
           (FnC args (random-closed-term (sub1 max-depth) (append args vars))))
         (AppC (next-term) (list-of next-term (random 4)))))))

;; Returns a random ExprC that contains no other ExprCs
(define (random-closed-base-term [vars : (Listof Symbol)]) : ExprC
  (if (empty? vars)
      (one-of-these (random 10) (random-string) (random-boolean))
      (one-of-these (random 10) (random-string) (random-boolean) (random-ref vars))))


(define (random-shrunk-term [max-depth : Natural] [vars : (Listof Symbol)]) : ExprC
  (if (zero? max-depth) (random-base-term)
      (one-of-these
       (let ([arg (random-symbol)])
         (FnC (list arg) (random-shrunk-term (sub1 max-depth) (cons arg vars))))
       (AppC (random-shrunk-term (sub1 max-depth) vars)
             (list (random-shrunk-term (sub1 max-depth) vars))))))

;; Returns a random ExprC that contains no other ExprCs
(define (random-shrunk-base-term [vars : (Listof Symbol)]) : ExprC
  (one-of-these (random-ref vars) (FnC '(b) 'b)))

;; ---------------------------------------------------------------------------------------------------

(printf "Random Term Depth 3: ~a/1000\n" (run-trials 1000 (λ () (random-term 3))))
(printf "Random Closed Term Depth 3: ~a/1000\n" (run-trials 1000 (λ () (random-closed-term 3 '()))))

;; TESTS =============================================================================================

(check-equal? (unparse 4) 4)
(check-equal? (unparse "hey") "hey")
(check-equal? (unparse 'id) 'id)
(check-equal? (unparse (IfC 4 5 (IfC 'true 3 6))) '{if 4 5 {if true 3 6}})
(check-equal? (unparse (FnC '(a b c) (AppC '+ '(a 6)))) '{fn {a b c} {+ a 6}})

;; bv5nr0
