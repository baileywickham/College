#lang typed/racket
(require typed/rackunit)

;; Full project implemented

;; Data Definitions ==================================================================================

(struct FundefC ([name : Symbol] [arg : Symbol] [body : ExprC]) #:transparent)

(define-type ExprC (U BinopC IfC AppC Real Symbol))
(struct BinopC ([o : Op] [l : ExprC] [r : ExprC]) #:transparent)
(struct IfC ([f : ExprC] [t : ExprC] [e : ExprC]) #:transparent)
(struct AppC ([n : Symbol] [arg : ExprC]) #:transparent)

(define-type Op (U '+ '* '- '/))
(define-predicate op? Op) ;; This will break in unchecked typed racket

;; Functions =========================================================================================

;; Given a program in the surface language expressed as an s-expression, evaluates it and returns the
;; result, or raises an error if the program is malformatted
(define (top-interp [fun-sexps : Sexp]) : Real
  (interp-fns (parse-prog fun-sexps)))

;; Parseing ------------------------------------------------------------------------------------------

;; Given a program in the surface language expressed as an s-expression, converts it to a lisf of
;; function definitions
(define (parse-prog [s : Sexp]) : (Listof FundefC)
  (define funs (map parse-fundef (cast s (Listof Sexp))))
  (define dup (check-duplicates funs same-name?))
  (if dup (error 'parse-prog "DXUQ2: Function names must be unique: ~e" (FundefC-name dup))
      funs))

;; Given an s-expression representing the definition of a single function definition parses it to a
;; function definiton
(define (parse-fundef [s : Sexp]) : FundefC
  (match s
    [(list 'fundef  (list (? symbol? name) (? symbol? arg)) body)
     (FundefC (validate-id name) (validate-id arg) (parse body))]
    [other (error 'parse-fundef "DXUQ2: Unable to parse fundef ~e" other)]))

;; Converts an s-expression representing the body of a function to an ExprC representation
(define (parse [s : Sexp]) : ExprC
  (match s
    [(? real? n) n]
    [(? symbol? s) (validate-id s)]
    [(list (? op? o) l r) (BinopC o (parse l) (parse r))]
    [(list 'ifleq0 f t e) (IfC (parse f) (parse t) (parse e))]
    [(list (? symbol? s) arg) (AppC (validate-id s) (parse arg))]
    [other (error 'parse "DXUQ2: bad syntax in ~e" other)]))

;; Given a symbol representing an id, ensures that it does not conflict with a builtin name
(define (validate-id [s : Symbol]) : Symbol
  (if (nor (op? s) (eq? s 'ifleq0) (eq? s 'fundef)) s
      (error 'validate-id "DXUQ2: Id invalid: ~e" s)))

;; Checks if to function definitions share a name
(define (same-name? [a : FundefC] [b : FundefC]) : Boolean
  (eq? (FundefC-name a) (FundefC-name b)))


;; Interpreting --------------------------------------------------------------------------------------

;; Given a parsed representation of the program as a List of function definitions, evaluates it to a
;; Real by interpreting the main method
(define (interp-fns [funs : (Listof FundefC)]) : Real
  (interp (AppC 'main 0) funs))

;; Evaluates an expression represented as a ExprC and returns the real that results
(define (interp [ex : ExprC] [funs : (Listof FundefC)]) : Real
  (match ex
    [(? real? n) n]
    [(BinopC o l r) ((op-lookup o) (interp l funs) (interp r funs))]
    [(IfC f t e) (if (<= (interp f funs) 0) (interp t funs) (interp e funs))]
    [(AppC n arg) (call-function n arg funs)]
    [(? symbol? s) (error 'interp "DXUQ2: Unbound identifier: ~e" s)]))

;; Given the Op representation of a binary opperator returns the racket function to prefrom it
(define (op-lookup [o : Op]) : (-> Real Real Real)
  (match o ['+ +] ['* *] ['- -] ['/ /-safe]))

;; A version of division that thows our error (instead of the racket error) when dividing by 0
(define (/-safe [l : Real] [r : Real]) : Real
  (if (zero? r) (error '/-safe "DXUQ2: Cannot divide ~e by 0" l) (/ l r)))

;; Recursivly walks through a function's body replacing all occurneces of arg with v
(define (subst [expr : ExprC] [arg : Symbol] [v : Real]) : ExprC
  (match expr
    [(? symbol? s) (if (eq? s arg) v s)]
    [(? real? n) n]
    [(BinopC o l r) (BinopC o (subst l arg v) (subst r arg v))]
    [(IfC f t e) (IfC (subst f arg v) (subst t arg v) (subst e arg v))]
    [(AppC n l) (AppC n (subst l arg v ))]))

;; Given a function name and argument, calls the function or throws an error if the function is not
;; found in the list of functions
(define (call-function [name : Symbol] [arg : ExprC] [funs : (Listof FundefC)]) : Real
  (define f (memf (λ ([g : FundefC]) (eq? (FundefC-name g) name)) funs))
  (if f (interp (subst (FundefC-body (first f)) (FundefC-arg (first f)) (interp arg funs)) funs)
      (error 'call-function "DXUQ2: Unable to call function: ~e" name)))


;;; TESTS ============================================================================================

;; top-interp
(check-equal? (top-interp '{{fundef {main init} init}}) 0)
(check-equal? (top-interp '{{fundef {main init} {+ {multByTwo 3} {makePos -1}}}
                            {fundef {multByTwo a} {* a 2}}
                            {fundef {makePos a} {ifleq0 a {- 0 a} a}}}) 7)

;; round, rounds a number up or down
(check-equal? (top-interp '{{fundef {main init} {round 5.7}}
                            {fundef {floor n} {ifleq0 n -1 {+ 1 {round {- n 1}}}}}
                            {fundef {round a} {ifleq0 {- {- a {floor a}} .5} {floor a} {+ {floor a} 1}}}}) 6)

(check-equal? (top-interp '{{fundef {main init} {round 1.2}}
                            {fundef {floor n} {ifleq0 n -1 {+ 1 {round {- n 1}}}}}
                            {fundef {round a} {ifleq0 {- {- a {floor a}} .5} {floor a} {+ {floor a} 1}}}}) 1)

;; Parsing Tests -------------------------------------------------------------------------------------


;; parse-prog
(check-equal? (parse-prog '{{fundef {hello world} 1} {fundef {hi hello} hi}})
              (list (FundefC 'hello 'world 1) (FundefC 'hi 'hello 'hi)))
(check-equal? (parse-prog '{{fundef {main init} {+ {multByTwo 3} {makePos -1}}}
                            {fundef {multByTwo a} {* a 2}}
                            {fundef {makePos a} {ifleq0 a {- 0 a} a}}})
              (list (FundefC 'main 'init (BinopC '+ (AppC 'multByTwo 3) (AppC 'makePos -1)))
                    (FundefC 'multByTwo 'a (BinopC '* 'a 2))
                    (FundefC 'makePos 'a (IfC 'a (BinopC '- 0 'a) 'a))))

(check-exn #px"Function names must be unique"
           (λ () (parse-prog '{{fundef {hello world} 1} {fundef {hello world} hi}})))
(check-exn #px"Id invalid"
           (λ () (parse-prog '{{fundef {ifleq0 world} 1}})))
(check-exn #px"Id invalid"
           (λ () (parse-prog '{{fundef {hello +} 1}})))

;; parse-fundef
(check-equal? (parse-fundef '{fundef {hello world} 1})
              (FundefC 'hello 'world 1))
(check-equal? (parse-fundef '{fundef {sumWith5 a} {+ a 5}})
              (FundefC 'sumWith5 'a (BinopC '+ 'a 5)))
(check-exn #px"Unable to parse fundef"
           (λ () (parse-fundef '{fundef {hello a b} 1})))
(check-exn #px"Unable to parse fundef"
           (λ () (parse-fundef '{fundef {} {+ 2 3}})))

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
(check-equal? (same-name? (FundefC 'name 'a1 3) (FundefC 'name 'a2 3)) #t)
(check-equal? (same-name? (FundefC 'name 'a1 3) (FundefC 'other-name 'a2 3)) #f)

;; Interpreting Tests --------------------------------------------------------------------------------

;; interp-fns
(check-equal? (interp-fns (list (FundefC 'main 'init 'init))) 0)
(check-equal? (interp-fns (list (FundefC 'main 'init (AppC 'f 3))
                                (FundefC 'f 'a (BinopC '+ 1 'a)))) 4)
(check-exn #px"Unable to call function" (λ () (interp-fns '())))

;; interp
(check-equal? (interp 4 '()) 4)
(check-equal? (interp (BinopC '/ 10 5) '()) 2)
(check-equal? (interp (IfC 3 4 5) '()) 5)
(check-equal? (interp (IfC -3 4 5) '()) 4)
(check-equal? (interp (AppC 'f 5) (list (FundefC 'f 'a (BinopC '* 'a 2)))) 10)
(check-exn #px"Unbound identifier" (λ () (interp 'a '())))

;; op-lookup
(check-equal? (op-lookup '+) +)
(check-equal? (op-lookup '/) /-safe)

;; /-safe
(check-equal? (/-safe 2 1) 2)
(check-exn #px"Cannot divide 3 by 0" (λ () (/-safe 3 0)))

;; subst
(check-equal? (subst 'a 'a 3) 3)
(check-equal? (subst 'a 'b 3) 'a)
(check-equal? (subst (BinopC '- 3 4) 'a 3) (BinopC '- 3 4))
(check-equal? (subst (IfC 'a 'b 'c) 'a 5) (IfC 5 'b 'c))
(check-equal? (subst (AppC 'a 'a) 'a 5) (AppC 'a 5))

;; call-function
(check-equal? (call-function 'f (BinopC '+ 3 4) (list (FundefC 'f 'a (BinopC '* 3 'a)))) 21)
(check-exn #px"Unable to call function" (λ () (call-function 'f 3 '())))

