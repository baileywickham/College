#lang racket

(require rackunit)

; one applies f to a
(define one (lambda (f) (lambda (a) (f a))))
(check-equal? ((one add1) 1) 2)

; two f(f(a))
(define two (lambda (f) (lambda (a) (f (f a)))))
(check-equal? ((two add1) 1) 3)

; 0: a
(define zero (lambda (f) (lambda (a) a)))
(check-equal? ((zero add1) 1) 1)

(define addOne (lambda (f) (lambda (g) (lambda (a) (g ((f g) a))))))
(check-equal? (((addOne one) add1) 1) 3)

(define add (lambda (f1) (lambda (f2)
              (lambda (f) (lambda (a) ((f1 f) ((f2 f) a)))))))
(check-equal? ((((add two) one) add1) 1) 4)

(define tru (lambda (a) (lambda (b) a)))
(check-equal? ((tru 'true) 'false) 'true)

(define fal (lambda (a) (lambda (b) b)))
(check-equal? ((fal 'true) 'false) 'false)

(define iff (lambda (a) (lambda (b) (lambda (c) (a b) c) )))
(check-equal? (((iff tru) '1) '2) '2)

(module sim-DXUQ4 racket
    (provide
     (rename-out [lambda fn]
                 [my-let let])
     #%module-begin
     #%datum
     #%app
     + - * / = <=
     if)


  (define-syntax my-let
    (syntax-rules (in =)
      [(my-let [v = e] ... in eb)
       ((lambda (v ...) eb) e ...)])))

(require 'sim-DXUQ4)

{let {add = {fn {f1} {fn {f2} {fn {f} {fn {a} {{f1 f} {{f2 f} a}}}}}}}
    {one = {fn {f} {fn {a} {f a}}}}
    {two = {fn {f} {fn {a} {f {f a}}}}}
    {double = {fn {x} {* 2 x} }}
    in
    {if {equal? {{{{add one} two} double} 1} 8} 'true 'false }
}
