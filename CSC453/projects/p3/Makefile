CC = gcc
CC_FLAGS = -Wall -Werror -g

EXEC = p03
SRCS = $(wildcard *.c)
OBJECTS = $(SRCS:.c=.o)

all: p03 two

p03: rr.o
	$(CC) $(CC_FLAGS) rr.o p03.c -o $(EXEC)

rr.o:
	$(CC) $(CC_FLAGS) -c rr.c
two:
	$(CC) two.c -o two

clean:
	rm -f *.o *.out p03 two
