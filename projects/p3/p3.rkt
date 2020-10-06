#lang typed/racket
(require typed/rackunit)

;; Full project implemented

;; Data Definitions ==================================================================================

(struct FundefC ([name : Symbol] [args : (Listof Symbol)] [body : ExprC]) #:transparent)

(define-type ExprC (U BinopC IfC AppC Real Symbol))
(struct BinopC ([o : Op] [l : ExprC] [r : ExprC]) #:transparent)
(struct IfC ([f : ExprC] [t : ExprC] [e : ExprC]) #:transparent)
(struct AppC ([n : Symbol] [args : (Listof ExprC)]) #:transparent)

(define-type Op (U '+ '* '- '/))
(define-predicate op? Op) ;; This will break in unchecked typed racket

(struct Binding ([name : Symbol][v : Real]) #:transparent)

;; Functions =========================================================================================

;; Given a program in the surface language expressed as an s-expression, evaluates it and returns the
;; result, or raises an error if the program is malformatted
(define (top-interp [fun-sexps : Sexp]) : Real
  (interp-fns (parse-prog fun-sexps)))

;; Throws an error starting with "DXUQ" so that it is clear the error is not a failure of the
;; interpreter but instead a validly rasied issue with the program being interpreted
(define (dxuq-error [message : String] [expression : Sexp])
  (error 'DXUQ message expression))

;; Parseing ------------------------------------------------------------------------------------------

;; Given a program in the surface language expressed as an s-expression, converts it to a lisf of
;; function definitions
(define (parse-prog [s : Sexp]) : (Listof FundefC)
  (define funs (map parse-fundef (cast s (Listof Sexp))))
  (define dup (check-duplicates funs same-name?))
  (if dup (dxuq-error "Function names must be unique: ~e" (FundefC-name dup)) funs))

;; Given an s-expression representing the definition of a single function definition parses it to a
;; function definiton
(define (parse-fundef [s : Sexp]) : FundefC
  (match s
    [(list 'fundef  (list (? symbol? name) (? symbol? args) ...) body)
     (if (check-duplicates args equal?) (dxuq-error "Duplicate argument identifier ~e" '())
     (FundefC (validate-id name) (map validate-id (cast args (Listof Symbol))) (parse body)))]
    [other (dxuq-error "Unable to parse fundef ~e" other)]))

;; Converts an s-expression representing the body of a function to an ExprC representation
(define (parse [s : Sexp]) : ExprC
  (match s
    [(? real? n) n]
    [(? symbol? s) (validate-id s)]
    [(list (? op? o) l r) (BinopC o (parse l) (parse r))]
    [(list 'ifleq0 f t e) (IfC (parse f) (parse t) (parse e))]
    [(list (? symbol? s) args ...) (AppC (validate-id s) (map parse args))]
    [other (dxuq-error "bad syntax in ~e" other)]))

;; Given a symbol representing an id, ensures that it does not conflict with a builtin name
(define (validate-id [s : Symbol]) : Symbol
  (if (nor (op? s) (equal? s 'ifleq0) (equal? s 'fundef)) s
      (dxuq-error "Id invalid: ~e" s)))

;; Checks if to function definitions share a name
(define (same-name? [a : FundefC] [b : FundefC]) : Boolean
  (equal? (FundefC-name a) (FundefC-name b)))


;; Interpreting --------------------------------------------------------------------------------------

;; Given a parsed representation of the program as a List of function definitions, evaluates it to a
;; Real by interpreting the main method
(define (interp-fns [funs : (Listof FundefC)]) : Real
  (interp (AppC 'main '()) funs))

;; Evaluates an expression represented as a ExprC and returns the real that results
(define (interp [ex : ExprC] [funs : (Listof FundefC)]) : Real
  (match ex
    [(? real? n) n]
    [(BinopC o l r) ((op-lookup o) (interp l funs) (interp r funs))]
    [(IfC f t e) (if (<= (interp f funs) 0) (interp t funs) (interp e funs))]
    [(AppC n args) (call-function n args funs)]
    [(? symbol? s) (dxuq-error "Unbound identifier: ~e" s)]))

;; Given the Op representation of a binary opperator returns the racket function to prefrom it
(define (op-lookup [o : Op]) : (-> Real Real Real)
  (match o ['+ +] ['* *] ['- -] ['/ /-safe]))

;; A version of division that thows our error (instead of the racket error) when dividing by 0
(define (/-safe [l : Real] [r : Real]) : Real
  (if (zero? r) (dxuq-error "Cannot divide ~e by 0" l) (/ l r)))

;; Recursivly walks through a function's body replacing all occurneces of arg with v
(define (subst [expr : ExprC] [bindings : (Listof Binding)]) : ExprC
  (match expr
    [(? symbol? s) (get-binding s bindings)]
    [(? real? n) n]
    [(BinopC o l r) (BinopC o (subst l bindings) (subst r bindings))]
    [(IfC f t e) (IfC (subst f bindings) (subst t bindings) (subst e bindings))]
    [(AppC n l) (AppC n (map (λ ([_l : ExprC]) (subst _l bindings)) l))]))
    ;[(AppC n l) (AppC n (map (λ ([_l : ExprC]) (subst _l arg v)) l))]))
; the λ here is for allowing a multi argument map function.

;; Given a function name and argument, calls the function or throws an error if the function is not
;; found in the list of functions
(define (call-function [name : Symbol] [args : (Listof ExprC)] [funs : (Listof FundefC)]) : Real
  (define f (memf (λ ([g : FundefC]) (equal? (FundefC-name g) name)) funs))
  (if f (interp (subst (FundefC-body (first f)) (make-bindings (FundefC-args (first f)) (map (λ ([_a : ExprC]) (interp _a funs)) args))) funs)
      (dxuq-error "Unable to call function: ~e" name)))


(define (make-bindings  [names : (Listof Symbol)] [v : (Listof Real)]) : (Listof Binding)
  (cond [(and (empty? names ) (empty? v)) '()]
        [(or (empty? names ) (empty? v)) (dxuq-error "wrong arity ~e" '())]
        [else (cons (Binding (first names)(first v)) (make-bindings (rest names) (rest v)))]))

(define (get-binding [s : Symbol] [bindings : (Listof Binding)]): Real
  (define v (memf (λ ([b : Binding]) (equal? (Binding-name b) s)) bindings))
  (if v (Binding-v (first v)) (dxuq-error "Unbound identifier ~e" s)))

;;; TESTS ============================================================================================

; tests provided in the assignment
(check-equal? (interp-fns
       (parse-prog '{{fundef {f x y} {+ x y}}
                     {fundef {main} {f 1 2}}}))
      3)
(check-equal? (interp-fns
       (parse-prog '{{fundef {f} 5}
                     {fundef {main} {+ {f} {f}}}}))
      10)
(check-exn #px"wrong arity"
           (λ ()
             (interp-fns
              (parse-prog '{{fundef {f x y} {+ x y}}
                            {fundef {main} {f 1}}}))))

;; top-interp
(check-equal? (top-interp '{{fundef {main} 0}}) 0)
(check-equal? (top-interp '{{fundef {main} {+ {multByTwo 3} {makePos -1}}}
                            {fundef {multByTwo a} {* a 2}}
                            {fundef {makePos a} {ifleq0 a {- 0 a} a}}}) 7)

(check-equal? (top-interp '{{fundef {main} {add 2 2}}
                            {fundef {add a b}{+ a b}}}) 4)
;
;; round, rounds a real to an integer
(define round-prog '{{fundef {round n} {ifleq0 n {* -1 {round+ {* -1 n}}} {round+ n}}}
                     {fundef {round+ n} {floor {+ n 0.5}}}
                     {fundef {floor n} {ifleq0 {lt0? n} -1 {+ 1 {floor {- n 1}}}}}
                     {fundef {lt0? n} {ifleq0 {* -1 n} 1 0}}})

(check-equal? (top-interp (cast (cons '{fundef {main} {round 1.2}} round-prog) Sexp)) 1)
(check-equal? (top-interp (cast (cons '{fundef {main} {round 0}} round-prog) Sexp)) 0)
(check-equal? (top-interp (cast (cons '{fundef {main} {round 9.9}} round-prog) Sexp)) 10)
(check-equal? (top-interp (cast (cons '{fundef {main} {round -5}} round-prog) Sexp)) -5)

; dxuq-error
(check-exn #px"DXUQ: test error: \'[(]a b c[)]" (λ () (dxuq-error "test error: ~e" '(a b c))))
;
;; Parsing Tests -------------------------------------------------------------------------------------


;; parse-prog
(check-equal? (parse-prog '{{fundef {hello world} 1} {fundef {hi hello} hi}})
              (list (FundefC 'hello '(world) 1) (FundefC 'hi '(hello) 'hi)))
(check-equal? (parse-prog '{{fundef {main} {+ {multByTwo 3} {makePos -1}}}
                            {fundef {multByTwo a} {* a 2}}
                            {fundef {makePos a} {ifleq0 a {- 0 a} a}}})
              (list (FundefC 'main '() (BinopC '+ (AppC 'multByTwo '(3)) (AppC 'makePos '(-1))))
                    (FundefC 'multByTwo '(a) (BinopC '* 'a 2))
                    (FundefC 'makePos '(a) (IfC 'a (BinopC '- 0 'a) 'a))))

(check-exn #px"Function names must be unique"
           (λ () (parse-prog '{{fundef {hello world} 1} {fundef {hello world} hi}})))
(check-exn #px"Id invalid"
           (λ () (parse-prog '{{fundef {ifleq0 world} 1}})))
(check-exn #px"Id invalid"
           (λ () (parse-prog '{{fundef {hello +} 1}})))

;;; parse-fundef
(check-equal? (parse-fundef '{fundef {hello} 1})
              (FundefC 'hello '() 1))
(check-equal? (parse-fundef '{fundef {sumWith5 a} {+ a 5}})
              (FundefC 'sumWith5 '(a) (BinopC '+ 'a 5)))
(check-exn #px"Unable to parse fundef"
           (λ () (parse-fundef '{fundef {} {+ 2 3}})))

(check-exn #px"Duplicate"
           (λ ()(parse-fundef '{fundef {f a a} 0})))

;; parse
(check-equal? (parse '{+ 2 2}) (BinopC '+ 2 2))
(check-equal? (parse '{* 2 {+ -1 2}}) (BinopC '* 2 (BinopC '+ -1 2)))
(check-equal? (parse '2) 2)
(check-equal? (parse '{ifleq0 0 0 {+ 2 2}}) (IfC 0 0 (BinopC '+ 2 2)))
(check-equal? (parse 'abc) 'abc)
(check-exn #px"bad syntax" (λ () (parse '{})))

;; validate-id
(check-equal? (validate-id 'id) 'id)
(check-exn #px"Id invalid" (λ () (validate-id '+)))
(check-exn #px"Id invalid" (λ () (validate-id 'fundef)))

;; same-name?
(check-equal? (same-name? (FundefC 'name '(a1) 3) (FundefC 'name '(a2) 3)) #t)
(check-equal? (same-name? (FundefC 'name '(a1) 3) (FundefC 'other-name '(a2) 3)) #f)

;; Interpreting Tests --------------------------------------------------------------------------------
;
;; interp-fns
(check-equal? (interp-fns (list (FundefC 'main '() 0))) 0)
(check-equal? (interp-fns (list (FundefC 'main '() (AppC 'f '(3)))
                                (FundefC 'f '(a) (BinopC '+ 1 'a)))) 4)
(check-exn #px"Unable to call function" (λ () (interp-fns '())))

;; interp
(check-equal? (interp 4 '()) 4)
(check-equal? (interp (BinopC '/ 10 5) '()) 2)
(check-equal? (interp (IfC 3 4 5) '()) 5)
(check-equal? (interp (IfC -3 4 5) '()) 4)
(check-equal? (interp (AppC 'f '(5)) (list (FundefC 'f '(a) (BinopC '* 'a 2)))) 10)
(check-exn #px"Unbound identifier" (λ () (interp 'a '())))

; op-lookup
(check-equal? (op-lookup '+) +)
(check-equal? (op-lookup '/) /-safe)

;; /-safe
(check-equal? (/-safe 2 1) 2)
(check-exn #px"Cannot divide 3 by 0" (λ () (/-safe 3 0)))

; subst
(check-equal? (subst 'a (list (Binding 'a 3))) 3)
(check-equal? (subst (BinopC '- 3 4) (list (Binding 'a 3) (Binding 'b 4))) (BinopC '- 3 4))
(check-equal? (subst (IfC 'a 'b 'c) (list (Binding 'a 5) (Binding 'b 3)(Binding 'c 2))) (IfC 5 3 2))
(check-equal? (subst (AppC 'a '(a)) (list (Binding 'a 5))) (AppC 'a '(5)))
;
;;; call-function
(check-equal? (call-function 'f (list (BinopC '+ 3 4)) (list (FundefC 'f '(a) (BinopC '* 3 'a)))) 21)
(check-exn #px"Unable to call function" (λ () (call-function 'f '(3) '())))

