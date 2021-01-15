#!/usr/bin/spim -f
# Demo Program
#
#   CPE 315
#
# java code:
# public static int rev(int a) {
#	for (int i = 0; i < 32; i++) {
#		sum += a & 1
#		sum << 1
#		a >> 1
#	}
#}
#



# declare global so programmer can see actual addresses.
.globl welcome
.globl prompt
.globl sumText

#  Data Area (this area contains strings to be displayed during the program)
.data

welcome:
	.asciiz " This program reverses a number \n\n"

prompt:
	.asciiz " Enter an integer: "

sumText:
	.asciiz " \n reversed = "

#Text Area (i.e. instructions)
.text

main:

	# Display the welcome message (load 4 into $v0 to display)
	ori     $v0, $0, 4

	# This generates the starting address for the welcome message.
	# (assumes the register first contains 0).
	lui     $a0, 0x1001
	syscall

	# Display prompt
	ori     $v0, $0, 4

	# This is the starting address of the prompt (notice the
	# different address from the welcome message)
	lui     $a0, 0x1001
	ori     $a0, $a0,0x23
	syscall

	# Read 1st integer from the user (5 is loaded into $v0, then a syscall)
	ori     $v0, $0, 5
	syscall

	andi	$s1, $s1, 0
	add		$s1, $v0, 0
	# Clear $s0 for the sum
	ori     $s0, $0, 0

	# Here v0 contains our number, s0 is empty
	# beg while loops
	andi	$s0, $0, 0
	and		$t2, $t0, $0
	ori 	$t2, $0, 31

while:
	andi 	$t0, $s1, 1
	add		$s0, $t0, $s0
	sll 	$s0, $s0, 1
	srl 	$s1, $s1, 1
	add 	$t1, $t1, 1
	bne		$t1, $t2, while
	j exit

	# Display prompt (4 is loaded into $v0 to display)
	# 0x22 is hexidecimal for 34 decimal (the length of the previous welcome message)
exit:
	ori     $v0, $0, 4
	lui     $a0, 0x1001
	ori     $a0, $a0,0x22
	syscall

	# Display the sum text
	ori     $v0, $0, 4
	lui     $a0, 0x1001
	ori     $a0, $a0,0x37
	syscall

	# Display the sum
	# load 1 into $v0 to display an integer
	ori     $v0, $0, 1
	add 	$a0, $s0, $0
	syscall

	# Exit (load 10 into $v0)
	ori     $v0, $0, 10
	syscall

