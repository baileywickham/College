CC = gcc
CFLAGS = -Wall -ansi -pedantic -g  -std=c90
MAIN = run
OBJS = part6.o part6_tests.o
all : $(MAIN)

$(MAIN) : $(OBJS) 
	$(CC) $(CFLAGS) -o $(MAIN) $(OBJS)

part6_tests.o : part6_tests.c 
	$(CC) $(CFLAGS) -c part6_tests.c

part6.o : part6.c part6.h
	$(CC) $(CFLAGS) -c part6.c

clean :
	rm *.o $(MAIN) core
