#lang typed/racket
(require typed/rackunit)

;; Data Definitions ==================================================================================

(struct FundefC ([name : Symbol] [args : (Listof Symbol)] [body : ExprC]) #:transparent)

(define-type ExprC (U BinopC NumC IfC IdC AppC))
(struct NumC ([r : Real]) #:transparent)
(struct IdC ([s : Symbol]) #:transparent)
(struct AppC ([n : Symbol] [params : (Listof ExprC)]) #:transparent)
(struct BinopC ([o : Symbol] [l : ExprC] [r : ExprC]) #:transparent)
(struct IfC ([f : ExprC] [t : ExprC] [e : ExprC]) #:transparent)

;; Functions =========================================================================================

;; Given a program in the surface language expressed as an s-expression, evaluates it and returns the
;; result, or raises an error if the program is malformatted
(define (top-interp [fun-sexps : Sexp]) : Real
  (interp-fns (parse-prog fun-sexps)))

;; Parseing ------------------------------------------------------------------------------------------

;; Given a program in the surface language expressed as an s-expression, converts it to a lisf of
;; function definitions
(define (parse-prog [s : Sexp]) : (Listof FundefC)
  (map parse-fundef (cast s (Listof Sexp))))

;; Given an s-expression representing the definition of a single function definition parses it to a
;; function definiton
(define (parse-fundef [s : Sexp]) : FundefC
  (match s
    [(list 'fn (? list? header) body) (FundefC (first (cast header (Listof Symbol)))
                                               (rest (cast header (Listof Symbol))) (parse body))]
    [other (error 'parse-fundef "AQSE: Unable to parse fundef ~e" other)]))

;; Converts an s-expression representing the body of a function to an ExprC representation
(define (parse [s : Sexp]) : ExprC
  (match s
    [(? real? n) (NumC n)]
    [(? symbol? s) (IdC s)]
    [(list (? is-builtin? o) l r) (BinopC (cast o Symbol) (parse l) (parse r))]
    [(list 'ifleq0 f t e) (IfC (parse f) (parse t) (parse e))]
    [(list (? symbol? s) args ...) (AppC s (map parse args))]
    [other (error 'parse "AQSE: Unable to parse: ~e" other)]))

;;
(define (is-builtin? [f : Any]) : Boolean
  (or (eq? '+ f) (eq? '* f) (eq? '- f) (eq? '/ f)))


;; Interpreting --------------------------------------------------------------------------------------

;; Given a parsed representation of the program as a List of function definitions, evaluates it to a
;; Real by interpreting the main method
(define (interp-fns [funs : (Listof FundefC)]) : Real
  (interp (AppC 'main '()) funs))

;; Evaluates an expression represented as a ExperC and returns the real that results
(define (interp [ex : ExprC] [funs : (Listof FundefC)]) : Real
  (match ex
    [(IdC i) 0]
    [(AppC n l) 0]
    [(NumC n) n]
    [(BinopC o l r) ((table o) (interp l funs) (interp r funs))]
    [(IfC f t e) (if (<= (interp f funs) 0) (interp t funs) (interp e funs))]))

;;
(define (table [s : Symbol]) : (-> Real Real Real)
  (match s
    ['+ +] ['* *] ['- -] ['/ /]
    [other (error 'table "AQSE: Binop not found: ~e" other)]))


;; TESTS =============================================================================================

(check-equal? (interp-fns
                (parse-prog '{{fn {f x y} {+ x y}}
                            {fn {main} {f 1 2}}}))
              3)
(check-equal? (interp-fns
                (parse-prog '{{fn {f} 5}
                            {fn {main} {+ {f} {f}}}}))
              10)
(check-exn #px"wrong arity"
           (λ ()
              (interp-fns
                (parse-prog '{{fn {f x y} {+ x y}}
                            {fn {main} {f 1}}}))))


;; Parsing Tests -------------------------------------------------------------------------------------

;; parse-prog
(check-equal? (parse-prog '{{fn {hello} 1} {fn {hi} hi}})
              (list (FundefC 'hello '() (NumC 1)) (FundefC 'hi '() (IdC 'hi))))
(check-equal? (parse-prog '{{fn {main} {+ {multByTwo 3} {makePos -1}}}
                            {fn {multByTwo a} {* a 2}}
                            {fn {makePos a} {ifleq0 a {- 0 a} a}}})
              (list (FundefC 'main '() (BinopC '+
                                               (AppC 'multByTwo (list (NumC 3)))
                                               (AppC 'makePos (list (NumC -1)))))
                    (FundefC 'multByTwo '(a) (BinopC '* (IdC 'a) (NumC 2)))
                    (FundefC 'makePos '(a) (IfC (IdC 'a) (BinopC '- (NumC 0) (IdC 'a)) (IdC 'a)))))

;; parse-fundef
(check-equal? (parse-fundef '{fn {hello} 1}) (FundefC 'hello '() (NumC 1)))
(check-equal? (parse-fundef '{fn {sum a b} {+ a b}})
              (FundefC 'sum '(a b) (BinopC '+ (IdC'a) (IdC 'b))))

;; parse
(check-equal? (parse '{+ 2 2}) (BinopC '+ (NumC 2) (NumC 2)))
(check-equal? (parse '{* 2 {+ -1 2}}) (BinopC '* (NumC 2) (BinopC '+ (NumC -1) (NumC 2))))
(check-equal? (parse '2) (NumC 2))
(check-equal? (parse '{ifleq0 0 0 {+ 2 2}}) (IfC (NumC 0) (NumC 0) (BinopC '+ (NumC 2) (NumC 2))))
(check-equal? (parse 'abc) (IdC 'abc))


;; Error checking
; funcdef have name
; is a main
; no two func with same name
; no func with builtin name
; airity of func calls, number of args match expected args

