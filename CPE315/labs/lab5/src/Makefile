all: compile
lab5: compile

compile:
	javac *.java

test: compile
	java lab5 ../tst/mem_stream.1 > test1.out
	java lab5 ../tst/mem_stream.2 > test2.out
	diff -w -B test1.out mem_stream1.expected
	diff -w -B test2.out mem_stream2.expected

clean:
	rm -f *.out
	rm -f *.class

.PHONY: clean
