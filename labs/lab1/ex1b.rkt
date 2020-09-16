#lang typed/racket
(require typed/rackunit)

; => implies, evaluates a => b as in set theory
(define (==> [sunny : Boolean] [friday : Boolean]) : Boolean
  (if (or friday (not sunny) ) #t #f))
(check-equal? (==> #t #f) #f)
(check-equal? (==> #t #t) #t)


; string-insert inserts _ at pos i in str
; TODO ask about this format
(: string-insert (-> String Integer String))
(define (string-insert [str : String] [ i : Integer]) : String
  (string-append
    (substring str 0 i)
    "_"
    (substring str i (string-length str))))
(check-equal? (string-insert "hello" 2) "he_llo")

; profit calculates the profit of selling tickets
; with variable attendence and price, we have redefined
; to use vars instead of magic numbers.
(define avgAttend : Real 120)
(define startingPrice : Real 5.0)
(define peopleInc : Real 15)
(define priceDec : Real .01)
(define (attendees [ticket-price : Real]) : Real
  (- avgAttend (* (- ticket-price startingPrice) (/ peopleInc priceDec))))

(: revenue (-> Real Real))
(define (revenue [ticket-price : Real]) : Real
  (* ticket-price (attendees ticket-price)))

(define fixedPrice 180)
(define pricePerAttendee .04)
(: cost (-> Real Real))
(define (cost ticket-price)
  (+ fixedPrice (* pricePerAttendee (attendees ticket-price))))

(: profit (-> Real Real))
(define (profit [ticket-price : Real]) : Real
  (- (revenue ticket-price)
     (cost ticket-price)))

; returns the income in interest based on amount deposited
(define (interest [amount : Real]) : Real
  (cond
    [(<= amount 1000) (* amount .04)]
    [(<= amount 5000) (* amount .045)]
    [(> amount 5000) (* amount .05)]
    [else 5]))

(check-equal? (interest 1000) 40.0)
(check-equal? (interest 10000) 500.0)


(define-type Furnature (U Desk Bookshelf))
(struct Desk ([length : Real]
              [height : Real]
              [width : Real])
  #:transparent)

(struct Bookshelf ([depth : Real]
                   [numshelf : Natural]
                   [shelf-width : Real])
  #:transparent)

(define (furnature-footprint [f : Furnature]) : Real
  (match f
    [(Desk l h w) (* l w)]
    [(Bookshelf d n s) (* d s)]))

(check-equal? (furnature-footprint (Desk 10 10 10)) 100)
(check-equal? (furnature-footprint (Desk 0 10 10)) 0)
(check-equal? (furnature-footprint (Bookshelf 10 10 10)) 100)
(check-equal? (furnature-footprint (Bookshelf 1 3 2.5 )) 2.5)


