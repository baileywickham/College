# 2.6.1a
lw $t0, 8($s6)
# Clear s0
and $s0, $s0, $0
add $s0, $s0, $t0

# 2.6.1b
# Load A[i] -> t0
lw $t0, 0($s6)
sll $s2, $s2, 2
add $t0, $t0, $s2
lw $t0, $t0

# Load A[j] -> t1
lw $t1, 0($s6) # ld
sll $s3, $s3, 2
add $t1, $t1, $s3
lw $t1, 0{$t1)

add 32($s7), $t0, $t1


#2.16.4
a) 0010 0100 1001 0010 0100 1001 0010 0100,  613566756
b) 0101 1111 1011 1110 0100 0000 0000 0000, 1606303744

t1) 0011 1111 1111 1000 0000 0000 0000 0000, 1073217536

a)
t2: 0
b)
t2: 2

#2.18.2b
#for (i=0; i<a; i++)
#	for (j=0; j<b; j++)
#		D[4*j] = i + j;
#$s0=a, $s1=b, $t0=i, $t1=j
STARTI:
slt $t3, $t0, $s0 # 1 if i < a else 0
beq $t3, $0, ENDI

STARTJ
slt $t4, $t1, $s1 # 1 if j < b else
beq $t4, $0, ENDJ

add $t5, $t1, $t0 # i + j
sll $t6, $t1, 2 #t6=4*j
add $t6, $s2, $t6 #$s2 = D, offset of arr
sw 	0($t5), $t6

addi $t1, $t1, 1
j STARTJ
ENDJ

addi $t0, $t0, 1
j STARTI
ENDI:

#2.19.4a
f:
#a, b are already in a0, a1
addi $sp, $sp, -8
sw $s0, 0($sp)
sw $ra, 4($sp)

add $s0, $a2, $a3
jal func
add $a0, $v0, $0
add $a1, $0, $s0
jal func

lw $s0, $sp
lw $ra, 4(sp)
addi $sp, $sp, 8

jr $ra


