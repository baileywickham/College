#lang racket

(require rackunit)

; this should produce 5
((λ (x) (+ x 2)) 3)
; this should produce 9
((λ (f g) (f (g 3)))
 (λ (x) (+ x 3))
 (λ (x) (* x 2)))

; returns a function which adds a fixed amount to b
(define (curried-add a)
  (λ (b) (+ b a)))
(check-equal? ((curried-add 5) 5) 10)

; currys a function with 2 arguments
(define (curry2 f)
  (lambda (a) (lambda (b) (f a b))))

; Currys a function f with 3 arguments
(define (curry3 f)
  (lambda (a) (lambda (b) (lambda (c) (f a b c)))))

; checks if a list contains a symbol
(define (contains? l s)
  (match l
    ['() #f]
    [(cons f r)(if (equal? f s) #t (contains? r s))]))

(define (in-list-many? l s)
  (map ((curry2 contains?) l) s))

(check-equal? (((curry2 +) 2) 3) 5)

(check-equal? ((((curry3 *) 2) 3) -1) -6)

(check-equal? (contains? '(a b c) 'b) #t)
(check-equal? (contains? '(a b c) 'd) #f)

(check-equal? (in-list-many? '(a b c d e f) '(a x e)) '(#t #f #t))
