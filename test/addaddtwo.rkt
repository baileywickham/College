#lang typed/racket

(define (addaddn [n : Real]) : (-> Real Real)
  (lambda (i) (+ n i)))

((addaddn 2) 2)
