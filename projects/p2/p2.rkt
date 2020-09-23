#lang typed/racket
(require typed/rackunit)

(define (_map [f : (All (a) (-> a Any))] [l : (Listof Any)]) : (Listof Any)
  (match l
    ['() '()]
    [(cons l r) (cons (f l) (_map f r))]))
(check-equal? (_map (lambda (x) (+ x 2)) (cons 2 (cons 4 '()))) (cons 4 (cons 6 '())))
