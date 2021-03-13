# Name: Marcelo Jimenez Bailey Wickham
# Section: 315-01
# Description: exponentiation: x raised to the power of y. 
#
# java code:
# int exp(int x, int y)
#   {
#    int res = 1;
#    while(y != 0)
#    {
#        int mulRes = 0;
#        for(int i = 0; i != x; i++)
#        {
#            mulRes += res;
#        }
#        res = mulRes;
#        y--;
#    }
#    return res;
#

#  Data Area (this area contains strings to be displayed during the program)
.data
#0
.asciiz " This program calculates x raised to the power of y\n\n"
#54
.asciiz " Enter x: "
#65
.asciiz " Enter y: "
#76
.asciiz " \n x ^ y = "

.text
main:

    # Display the welcome message
    ori     $v0, $0, 4
    lui     $a0, 0x1001
    syscall

    # Display prompt and read 'x' integer (stores it in s0)
    ori     $v0, $0, 4    
    lui     $a0, 0x1001
    ori     $a0, $a0, 54
    syscall
    ori     $v0, $0, 5
    syscall
    add $s0 $v0 $0

    # Display prompt and read 'y' integer (stores it in s1)
    ori     $v0, $0, 4            
    lui     $a0, 0x1001
    ori     $a0, $a0, 65
    syscall
    ori    $v0, $0, 5    
    syscall
    add $s1 $v0 $0
    
    # Display the output message
    ori     $v0, $0, 4            
    lui     $a0, 0x1001
    ori     $a0, $a0, 76
    syscall 

    #DO PROGRAM STUFF
    #s2 = res $s3 = mulRes #s4 = i $t1 = conditional
    add     $s2, $0, $0
    addi    $s2, $s2, 1
while:
    slt    $t1, $0, $s1
    beq     $t1, $0, end
    
    add     $s3, $0, $0
    add     $s4, $0, $0
for:
    beq     $s0, $s4, endloop
    add     $s3, $s3, $s2
    addi    $s4 $s4 1 
    j for
endloop:
    add     $s2, $s3, $0
    addi    $s1 $s1 -1 
    j while
    
end:
    add     $a0, $0, $s2
    
    #END DO PROGRAM STUFF
    
    #Display the value in a0
    ori     $v0, $0, 1
    syscall
    
    # Exit (load 10 into $v0)
    ori     $v0, $0, 10
    syscall