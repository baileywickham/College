all: compile

compile:
	javac *.java

test: compile
	java lab2 test1.asm > test1.out
	java lab2 test2.asm > test2.out
	java lab2 test3.asm > test3.out
	java lab2 test4.asm > test4.out
	diff -w -B test1.out test1.expected
	diff -w -B test2.out test2.expected
	diff -w -B test3.out test3.expected
	diff -w -B test4.out test4.expected

clean:
	rm *.out
	rm *.class

.PHONY: clean