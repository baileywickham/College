#lang typed/racket
(require typed/rackunit)

; Takes a list of strings, appends it reverse
(define (rev-str-app [l : (Listof String)]) : String
  (match l
    ['() ""]
    [(cons f r) (string-append (rev-str-app r) f )]))
(check-equal? (rev-str-app (cons "hello" (cons "hi" '()))) "hihello")

;(-> (Listof String) String), -> is function notation. it takes a list of strings
; and returns an appended list of strings
;#<procedure:+>, it's long because it's defined for every type it consumes
;print-type 'hi is of type 'hi, which is interesting.

(struct Trek() #:transparent) ; why does this need to be transparent?
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

; takes a list of bicycles and returns a list of only Bicycles
(define (onlyBianchi [l : (Listof Bicycles)]) : (Listof Bicycles)
  (match l
    ['() '()]
    [(cons f r) (if (Bianchi? f) (cons  f (onlyBianchi r)) (onlyBianchi r))]))
; a dumbed down filter, takes a list returns a predicate applied to the list
; g is a pred which takes a bike and returns a bool.
(define (onlyThese [l : (Listof Bicycles)] [g : (-> Bicycles Boolean)]) : (Listof Bicycles)
  (match l
    ['() '()]
    [(cons f r) (if (g f) (cons  f (onlyThese r g)) (onlyThese r g))]))
(define bikes (cons (Trek) (cons (Trek) (cons (Bianchi) '()))))
(check-equal? (onlyThese bikes Trek?) (onlyTreks bikes))
(check-equal? (onlyThese bikes (lambda (_) #f)) '())

; takes l0 and appends elts of l1, concatonates lists
(define (my-append [l0 : (Listof Any)] [l1 : (Listof Any)]) : (Listof Any)
  (match l0
    ['() l1]
    [(cons f r) (cons f (my-append r l1))]))
(check-equal? (my-append '(a b) '(c d)) '(a b c d))
(check-equal? (my-append '(a) '(c d e)) '(a c d e))

; my-take takes first n elts of list
(define (my-take [l : (Listof Any)] [n : Natural]) : (Listof Any)
  (if (<= n 0) '() (match l
                     ['() '()]
                     [(cons l r) (cons l (my-take r (- n 1)))])))
(check-equal? (my-take '(a b c d) 3) '(a b c))
(check-equal? (my-take '(a b c d) 6) '(a b c d))


; (-> b Any) == (b -> Any)
; (b : Real) == (: b : Real)?
;(: _filter (All (a) (-> a Boolean) (Listof a) (Listof a)))
;(define (_filter  g l)
;  (match l
;    ['() '()]
;    [(cons f r) (if (g f) (cons  f (_filter g r)) (_filter g r))]))
;(check-equal? (_filter (lambda (x) (= x 2)) (list 4 2 33)) (list 2))
