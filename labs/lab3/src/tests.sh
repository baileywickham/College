#!/bin/bash    
	javac *.java
	echo "Compiled"
    java lab2 test1_parser.asm > test1_parser.out
	java lab2 test2_parser.asm > test2_parser.out
	java lab2 test3_parser.asm > test3_parser.out
	java lab2 test4_parser.asm > test4_parser.out
	diff -w -B test1_parser.out test1_parser.expected
	diff -w -B test2_parser.out test2_parser.expected
	diff -w -B test3_parser.out test3_parser.expected
	diff -w -B test4_parser.out test4_parser.expected
    echo "Passed Parser"
	java lab3 sum_10.asm sum_10.script > sum_10.asm.out
	diff -w -B sum_10.asm.out sum_10.expected
    echo "Passed Test1"
	java lab3 lab3_fib.asm lab3_fib.script > lab3_fib.asm.out
	diff -w -B lab3_fib.asm.out lab3_fib.expected
    echo "Passed Test2"
	#java lab3 lab3_test3.asm lab3_test3.script > lab3_test3.asm.out
	#diff -w -B lab3_test3.asm.out lab3_test3.expected
    #echo "Passed Test3"