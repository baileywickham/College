; R0, ram
; R1, shift, encrypt key
; R2, ptr 
; R4, shifted char

.ORIG x3000
    LEA R2, NUM
    LEA R0, KEY ; Load address of message into r0
    PUTS ; Prints r0 

    GETC ; Gets keypress print 
    OUT  ; Prints keypress
    ADD R0, R0, #-16
    ADD R0, R0, #-16
    ADD R1, R0, #-16 ; R1 is shift
    
    ; gets message to shift
    LEA R0, MESSAGE
    PUTS

TEST GETC
	 OUT
	 ADD R0, R0, #-10
     BRz NT    
	 ADD R0, R0, #10
     STR R0, R2, #0
	 ADD R2, R2, #1
     BRnzp TEST

NT	STR R0, R2, #0
	LEA R2, NUM


SHIFT LDR R0, R2, #0 ;Get first char
	BRz PRINT ; if null print
	NOT R3, R0
	AND R3, R3, #1
	AND R0, R0, #-2
	ADD R0, R3, R0

	ADD R0, R0, R1 ; Add shift
    STR R0, R2, #0 ; put back in mem
    ADD R2, R2, #1 ; Shift ptr
    BRnzp SHIFT

PRINT LEA R0, EM ; Print ending message
    PUTS
	LEA R0, NUM
    PUTS
    HALT

NUM .BLKW #21
KEY     .STRINGZ "Encryption Key (1-9) : "
MESSAGE .STRINGZ "\nInput Message : "
EM      .STRINGZ "Encrypted Message : "
.END
