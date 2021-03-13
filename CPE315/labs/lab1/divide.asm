# Name:  Marcelo Jimenez Bailey Wickham
# Section:  315-01
# Description:  divides a 64-bit unsigned number with a 31-bit unsigned number.
#
# java code:
#    static void divide(int upper, int lower, int div)
#    {
#        int lsb = 0;
#        while (div != 1) 
#        {
#            div = div >>> 1;
#            lower = lower >>> 1;
#            lsb = upper & 1;
#            lsb = lsb << 31;
#            lower = lower | lsb;
#            upper = upper >>> 1;
#        }
#    }
#  Data Area (this area contains strings to be displayed during the program)
.data
#0
	.asciiz " This program divides a 64-bit number with a 31-bit number \n\n"
#62
	.asciiz " Enter upper: "
#77
	.asciiz " Enter lower: "
#92
	.asciiz " Enter div: "
#105
	.asciiz " \n "
	.asciiz ","
	.asciiz " / "
	.asciiz " = "
	.asciiz "," 

#Text Area (i.e. instructions)
.text
main:

	# Display the welcome message (load 4 into $v0 to display)
	ori     $v0, $0, 4
	lui     $a0, 0x1001
	syscall

	# Display prompt, read upper and store in s0
	ori     $v0, $0, 4
	lui     $a0, 0x1001
	ori     $a0, $a0, 62
	syscall

	ori     $v0, $0, 5
	syscall
	add $s0 $v0 $0

	# Display prompt, read lower and store in s1
	ori     $v0, $0, 4
	lui     $a0, 0x1001
	ori     $a0, $a0, 77
	syscall

	ori     $v0, $0, 5
	syscall
	add $s1 $v0 $0

	# Display prompt, read divisor and store in s2
	ori     $v0, $0, 4
	lui     $a0, 0x1001
	ori     $a0, $a0, 92
	syscall

	ori     $v0, $0, 5
	syscall
	add $s2 $v0 $0

	# Display the output message
	ori     $v0, $0, 4			
	lui     $a0, 0x1001
	ori     $a0, $a0, 105
	syscall 
	
	ori     $v0, $0, 1			
	addi     $a0, $s0, 0
	syscall 
	
	ori     $v0, $0, 4			
	lui     $a0, 0x1001
	ori     $a0, $a0, 119
	syscall 
	
	ori     $v0, $0, 1			
	addi     $a0, $s1, 0
	syscall 
	
	ori     $v0, $0, 4			
	lui     $a0, 0x1001
	ori     $a0, $a0, 111
	syscall 
	
	ori     $v0, $0, 1			
	addi     $a0, $s2, 0
	syscall 
	
	ori     $v0, $0, 4			
	lui     $a0, 0x1001
	ori     $a0, $a0, 115
	syscall 

	# Do the division
	# t1 = lsb t2 = conditional t3 = 1
	# s0 = upper s1 = lower s2 = div
	
	add $t1 $0 $0
	add $t3 $0 $0
	addi $t3 $t3 1

while:
	slt $t2 $t3 $s2
	beq $t2 $0 end
	
	srl $s2 $s2 1
	srl $s1 $s1 1
	and $t1 $s0 $t3
	sll $t1 $t1 31
	or $s1 $s1 $t1
	srl $s0 $s0 1
	j while

end:

	#Display answer
	add     $a0 $s0 $0
	ori     $v0, $0, 1
	syscall
	
	ori     $v0, $0, 4			
	lui     $a0, 0x1001
	ori     $a0, $a0, 119
	syscall 
	
	add     $a0 $s1 $0
	ori     $v0, $0, 1
	syscall
	
	# Exit (load 10 into $v0)
	ori     $v0, $0, 10
	syscall
