CC=gcc
CFLAGS= -g -Wall -ansi -pedantic -std=c99 -D_DEFAULT_SOURCE -D_BSD_SOURCE 

all: mytar

.PHONY: mytar read_mytar.o write_mytar.o clean

mytar: read_mytar.o write_mytar.o
	$(CC) mytar.c read_mytar.o write_mytar.o $(CFLAGS) -o mytar

read_mytar.o:
	$(CC) -c $(CFLAGS) read_mytar.c

write_mytar.o:
	$(CC) -c $(CFLAGS) write_mytar.c

clean:
	rm mytar *.o
