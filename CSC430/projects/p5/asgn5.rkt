#lang typed/racket
(require typed/rackunit)

;; Full project implemented

;; Data Definitions ==================================================================================

(define-type ExprC (U Real String Symbol IfC AppC FnC SetC))
(struct IfC ([f : ExprC] [t : ExprC] [e : ExprC]) #:transparent)
(struct AppC ([f : ExprC] [args : (Listof ExprC)]) #:transparent)
(struct FnC ([args : (Listof Symbol)] [body : ExprC]) #:transparent)
(struct SetC ([var : Symbol] [val : ExprC]) #:transparent)

(define-type Store (Boxof (Listof Value)))
(define-type Environment (Listof Binding))
(struct Binding ([name : Symbol] [loc : Natural]) #:transparent)

;; We store the intial store/environment values in this form to keep things clean
(struct Initial ([name : Symbol] [value : Value]) #:transparent)

(define-type Value (U Real String Boolean Void ArrayV CloV PrimV))
(struct ArrayV ([loc : Natural] [len : Natural]) #:transparent)
(struct CloV ([args : (Listof Symbol)] [body : ExprC] [env : Environment]) #:transparent)
(struct PrimV ([f : ((Listof Value) Store → (U Value Nothing))] [arity : Arity]) #:transparent)
(define-type Arity (U Exact-Nonnegative-Integer arity-at-least))

;; Functions =========================================================================================

;; Given a program in the surface language expressed as an s-expression, evaluates it and returns the
;; result, or raises an error if the program is malformatted
(define (top-interp [s : Sexp]) : String
  (let-values ([(top-env top-sto) (init-globals)])
    (serialize (interp (parse s) top-env top-sto))))

;; Given a value, returns a string representation
(define (serialize [v : Value]) : String
  (match v
    [(? CloV?) "#<procedure>"]
    [(? PrimV?) "#<primop>"]
    [(? ArrayV?) "#<array>"]
    [(? void?) "null"]
    [#t "true"]
    [#f "false"]
    [other (~v other)]))

;; Throws an error starting with "DXUQ" so that it is clear the error is not a failure of the
;; interpreter but instead a validly rasied issue with the program being interpreted
(define (dxuq-error [message : String] . [values : Any *]) : Nothing
  (apply error 'DXUQ message values))

;; Parseing ------------------------------------------------------------------------------------------

;; Converts an s-expression representing the body of a function to an ExprC representation
;; All of the casts in this function should be ensured to succeed by the match patterns
(define (parse [s : Sexp]) : ExprC
  (match s
    [(or (? real? v) (? string? v) (? id? v)) (cast v ExprC)]
    [`{let {,(? id? s) = ,v } ... in ,e }
     (AppC (FnC+ (cast s (Listof Symbol)) (parse e)) (map parse (cast v (Listof Sexp))))]
    [`{if ,f ,t ,e } (IfC (parse f) (parse t) (parse e))]
    [`{fn {,(? id? args) ...} ,body } (FnC+ (cast args (Listof Symbol)) (parse body))]
    [`{,(? id? var) := ,val } (SetC var (parse val))]
    [`{,f ,args ...} (AppC (parse f) (map parse (cast args (Listof Sexp))))]
    [other (dxuq-error "bad syntax in ~e" other)]))

;; Checks if the argument is a valid id (symbol and not builtin name)
(: id? (Any → Boolean : #:+ Symbol))
(define (id? s)
  (and (symbol? s) (not (member s '(:= if let = in fn)))))

;; Constructs a new FnC, ensuring that the args are unique
(define (FnC+ [args : (Listof Symbol)] [body : ExprC]) : FnC
  (if (check-duplicates args) (dxuq-error "Duplicate argument identifier") (FnC args body)))

;; Interpreting --------------------------------------------------------------------------------------

;; Evaluates an expression represented as a ExprC and returns the value that results
(define (interp [e : ExprC] [env : Environment] [sto : Store]) : Value
  (define interp* (λ ([e : ExprC]) (interp e env sto)))
  (match e
    [(or (? real? v) (? string? v)) v]
    [(? symbol? id) (fetch (lookup id env) sto)]
    [(SetC id val) (begin (set-store! (lookup id env) (interp* val) sto) (void))]
    [(IfC f t e) (if (boolean‽ (interp* f)) (interp* t) (interp* e))]
    [(FnC args body) (CloV args body env)]
    [(AppC f args) (match (interp* f)
                     [(CloV id bd e) (interp bd (append (make-env id (map interp* args) sto) e) sto)]
                     [(PrimV op a) (begin (check-arity a (length args)) (op (map interp* args) sto))]
                     [other (dxuq-error "Could not apply function ~a" (serialize other))])]))

;; Given an arity and a natural raises an error if the natural is not in the arity
(define (check-arity [a : Arity] [l : Natural]) : Void
  (unless (match a
            [(arity-at-least min) (<= min l)]
            [(? exact-integer? v) (= v l)])
    (dxuq-error "Primative has wrong arity, expected ~e arguments but got ~e" a l)))

;; Given a list of argument names and values, matches them into a list of bindings or raises an error
;; if the arity does not match. Preprends this to an existing environment
(define (make-env [ids : (Listof Symbol)] [vals : (Listof Value)] [sto : Store]) : Environment
  (if (= (length ids) (length vals))
      (let ([loc (store-these! vals sto)]) (map Binding ids (range loc (+ loc (length ids)))))
      (dxuq-error "Function has wrong arity")))

;; Searches through a list of bindings for a given id, if the id is found the location in the binging
;; is returned, otherwise an unbound identifier error is raised
(define (lookup [id : Symbol] [env : Environment]): Natural
  (define binding (findf (λ ([b : Binding]) (equal? (Binding-name b) id)) env))
  (if binding (Binding-loc binding) (dxuq-error "Unbound identifier ~e" id)))

;; Grabs a value from the store at a given location and returns it
(define (fetch [loc : Natural] [sto : Store]) : Value
  (list-ref (unbox sto) loc))

;; Store a sequence if new elements in the store by appending them, returns the location of the first
(define (store-these! [v : (Listof Value)] [sto : Store]) : Natural
  (define stovals (unbox sto))
  (set-box! sto (append stovals v))
  (length stovals))

;; Set the value of the store at a given location
(define (set-store! [loc : Natural] [v : Value] [sto : Store]) : Void
  (set-box! sto (list-set (unbox sto) loc v)))

;; Create a new empty store
(define (store+) : Store (box '()))

;; Globals -------------------------------------------------------------------------------------------

;; Const Representation of the intial global enviroment/store
(define (globals) : (Listof Initial)
  (list
   (Initial 'true #t)
   (Initial 'false #f)
   (Initial 'null (void))
   (Initial '+ (binop-prim +))
   (Initial '* (binop-prim *))
   (Initial '- (binop-prim -))
   (Initial '/ (binop-prim /-safe))
   (Initial '<= (binop-prim <=))
   (Initial 'equal? (PrimV-pure equal-prim 2))
   (Initial 'error (PrimV-pure error-prim 1))
   (Initial 'new-array (PrimV new-array 2))
   (Initial 'array (PrimV array (arity-at-least 1)))
   (Initial 'aref (PrimV aref 2))
   (Initial 'aset! (PrimV aset! 3))
   (Initial 'begin (PrimV-pure last (arity-at-least 1)))
   (Initial 'substring (PrimV-pure substring-op 3))))

;; Creates an intial enviroment and store from the global intial list
(define (init-globals) : (Values Environment Store)
  (let ([sto (store+)] [globals (globals)])
    (values (make-env (map Initial-name globals) (map Initial-value globals) sto) sto)))

;; Given a function that expects 2 reals, creates a PrimV representation
(define (binop-prim [f : (Real Real → Value)]) : PrimV
  (PrimV-pure (λ ([v : (Listof Value)]) (f (real‽ (first v)) (real‽ (second v)))) 2))

;; Consturctor for a pure-ish PrimV (could throw error, just does not touch store)
(define (PrimV-pure [f : ((Listof Value) → (U Value Nothing))] [arity : Arity]) : PrimV
  (PrimV (λ ([v : (Listof Value)] [_ : Store]) (f v)) arity))

;; Given a list containing 2 Values, returns whether they are both comparable and equal
(define (equal-prim [vals : (Listof Value)]) : Boolean
  (and (andmap comparable? vals) (equal? (first vals) (second vals))))

;; Given a value, determines whether it is comaprable, not a procedure
(define (comparable? [v : Value]) : Boolean
  (nor (PrimV? v) (CloV? v)))

;; A version of division that thows our error (instead of the racket error) when dividing by 0
(define (/-safe [l : Real] [r : Real]) : Real
  (if (zero? r) (dxuq-error "Cannot divide ~e by 0" l) (/ l r)))

;; Given a list containing 1 Value, raises an error containing DXUQ, user error, and the
;; serialization of the value
(define (error-prim [v : (Listof Value)]) : Nothing
  (dxuq-error "user error: ~a" (serialize (first v))))

;; Given a list of values containing Length (0) and Value (1), creates a new array of the given length
;; with the value at every Index
(define (new-array [l : (Listof Value)] [sto : Store]) : ArrayV
  (array (make-list (natural‽ (first l)) (second l)) sto))

;; Given a list of values representing an array, creates a new array and retruns it
(define (array [l : (Listof Value)] [sto : Store]) : ArrayV
  (if (empty? l) (dxuq-error "Empty array not allowed") (ArrayV (store-these! l sto) (length l))))

;; Given a list of values containing Array (0) and Index (1), returns the value at the given index
(define (aref [l : (Listof Value)] [sto : Store]) : Value
  (fetch (array-index (array‽ (first l)) (natural‽ (second l))) sto))

;; Given a list of values containing Array (0) Index (1) and Value (3), set the index in the array to
(define (aset! [l : (Listof Value)] [sto : Store]) : Void
  (set-store! (array-index (array‽ (first l)) (natural‽ (second l))) (third l) sto))

;; Given an Array and an index into it returns the location in the store to access, or throws an out
;; of bounds error 
(define (array-index [a : ArrayV] [i : Natural]) : Natural
  (if (< i (ArrayV-len a)) (+ i (ArrayV-loc a)) (dxuq-error "Index out of bounds")))

;; Given a list of values cointaining a String (0) start index (1) and end index (2) returns the
;; substring from start to end if both are in the string and start <= end
(define (substring-op [l : (Listof Value)]) : String
  (let ([str (string‽ (first l))] [start (natural‽ (second l))] [end (natural‽ (third l))])
    (if (and (<= start end) (<= end (string-length str))) (substring str start end)
      (dxuq-error "Unable to take substring from ~e to ~e of ~e" start end str))))

;; Type Checking -------------------------------------------------------------------------------------

;; Given a typechecking predicate and a typename makes a wrapper function that ensures a value is of
;; that type and throws a type error otherwise
(define #:∀ (t) (type-check [f : (Value → Boolean : t)] [name : String]) : (Value → t)
  (λ ([v : Value]) (if (f v) v (dxuq-error "Type mismatch: ~a is not a ~a" (serialize v) name))))

;; Wraps a value ensuring that is a Real
(define real‽ (type-check real? "Real"))
;; Wraps a value ensuring that is a Boolean
(define boolean‽ (type-check boolean? "Boolean"))
;; Wraps a value ensuring that is a Natural
(define natural‽ (type-check natural? "Natural"))
;; Wraps a value ensuring that is an Array
(define array‽ (type-check ArrayV? "Array"))
;; Wraps a value ensuring that is a String
(define string‽ (type-check string? "String"))

;; TESTS =============================================================================================

;; Nice Big Test Cases -------------------------------------------------------------------------------

;; While loop
(define while : Sexp
  '{let {while = null} in
     {begin {while := {fn {guard body}
                          {if {guard} {begin {body} {while guard body}} null}}} while}})

;; In Order, checks if an array is in order
(define in-order : Sexp
  `{fn {a l}
       {let {i = 1} {r = true} in
         {begin {,while {fn {} {<= i {- l 1}}}
                        {fn {} {begin {if {<= {aref a {- i 1}} {aref a i}} null {r := false}}
                                      {i := {+ i 1}}}}} r}}})

;; Quick Sort
(define quick-sort : Sexp
  `{let {aswap! = {fn {a x y}
                      {let {temp = {aref a x}} in
                        {begin {aset! a x {aref a y}}
                               {aset! a y temp}}}}}
     {< = {fn {x y} {if {<= y x} false true}}}
     in
     {let {quick-sort = null}
       {partition = {fn {a l h}
                        {let {pivot = {aref a h}}
                          {i = {- l 1}}
                          {j = l}
                          in
                          {begin {,while {fn {} {<= j h}}
                                         {fn {}
                                             {if {< {aref a j} pivot}
                                                 {begin
                                                   {i := {+ i 1}}
                                                   {aswap! a i j}
                                                   {j := {+ j 1}}}
                                                 {j := {+ j 1}}}}}
                                 {aswap! a {+ i 1} h}
                                 {+ i 1}}}}}
       in
       {begin {quick-sort := {fn {a l h}
                                 {if {< l h}
                                     {let {pi = {partition a l h}} in
                                       {begin
                                         {quick-sort a l {- pi 1}}
                                         {quick-sort a {+ pi 1} h}}}
                                     null}}}
              {fn {a l} {quick-sort a 0 {- l 1}}}}}})

;; Lab 5 lambda fun
(define lab-5 : Sexp
  '{let {add = {fn {nlf1} {fn {nlf2} {fn {f} {fn {a} {{nlf1 f} {{nlf2 f} a}}}}}}}
     {one = {fn {f} {fn {a} {f a}}}}
     {two = {fn {f} {fn {a} {f {f a}}}}}
     {double = {fn {x} {* 2 x}}}
     in {if {equal? {{{{add one} two} double} 1} 8}
            "Result Correct" "Result Incorrect"}})

;; Test Cases
(check-equal? (top-interp `{,in-order {array 1} 1}) "true")
(check-equal? (top-interp `{,in-order {array 1 2 3} 3}) "true")
(check-equal? (top-interp `{,in-order {array 1 2 3 1 4} 5}) "false")

(check-equal? (top-interp `{let {a = {array 1 -4 5 7 0}} in
                                   {begin {,quick-sort a 5} {,in-order a 5}}}) "true")
(check-equal? (top-interp `{let {a = {array 1}} in
                                   {begin {,quick-sort a 1} {,in-order a 1}}}) "true")

(check-equal? (top-interp lab-5) "\"Result Correct\"")

;; ---------------------------------------------------------------------------------------------------

;; top-interp
(check-equal? (top-interp 'true) "true")
(check-equal? (top-interp '{+ 2 3}) "5")
(check-equal? (top-interp '{{fn {a b} {+ a b}} 2 3}) "5")
(check-equal? (top-interp '{let {a = 2} {f = {fn {x y} {* x y}}} in {f a 3}}) "6")
(check-equal? (top-interp '{if true "hello" "hi"}) "\"hello\"")
(check-equal? (top-interp '{<= 2 2}) "true")
(check-equal? (top-interp '{substring "hello world" 0 5}) "\"hello\"")
(check-equal? (top-interp '{let {a = {array 1 2 3}} in
                             {begin {aset! a 1 5} {+ {aref a 0} {aref a 1}}}}) "6")
(check-equal? (top-interp '{let {a = {new-array 3 "b"}} in {equal? a a}}) "true")
(check-equal? (top-interp '{let {a = {new-array 3 "b"}} {b = {new-array 3 "b"}} in
                             {equal? a b}}) "false")
(check-exn #px"DXUQ: Unable to take substring" (λ () (top-interp '{substring "hi" 0 5})))


;; serialize
(check-equal? (serialize 5) "5")
(check-equal? (serialize "hello") "\"hello\"")
(check-equal? (serialize #t) "true")
(check-equal? (serialize #f) "false")
(check-equal? (serialize (binop-prim +)) "#<primop>")
(check-equal? (serialize (CloV '(a b) 55 '())) "#<procedure>")
(check-equal? (serialize (ArrayV 0 0)) "#<array>")
(check-equal? (serialize (void)) "null")

;; dxuq-error
(check-exn #px"DXUQ: test no args" (λ () (dxuq-error "test no args")))
(check-exn #px"DXUQ: test error: 3" (λ () (dxuq-error "test error: ~e" 3)))
(check-exn #px"DXUQ: test args: 3-'d" (λ () (dxuq-error "test args: ~e-~e" 3 'd)))

;; Parsing Tests -------------------------------------------------------------------------------------

;; parse
(check-equal? (parse '2) 2)
(check-equal? (parse 'abc) 'abc)
(check-equal? (parse "abc") "abc")
(check-equal? (parse '{+ 2 2}) (AppC '+ '(2 2)))
(check-equal? (parse '{* 2 {+ -1 2}}) (AppC '* (list 2 (AppC '+ '(-1 2)))))
(check-equal? (parse '{if 0 0 {+ 2 2}}) (IfC 0 0 (AppC '+ '(2 2))))
(check-equal? (parse '{fn {x y} {+ x y}}) (FnC '(x y) (AppC '+ '(x y))))
(check-equal? (parse '{{fn {x y} {+ x y}} 2 {+ 2 4}})
              (AppC (FnC '(x y) (AppC '+ '(x y))) (list 2 (AppC '+ '(2 4)))))
(check-equal? (parse '{let {a = 2} in {+ a 3}}) (AppC (FnC '(a) (AppC '+ '(a 3))) '(2)))
(check-exn #px"bad syntax" (λ () (parse '{})))
(check-exn #px"bad syntax" (λ () (parse '{let {{a 10} {b 3} {too many vals}} true})))
(check-equal? (parse '{a := (+ 2 3)}) (SetC 'a (AppC '+ '(2 3))))

;; id?
(check-equal? (id? 'c) #t)
(check-equal? (id? 12) #f)
(check-equal? (id? 'fn) #f)

;; FnC+
(check-equal? (FnC+ '(a b c) 4) (FnC '(a b c) 4))
(check-exn #px"Duplicate argument identifier" (λ () (FnC+ '(a a b) 4)))

;; Interpreting Tests --------------------------------------------------------------------------------

;; interp
(check-equal? (interp 'id (list (Binding 'id 0)) (box '(33))) 33)
(check-equal? (interp (AppC (FnC '(x) 'x) '(22)) '() (store+)) 22)
(check-equal? (interp (AppC (FnC '(x) (AppC (FnC '(a b) 'b) (list (SetC 'x 4) 'x)))
                            '(10)) '() (store+)) 4)
(check-equal? (interp 4 '() (store+)) 4)
(check-equal? (interp "hello" '() (store+)) "hello")
(check-equal? (interp (IfC 't 1 2) (list (Binding 't 0)) (box '(#t))) 1)
(check-equal? (interp (IfC 't 1 2) (list (Binding 't 0)) (box '(#f))) 2)
(check-equal? (interp (FnC '(a b c) "hello") (list (Binding 'id 5)) (store+))
              (CloV '(a b c) "hello" (list (Binding 'id 5))))
(check-equal? (interp (AppC '+ '(3 4)) (list (Binding '+ 0)) (box (list (binop-prim *)))) 12)
(check-exn #px"DXUQ: Could not apply function 1" (λ () (interp (AppC 1 '(1 2)) '() (store+))))

;; check-arity
(check-equal? (check-arity 3 3) (void))
(check-equal? (check-arity (arity-at-least 3) 3) (void))
(check-equal? (check-arity (arity-at-least 3) 20) (void))
(check-exn #px"DXUQ: Primative has wrong arity, expected 4 arguments but got 5"
           (λ () (check-arity 4 5)))
(check-exn #px"DXUQ: Primative has wrong arity, expected [(]arity-at-least 3[)] arguments but got 2"
           (λ () (check-arity (arity-at-least 3) 2)))

;; make-env
(check-equal? (make-env '() '() (store+)) '())
(check-equal? (make-env '(a b c) '(4 "g" #t) (store+))
              (list (Binding 'a 0) (Binding 'b 1) (Binding 'c 2)))
(check-equal? (let ([s (store+)]) (make-env '(a b c) '(4 "g" #t) s) s) '#&(4 "g" #t))
(check-exn #px"Function has wrong arity" (λ () (make-env '(x y) '(1) (store+))))

;; lookup
(check-equal? (lookup 'x (list (Binding 'x 10) (Binding 'y 20))) 10)
(check-exn #px"Unbound identifier" (λ () (lookup 'y (list (Binding 'x 10)))))

;; fetch
(check-equal? (fetch 2 (box '(#t 4 "dos"))) "dos")

;; store-these!
(check-equal? (store-these! '(#t 3 4) (store+)) 0)
(check-equal? (let ([s (store+)]) (store-these! '(#t 3 4) s) (store-these! '("h") s) s)
              '#&(#t 3 4 "h"))

;; set-store!
(check-equal? (set-store! 0 "v" (box '(#t 4 "dos"))) (void))
(check-equal? (let ([s : Store (box '(2 #t "a"))]) (set-store! 1 "w" s) s) '#&(2 "w" "a"))

;; store+
(check-equal? (store+) '#&())

;; ---------------------------------------------------------------------------------------------------

;; init-globals
(check-equal? (let-values ([(top-env top-sto) (init-globals)])
                (= (length top-env) (length (unbox top-sto)))) #t)

;; binop-prim
(check-equal? ((PrimV-f (binop-prim +)) '(3 4) (store+)) 7)
(check-exn #px"Type mismatch: \"Q\" is not a Real"
           (λ () ((PrimV-f (binop-prim +)) '(3 "Q") (store+))))

;; PrimV-pure
(check-equal? ((PrimV-f (PrimV-pure first 2)) '("b" "a") (store+)) "b")
(check-equal? (PrimV-arity (PrimV-pure first 2)) 2)

;; equal-prim
(check-equal? (equal-prim '(2 2)) #t)
(check-equal? (equal-prim '(2 "II")) #f)
(check-equal? (equal-prim (list (binop-prim +) #t)) #f)
(check-equal? (equal-prim (list (binop-prim +) (binop-prim +))) #f)

;; error-prim
(check-exn #px"DXUQ: user error: true" (λ () (error-prim '(#t))))
(check-exn #px"DXUQ: user error: #<procedure>" (λ () (error-prim (list (CloV '() 1 '())))))

;; comparable?
(check-equal? (comparable? 1) #t)
(check-equal? (comparable? (binop-prim +)) #f)

;; /-safe
(check-equal? (/-safe 2 1) 2)
(check-exn #px"Cannot divide 3 by 0" (λ () (/-safe 3 0)))

;; new-array
(check-equal? (new-array '(3 "A") (store+)) (ArrayV 0 3))
(check-equal? (let ([s (store+)]) (new-array '(3 "A") s) s) '#&("A" "A" "A"))
(check-exn #px"DXUQ: Empty array not allowed" (λ () (new-array '(0 "A") (store+))))
(check-exn #px"DXUQ: Type mismatch: -3 is not a Natural" (λ () (new-array '(-3 "A") (store+))))

;; array
(check-equal? (array '(3 "A" #t 5) (store+)) (ArrayV 0 4))
(check-equal? (let ([s (store+)]) (array '(3 "A" #t 5) s) s) '#&(3 "A" #t 5))
(check-exn #px"DXUQ: Empty array not allowed" (λ () (array '() (store+))))

;; aref
(check-equal? (aref (list (ArrayV 0 3) 1) (box '(3 4 5))) 4)
(check-exn #px"DXUQ: Index out of bounds" (λ () (aref (list (ArrayV 0 3) 5) (box '(3 4 5)))))
(check-exn #px"DXUQ: Type mismatch: true is not a Array" (λ () (aref '(#t 5) (box '(3 4 5)))))
(check-exn #px"DXUQ: Type mismatch: 1.5 is not a Natural"
           (λ () (aref (list (ArrayV 0 3) 1.5) (box '(3 4 5)))))

;; aset!
(check-equal? (let ([s : Store (box '(1 2 3))]) (aset! (list (ArrayV 0 3) 1 "v") s) s) '#&(1 "v" 3))
(check-exn #px"DXUQ: Index out of bounds" (λ () (aset! (list (ArrayV 0 3) 5 "q") (box '(3 4 5)))))
(check-exn #px"DXUQ: Type mismatch: true is not a Array" (λ () (aset! '(#t 5 #f) (box '(3 4 5)))))
(check-exn #px"DXUQ: Type mismatch: 1.5 is not a Natural"
           (λ () (aset! (list (ArrayV 0 3) 1.5 "r") (box '(3 4 5)))))

;; array-index
(check-equal? (array-index (ArrayV 3 10) 4) 7)
(check-exn #px"DXUQ: Index out of bounds" (λ () (array-index (ArrayV 3 10) 400)))

;; substring-op
(check-equal? (substring-op '("abcdef" 1 4)) "bcd")
(check-exn #px"DXUQ: Unable to take substring from 1 to 50 of \"abcdef\""
           (λ () (substring-op '("abcdef" 1 50))))
(check-exn #px"DXUQ: Unable to take substring from 3 to 2 of \"abcdef\""
           (λ () (substring-op '("abcdef" 3 2))))
(check-exn #px"DXUQ: Type mismatch: 4.5 is not a Natural" (λ () (substring-op '("abcdef" 1 4.5))))
(check-exn #px"DXUQ: Type mismatch: -5 is not a Natural" (λ () (substring-op '("abcdef" -5 3))))
(check-exn #px"DXUQ: Type mismatch: true is not a String" (λ () (substring-op '(#t 1 4.5))))

;; ---------------------------------------------------------------------------------------------------

;; type-check
(check-equal? ((type-check exact? "X-Act") 0) 0)
(check-exn #px"DXUQ: Type mismatch: 4.5 is not a X-Act"
           (λ () ((type-check exact? "X-Act") 4.5)))

;; real‽
(check-equal? (real‽ 10) 10)
(check-exn #px"DXUQ: Type mismatch: \"nah\" is not a Real" (λ () (real‽ "nah")))

;; boolean‽
(check-equal? (boolean‽ #t) #t)
(check-exn #px"DXUQ: Type mismatch: 3 is not a Boolean" (λ () (boolean‽ 3)))

;; natural‽
(check-equal? (natural‽ 0) 0)
(check-exn #px"DXUQ: Type mismatch: true is not a Natural" (λ () (natural‽ #t)))

;; array‽
(check-equal? (array‽ (ArrayV 3 5)) (ArrayV 3 5))
(check-exn #px"DXUQ: Type mismatch: 3 is not a Array" (λ () (array‽ 3)))

;; string‽
(check-equal? (string‽ "at") "at")
(check-exn #px"DXUQ: Type mismatch: 4 is not a String" (λ () (string‽ 4)))

