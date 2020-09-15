#lang typed/racket
(require typed/rackunit)

; => implies, evaluates a => b as in set theory
(: ==> (-> Boolean Boolean Boolean))
(define (==> sunny friday)
  (if (or friday (not sunny) ) #t #f))
(check-equal? (==> #t #f) #f)
(check-equal? (==> #t #t) #t)


; string-insert inserts _ at pos i in str
(: string-insert (-> String Integer String))
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
(: attendees (-> Real Real))
(define (attendees ticket-price)
  (- avgAttend (* (- ticket-price startingPrice) (/ peopleInc priceDec))))

(: revenue (-> Real Real))
(define (revenue ticket-price)
  (* ticket-price (attendees ticket-price)))

(define fixedPrice 180)
(define pricePerAttendee .04)
(: cost (-> Real Real))
(define (cost ticket-price)
  (+ fixedPrice (* pricePerAttendee (attendees ticket-price))))

(: profit (-> Real Real))
(define (profit ticket-price)
  (- (revenue ticket-price)
     (cost ticket-price)))

; returns the income in interest based on amount deposited
(: interest (-> Real Real))
(define (interest amount)
  (cond
    [(<= amount 1000) (* amount .04)]
    [(<= amount 5000) (* amount .045)]
    [(> amount 5000) (* amount .05)]
    [else 5]))

(check-equal? (interest 1000) 40.0)
(check-equal? (interest 10000) 500.0)
