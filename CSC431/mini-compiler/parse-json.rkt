#lang racket

(provide parse)

(require "ast/mini.rkt" "util.rkt")

;; Given a JSON file generated by the ANTLR parser, recursively parses it into
;; the internal Mini AST representation. The JSON is assumed correct, and any
;; error in it will result in a racket match error

(define+ (parse (json types declarations functions))
  (Mini (map parse-type types)
        (map parse-dec declarations)
        (map parse-fun functions)))

(define+ (parse-type (json id fields))
  (Struct (parse-id id) (map parse-dec fields)))

(define+ (parse-dec (json id type))
  (cons (parse-id id) (parse-id type)))

(define+ (parse-fun (json id parameters return_type declarations body))
  (Fun (parse-id id)
       (map parse-dec parameters)
       (parse-id return_type)
       (map parse-dec declarations)
       (map parse-stmt body)))

(define (parse-stmt stmt)
  (match* ((hash-ref stmt 'stmt) stmt)
    [("block" (json list)) (map parse-stmt list)]
    [("assign" (json target source)) (Assign (parse-target target) (parse-exp source))]
    [("if" (json guard then else)) (If (parse-exp guard) (parse-stmt then) (parse-stmt else))]
    [("if" (json guard then)) (If (parse-exp guard) (parse-stmt then) '())]
    [("while" (json guard body)) (While (parse-exp guard) (parse-stmt body))]
    [("invocation" (json id args)) (Inv (parse-id id) (map parse-exp args))]
    [("print" (json exp endl)) (Print (parse-exp exp) endl)]
    [("delete" (json exp)) (Delete (parse-exp exp))]
    [("return" (json exp)) (Return (parse-exp exp))]
    [("return" _) (Return (void))]))

(define (parse-exp exp)
  (match* ((hash-ref exp 'exp) exp)
    [("num" (json value)) (string->number value)]
    [("true" _) #t]
    [("false" _) #f]
    [("null" _) (Null)]
    [("id" (json id)) (parse-id id)]
    [("invocation" (json id args)) (Inv (parse-id id) (map parse-exp args))]
    [("binary" (json operator lft rht)) (Prim (parse-id operator) (map parse-exp (list lft rht)))]
    [("unary" (json operator operand)) (Prim (parse-id operator) (list (parse-exp operand)))]
    [("dot" (json left id)) (Dot (parse-exp left) (parse-id id))]
    [("new" (json id)) (New (parse-id id))]
    [("read" _) (Read)]))

(define (parse-target target)
  (match target
    [(json left id) (Dot (parse-target left) (parse-id id))]
    [(json id) (parse-id id)]))

(define parse-id string->symbol)

;; This is where some of the magic happens, this macro defines a new match pattern, a
;; json pattern expands to a hash-table with keys that are symbols with the same names
;; as the id names
(define-match-expander json
  (λ (stx)
    (syntax-case stx ()
      [(_ names ...) #'(hash-table ('names names) ...)])))
