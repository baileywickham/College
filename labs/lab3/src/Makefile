all: compile
lab3: compile

compile:
	javac *.java

test: compile
	java lab2 test1_parser.asm > test1_parser.out
	java lab2 test2_parser.asm > test2_parser.out
	java lab2 test3_parser.asm > test3_parser.out
	java lab2 test4_parser.asm > test4_parser.out
	diff -w -B test1_parser.out test1_parser.expected
	diff -w -B test2_parser.out test2_parser.expected
	diff -w -B test3_parser.out test3_parser.expected
	diff -w -B test4_parser.out test4_parser.expected
	java lab3 sum_10.asm > sum_10.asm.out
	java lab3 lab3_fib.asm > lab3_fib.asm.out
	java lab3 lab3_test3.asm > lab3_test3.asm.out

clean:
	rm -f *.out
	rm -f *.class

.PHONY: clean
