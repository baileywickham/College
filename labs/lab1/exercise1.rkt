#lang racket
(require rackunit)

; => implies, evaluates a => b as in set theory
(define (==> sunny friday)
  (if (or friday (not sunny) ) #t #f))
(check-equal? (==> #t #f) #f)
(check-equal? (==> #t #t) #t)


; string-insert inserts _ at pos i in str
(define (string-insert str i)
  (string-append
    (substring str 0 i)
    "_"
    (substring str i (string-length str))))
(check-equal? (string-insert "hello" 2) "he_llo")

; profit calculates the profit of selling tickets
; with variable attendence and price, we have redefined
; to use vars instead of magic numbers.
(define avgAttend 120)
(define startingPrice 5.0)
(define peopleInc 15)
(define priceDec .01)
(define (attendees ticket-price)
  (- avgAttend (* (- ticket-price startingPrice) (/ peopleInc priceDec))))

(define (revenue ticket-price)
  (* ticket-price (attendees ticket-price)))

(define fixedPrice 180)
(define pricePerAttendee .04)
(define (cost ticket-price)
  (+ fixedPrice (* pricePerAttendee (attendees ticket-price))))

(define (profit ticket-price)
  (- (revenue ticket-price)
     (cost ticket-price)))

(profit 5)
