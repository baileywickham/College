.ORIG x3300
ST R0, SAVE ; Save R0
STI R7, LOC ; Store R7 in the backup register 
LD R0, BIT ; Load the overwrite into r0
STI R0, KB ; store the overwrite inter the keyboard status register
LD R0, SAVE
LD R7, NEXT 
JMP R7

SAVE .FILL x0000
LOC .FILL x32FF
BIT .FILL x4000
KB 	.FILL xFE00
NEXT .FILL x3400
.END
