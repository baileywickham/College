CC=gcc
CFLAGS= -g -Wall -ansi -Werror -pedantic

all: hencode hdecode

hencode: huffman.o
	$(CC) hencode.c huffman.o $(CFLAGS) -o hencode

hdecode: huffman.o
	$(CC) hdecode.c huffman.o $(CFLAGS) -o hdecode

huffman.o: huffman.c
	$(CC) -c $(CFLAGS) huffman.c

clean:
	rm *.o hencode hdecode
