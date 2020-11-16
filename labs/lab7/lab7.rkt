#lang typed/racket
(require typed/rackunit)

(define-type ExprC (U Real Symbol String LamC AppC IfC SetC))
(struct LamC ([params : (Listof Symbol)] [body : ExprC]) #:transparent)
(struct AppC ([fun : ExprC] [args : (Listof ExprC)]) #:transparent)
(struct IfC ([test : ExprC] [thn : ExprC] [els : ExprC]) #:transparent)
(struct SetC ([var : Symbol] [newval : ExprC]) #:transparent)

(define-type Value (U Real Boolean String CloV PrimV ArrayV))
(struct CloV ([params : (Listof Symbol)] [body : ExprC] [env : Env]) #:transparent)
(struct ArrayV ([addr : Address] [length : Natural]) #:transparent)
(define-type PrimV (U '+ '- '* '/))

(define-type Env (HashTable Symbol Address))
(define-type Address Natural)
(define-type Store (Mutable-HashTable Address Value))

;; ---------------------------------------------------------------------------------------------------

;; Accepts a list of environments and a store and returns a list of the unreachable memory
;; locations in the store.
(define (collect [envs : (Listof Env)] [sto : Store]) : (Listof Address)
  (sweep (mark '() (apply append (map env-refs envs)) sto) sto))

;; Take a store and a list of still-used locations, and returns a list of the
;; no-longer-referred-to locations
(define (sweep [used : (Listof Address)] [sto : Store]) : (Listof Address)
  (filter (λ ([a : Address]) (equal? (member a used) #f)) (hash-keys sto)))

;; Accepts a list or set of seen memory locations and a list (representing a queue) of unexamined
;; memory locations and a store. Returns a list of all the memory locations that are referred to.
(define (mark [seen : (Listof Address)] [queue : (Listof Address)] [sto : Store]) : (Listof Address)
  (cond [(empty? queue) '()]
        [(member (first queue) seen) (mark seen (rest queue) sto)]
        [else (let ([a (first queue)])
                (cons a (mark (cons a seen)
                              (append (rest queue) (val-refs (hash-ref sto a))) sto)))]))

;; Given an environment, returns a list of addresses directly referenced by it.
;; We are assuming we don't have shadowed bindings
(define env-refs (ann hash-values (Env -> (Listof Address))))

;; Given a value, returns a list of addresses directly refrenced by it
(define (val-refs [v : Value]) : (Listof Address)
  (match v
    [(ArrayV addr length) (range addr (+ addr length))]
    [(CloV _ _ env) (env-refs env)]
    [other '()]))

;; ---------------------------------------------------------------------------------------------------

(check-equal? (val-refs (ArrayV 2 3)) '(2 3 4))
(check-equal? (val-refs (CloV '() 1 #hash((a . 10) (b . 15)))) '(10 15))
(check-equal? (val-refs 1) '())

(check-equal? (env-refs #hash((a . 1) (b . 2))) '(1 2))

(check-equal? (sweep '(1 3 5) (make-hash '((1 . 1) (2 . 3) (3 . 4) (5 . 5) (10 . 10)))) '(2 10))

(check-equal? (collect (list #hash((a . 1) (c . 2)) #hash((b . 10)))
                       (make-hash `((1 . ,(ArrayV 3 2))
                                    (2 . ,(CloV '() 1 #hash((x . 2) (y . 1))))
                                    (4 . "hi")
                                    (3 . 1)
                                    (5 . 11)
                                    (17 . 16)
                                    (10 . 10))))
              '(5 17))

;; Alex:   3n9ax8
;; Bailey: u372er
