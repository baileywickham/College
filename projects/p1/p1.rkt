#lang typed/racket
(require typed/rackunit)

; I finished all of the assignment. I had one question about returning the
; derivitive of a linear polynomial as a real, but it wasn't a big concern.

; total-profit, takes num attendees, returns total profit
(define (total-profit [n : Natural]) : Real
  (- (* n 4.5) 20))
(check-equal? (total-profit 1) -15.5)

; area-cylinder takes radius, height, returns surface area
(define (area-cylinder [r : Real] [h : Real]) : Real
  (+ (* 2 pi r h) (* 2 pi r r)))
(check-= (area-cylinder 1 1) 12.57 .01)
(check-= (area-cylinder 2 3) 62.83 .01)

; a magic-trick is either
; - (Card-Trick decks volunteers),
;    where decks is a number and volunteers is an integer,
;    representing a card trick that requires the given
;    number of card decks and audience volunteers, or
; - (Guillotine realism has-tiger?),
;    where realism is a number indicating the level of
;    realism from 0 up to 10 and has-tiger? is a boolean,
;    representing a guillotine trick with the given level
;    of realism and an optional tiger.
(struct Card-Trick ([decks : Natural] [volunteers : Natural]))
(struct Guillotine ([realism : Real] [has-tiger? : Boolean]))
(define (trick-minutes [t : (U Card-Trick Guillotine)]) : Real
  (match t
    [(Card-Trick d v) (* 1 d (expt 2 v))]
    [(Guillotine r g) (if g 20 10)]))
(check-equal? (trick-minutes (Card-Trick 2 2)) 8)
(check-equal? (trick-minutes (Guillotine 2 #t)) 20)
(check-equal? (trick-minutes (Guillotine 10 #f)) 10)

; This does bring up interesting questions about polynomials with coeffiecents in C
(struct Quadratic ([a : Real] [b : Real] [c : Real]) #:transparent)
(struct Linear ([a : Real] [b : Real]) #:transparent)
(define-type Polynomial (U Linear Quadratic))
; interp takes a polynomial and evaluates it. evaluate function.
(define (interp [p : Polynomial] [x : Real]) : Real
  (match p
  [(Quadratic a b c) (+ (* a (* x x)) (* b x) c)]
  [(Linear a b) (+ (* a x) b)]))
(check-equal? (interp (Linear 2 2) 3) 8)
(check-equal? (interp (Quadratic -1 2 2) 3) -1)

;TODO ask about linear poly derivative
; Derivative takes a polynomial and returns the polynomial derivative. Rigorously defined in Math 412. 
(define (derivative [p : Polynomial]) : Polynomial
  (match p
    [(Linear a b) (Linear 0 a) ]
    [(Quadratic a b c) (Linear (* 2 a) b)]))
(check-equal? (derivative (Linear 2 2)) (Linear 0 2))
(check-equal? (derivative (Quadratic 2 2 1)) (Linear 4 2))

(struct Leaf ([data : (U Symbol '())]) #:transparent)
(struct Node ([left : (U Node Leaf)] [right : (U Leaf Node)]) #:transparent)
(define-type BTree (U Node Leaf))
(define b (Node                                   ;          x
  (Node                                           ;         / \
    (Node (Leaf 'hello) (Leaf 'hi))               ;       x    yello
    (Leaf '()))                                   ;      / \
  (Leaf 'yello)))                                 ;    x    '()
                                                  ;   / \
                                                  ;hello hi
; mirror, takes a binary tree and returns a mirrored copy
(define (mirror [t : BTree]) : BTree              ;
  (match t                                        ;       x
    [(Leaf d) (Leaf d)]                           ;      / \
    [(Node l r) (Node (mirror r) (mirror l))]))   ;    yello x
(define mirroredb (Node                           ;         / \
    (Leaf 'yello)                                 ;       '()  x
    (Node                                         ;           / \
        (Leaf '())                                  ;          hi  hello
        (Node (Leaf 'hi) (Leaf 'hello)))))
(check-equal? (mirror b) mirroredb)
(check-equal? (mirror (Leaf 'a)) (Leaf 'a))

; min-depth, takes tree and returns the minimum depth to a leaf
(define (min-depth [t : BTree]) : Natural
  (match t
    [(Leaf _) 0]
    [(Node l r) (+ 1 (min (min-depth l) (min-depth r)))]))
(check-equal? (min-depth b) 1)

; Substitutes symbol s for replacement tree rep
(define (subst [t : BTree] [s : Symbol] [rep : BTree]) : BTree
  (match t
    [(Leaf d) (if (eq? d s) rep (Leaf d))]
    [(Node l r) (Node (subst l s rep) (subst r s rep))]))

; checks agaist correct node. This is not formatted properly, but this way makes sense for me.
(check-equal? (subst b 'hi (Leaf 'bye)) (Node     ;          x
  (Node                                           ;         / \
    (Node (Leaf 'hello) (Leaf 'bye))               ;       x    yello
    (Leaf '()))                                   ;      / \
  (Leaf 'yello)))                                 ;    x    '()
                                                  ;   / \
                                                  ;hello bye
; check-equal? with more complex tree, replacing with entire tree instead of just leaf
(check-equal? (subst b 'hi (Node (Leaf 'bye) (Leaf 'forever))) (Node
  (Node
    (Node (Leaf 'hello)
          (Node (Leaf 'bye) (Leaf 'forever)))
    (Leaf '()))
  (Leaf 'yello)))


;
