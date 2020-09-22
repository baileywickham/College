#lang typed/racket
(require typed/rackunit)

; Takes a list of strings, appends it reverse
(define (rev-str-app [l : (Listof String)]) : String
   (match l
     ['() ""]
     [(cons f r) (string-append (rev-str-app r) f )]))
(check-equal? (rev-str-app (cons "hello" (cons "hi" '()))) "hihello")

;#<procedure:+>, it's long because it's defined for every type it consumes
;(-> (Listof String) String), -> is function notation
;print-type 'hi is of type 'hi, which is interesting.

(struct Trek() #:transparent)
(struct Bianchi() #:transparent)
(struct Gunnar() #:transparent)
(define-type Bicycles (U Trek Bianchi Gunnar))

; takes a listof bikes and returns only the treks
(define (onlyTreks [l : (Listof Bicycles)]) : (Listof Bicycles)
  (match l
    ['() '()]
    [(cons f r) (if (Trek? f) (cons  f (onlyTreks r)) (onlyTreks r))]))
(check-equal? (onlyTreks (cons (Trek) (cons (Gunnar) '()))) (cons (Trek) '()))
(check-equal? (onlyTreks (cons (Gunnar) (cons (Trek) (cons (Bianchi) '())))) (cons (Trek) '()))
(check-equal? (onlyTreks (cons (Trek) (cons (Trek) (cons (Bianchi) '())))) (cons (Trek) (cons (Trek) '())))

(define (onlyBianchi [l : (Listof Bicycles)]) : (Listof Bicycles)
  (match l
    ['() '()]
    [(cons f r) (if (Bianchi? f) (cons  f (onlyBianchi r)) (onlyBianchi r))]))
; a dumbed down filter, takes a list returns a predicate applied to the list
(define (onlyThese [l : (Listof Bicycles)] [g : (-> Bicycles Boolean)]) : (Listof Bicycles)
  (match l
    ['() '()]
    [(cons f r) (if (g f) (cons  f (onlyThese r g)) (onlyThese r g))]))
(define bikes (cons (Trek) (cons (Trek) (cons (Bianchi) '()))))
(check-equal? (onlyThese bikes Trek?) (onlyTreks bikes))
(check-equal? (onlyThese bikes (lambda (_) #f)) '())

; takes l0 and appends elts of l1
(define (my-append [l0 : (Listof Any)] [l1 : (Listof Any)]) : (Listof Any)
  (match l0
    ['() l1]
    [(cons l r) (cons l (my-append r l1))]))
(check-equal? (my-append '(a b) '(c d)) '(a b c d))

; my-take takes first n elts of list
(define (my-take [l : (Listof Any)] [n : Natural]) : (Listof Any)
  (if (<= n 0) '() (match l
    ['() '()]
    [(cons l r) (cons l (my-take r (- n 1)))])))
(check-equal? (my-take '(a b c d) 3) '(a b c))
(check-equal? (my-take '(a b c d) 6) '(a b c d))
