#lang typed/racket
(require typed/rackunit)

; Matches (list number chris symbol)
(define (parse000 [s : Sexp]) : Boolean
  (match s
    [(list (? number?) 'chris (? symbol?)) #t]
    [other #f]))

; matches (list number chris sym and returns the sym
(define (parse001 [s : Sexp]) : (U Boolean Symbol)
  (match s
    [(list (? number?) 'chris (? symbol? sym)) sym]
    [other #f]))

; matches a list whose second element is a list of real numbers,
; returns the list of real numbers
(define (parse002 [s : Sexp]) : (U Boolean (Listof Real))
  (match s
    [(list _ (list (? real? items) ...) _) (cast items (Listof Real))]
    [other #f]))

; returns okay if v is type real, rasies error otherwise
(define (ohno [v : Any]) : Symbol
  (match v
    [(? real?) 'okay]
    [other (error 'ohno "Not a number: ~e" other)]))


; Core language structs
(struct numC ([n : Real])#:transparent)
(struct plusC ([l : ArithC] [r : ArithC])#:transparent)
(struct multC ([l : ArithC] [r : ArithC])#:transparent)
; Define core language
(define-type ArithC (U numC plusC multC))

; Define syntax to be read by interp, including sytatic sugar
(struct numS ([n : Real])#:transparent)
(struct plusS ([l : ArithS] [r : ArithS])#:transparent)
(struct multS ([l : ArithS] [r : ArithS])#:transparent)
(struct bminusS ([l : ArithS] [r : ArithS])#:transparent)
(struct uminusS ([l : ArithS])#:transparent)
(define-type ArithS (U numS plusS multS bminusS uminusS))

; takes a core language struct and evaluates it
(define (interp [a : ArithC]) : Real
  (match a
    [(numC n) n]
    [(plusC l r) (+ (interp l) (interp r))]
    [(multC l r) (* (interp l) (interp r))]))

; counts the number of addition expressions in an ArithC
(define (num-adds [a : ArithC]) : Natural
  (match a
    [(numC a) 0]
    [(multC l r) (+ (num-adds l) (num-adds r))]
    [(plusC l r) (+ 1 (num-adds l) (num-adds r))]))

; parse takes a sexp and parses it into a ArithS
(define (parse1 [s : Sexp]) : ArithS
  (match s
    [(? real? n) (numS n)]
    [(list '+ a b) (plusS (parse1 a) (parse1 b))]
    [(list '* a b) (multS (parse1 a) (parse1 b))]
    [(list '- a b) (bminusS (parse1 a) (parse1 b))]
    [(list '- a) (uminusS (parse1 a))]
    [other (error 'parse1 "Unable to parse: ~e" other)]))

; Desugar converts an ArithS to a core language implimentation
(define (desugar [s : ArithS]) : ArithC
  (match s
    [(numS n) (numC n)]
    [(plusS l r) (plusC (desugar l) (desugar r))]
    [(multS l r) (multC (desugar l) (desugar r))]
    [(uminusS l) (multC (numC -1) (desugar l))]
    [(bminusS l r) (plusC (desugar l) (multC (numC -1) (desugar r)))]))

; parses, desugars, and interps concrete syntax
(define (top-interp [s : Sexp]): Real
  (interp (desugar (parse1 s))))

; parse2 combines desugar and parse into a single function
(define (parse2 [s : Sexp]) : ArithC
  (match s
    [(? real? n) (numC n)]
    [(list '+ a b) (plusC (parse2 a) (parse2 b))]
    [(list '* a b) (multC (parse2 a) (parse2 b))]
    [(list '- a b) (plusC (parse2 a) (multC (numC -1) (parse2 b)))]
    [(list '- a) (multC (numC -1) (parse2 a))]
    [other (error 'parse1 "Unable to parse: ~e" other)]))

; For our language it makes sense to use parse2. If our language were
; longer with more sugar, we should probably break it up into seperate steps
; but since we have so few expressions we can do it more consisely in one.

; uses parse2 intead of desugar/parse1
(define (top-interp2 [s : Sexp]): Real
  (interp (parse2 s)))
;; Tests
; top-interp
(check-equal? (top-interp '(+ 3 5)) 8)
(check-equal? (top-interp '(- (* 2 4) 5)) 3)
(check-equal? (top-interp '(- (* 2 4) (- 5))) 13)
; top-interp2 checks parse2
(check-equal? (top-interp2 '(- (* 2 4) (- 5))) 13)
(check-equal? (top-interp2 '(- (* 2 4) 5)) 3)
; parse1
(check-equal? (parse1 '1) (numS 1))
(check-equal? (parse1 '(+ 1 2)) (plusS (numS 1) (numS 2)))
(check-equal? (parse1 '(- 1 (* 3 4))) (bminusS (numS 1) (multS (numS 3) (numS 4))))

; desugar
(check-equal? (desugar (plusS (numS 1) (numS 2))) (plusC (numC 1)(numC 2)))
(check-equal? (desugar (parse1 '(- 1 2))) (plusC (numC 1) (multC (numC -1) (numC 2))))
(check-equal? (desugar (parse1 '(- 1))) (multC (numC -1) (numC 1)))

; parse000
(check-equal? (parse000 '(1 chris hi)) #t)
(check-equal? (parse000 '(x chris hi)) #f)

; parse001
(check-equal? (parse001 '(1 chris hi)) 'hi)
(check-equal? (parse001 '(x chris hi)) #f)

; parse002
(check-equal? (parse002 '(1 (1 2 3) hi)) '(1 2 3))
(check-equal? (parse002 '(x chris hi)) #f)

; ohno
(check-equal? (ohno 13) 'okay)
(check-exn (regexp (regexp-quote "Not a number"))
           (lambda () (ohno 'a)))

; interp
(check-equal? (interp (plusC (numC 2) (numC 4))) 6)
(check-equal? (interp (multC (numC 2) (numC 4))) 8)

; num-adds
(check-equal? (num-adds (plusC (numC 2) (numC 2))) 1)
(check-equal? (num-adds (plusC (plusC (numC 2) (numC 2)) (numC 2))) 2)
