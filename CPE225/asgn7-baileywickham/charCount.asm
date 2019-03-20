.ORIG x3300
	ST R0, SAVER0
	ST R1, SAVER1

	ADD R6, R6, #-1 ; return value

	ADD R6, R6, #-1
	STR R7, R6, #0  ; Store ret addr from r7 to top of stack

	ADD R6, R6, #-1
	STR R5, R6, #0  ; push dyn link

	ADD R5, R6, #-1   ; set new frame ptr (?)

	ADD R6, R6, #-1 ; push -1 for locals

; Setup complete

; str is the address of the string in the stack
; key is the character
; R5 is the start of the locals
; R6 is the top of the stack
; R5[4] is addr of string
; R5[5] is key
; int x,y R[-1] is y

	LDR R0, R5, #4 ;loads str addr?
	LDR R0, R0, #0 ;
IF BRnp ELSEIF ; if char is 0 ret
	AND R0, R0, #0 ;clear R0
	BRnzp DONE ; returns of done string

ELSEIF LDR R1, R5, #5 ; ld key I think 
	; R0 input
	; R1 key
	NOT R1, R1 ; make key negitive
	ADD R1, R1, #1
	ADD R0, R0, R1 
    ; this should subtract the char from the expected char, 0 if is correct
	BRnp ELSE	
	ADD R0, R0, #1 ; add 1 if if correct
	BRnzp REC
ELSE AND R0, R0, #0 ; different characters, r0 = 0

REC ; record stores the variable 
	STR R0, R5, #0 ;saves the char comparison
	; calling again
	LDR R0, R5, #5 ; ld key to r0
	ADD R6, R6, #-1
	STR R0, R6, #0 ; push key
	LDR R0, R5, #4 ; ld str
	ADD R0, R0, #1
	ADD R6, R6, #-1
	STR R0, R6, #0
	LD R0, CCOUNT ; Call again
	JSRR R0

	LDR R0, R6, #0; return value in r0
	;STR R0 R5 ; stores return value in first local variable
	ADD R6, R6, #1
	ADD R6, R6, #2 ;pop args

	LDR R1, R5, #0
	ADD R0, R1, R0 ; Add return and 
	STR R0, R5, #0 ; stores result in result


DONE
; Teardown
STR R0, R5, #3 ;LDR R1, R5, #0 ;copy ret

ADD R6, R5, #1 ; pop local

LDR R5, R6, #0 ;Move dyn to R5
ADD R6, R6, #1

LDR R7, R6, #0 ; return addr into r7
ADD R6, R6, #1

LD R0, SAVER0
LD R1, SAVER1
RET


SAVER0 .FILL x0000
SAVER1 .FILL x0000
STORERET .FILL x0000
CCOUNT .FILL x3300
.END

