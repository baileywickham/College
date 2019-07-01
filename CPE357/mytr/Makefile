CC = gcc
CFLAGS = -Wall -ansi -pedantic -g -std=c90
MAIN = mytr
OBJS = mytr.o

TESTS = tests.o

all : $(MAIN)

$(MAIN) : $(OBJS) 
	$(CC) $(CFLAGS) -o $(MAIN) $(OBJS)

mytr.o : mytr.c mytr.h
	$(CC) $(CFLAGS) -c mytr.c

.PHONY: clean
clean:
	rm *.o mytr test out.txt me.txt

