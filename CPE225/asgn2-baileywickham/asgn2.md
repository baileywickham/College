# HW

## Name
BW -> 4257 -> 0100 0010 0101 0111

This is not a valid instruction. JSR with a 0 in the 11th spot requires all 0s after the 5th spot.

## PT2

Number after addNum.bin

- x9928

R2 is used as an index to iterate accross the data, in this case it is [10] long.

R2 is incrimented to iterate across this array type object. 

R4 is the counter, the number of times the loop will be ran.


## PT3A
.ORIG x3000
LD R0 #255  
AND R1 R1 #0 ; Clear R1  
AND R2 R2 #0 ; Clear R2  

ADD R1 R0 #-1  
AND R1 R0 R1  

ADD R2 R2 #1  
ADD R0 R1 #0  
BRnp #-5  
ST R2 #248  
HALT  
.END  

FEDC BA98 7654 3210
FEDC BA9 876 5 43210
## p3 bin

0011 0000 0000 0000  ; .orig 3000
0010 000 011111111   ; LD R0 #255
0101 001 001 1 00000 ; AND r1 r1 #0
0101 010 010 1 00000 ; AND r2 r2 #0

0001 001 000 1 11111 ; ADD r1 r0 #-1
0101 001 000 000 001 ; AND r1 r0 r1

0001 010 010 1 00001 ; ADD R2 R2 #1
0001 000 001 1 00000 ; ADD R0 R1 #0
0000 101 111 1 11011 ; BRnp #-5
0011 010 011111000   ; 248




## PT3B
.ORIG x3000
LD R0 #255 ; R0 original
AND R2 R2 #0 ; Clear r2, the reversed number
ADD R1 R2 #1 ; Make mask one

ADD R2 R2 R2
AND R3 R0 R1 ; if one, add to end of new number
BRz #1 ; if 0 skip to shifting
ADD R2 R2 #1
ADD R1 R1 R1 ; Bitshift both mask and return value.
BRnp #-6

ST R2 #243 ; Store
HALT
.END

