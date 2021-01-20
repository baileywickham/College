# 2.6.1a
lw $t0, 8($s6)
add $s0, $s0, $t0

# 2.6.1b
# Load A[i] -> t0
lw $t0, $s6
add $t0, $t0, $s3
lw $t0, $t0

# Load A[j] -> t1
lw $t1, $s6
add $t1, $t1, $s3
lw $t1, $t1

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

add $t5, $t1, $t0
sll $t6, $t1, 2 #4*j
add $t6, $s2, $t4 #offset of arr
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
jal func
add $a0, $v0, $0
add $a1, $a2, $a3
jal func
jr $ra


