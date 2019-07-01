CC = gcc
CC_FLAGS = -Wall -Werror -ansi -pedantic -g

MAIN = fw
SRCS = $(wildcard *.c)
OBJS = $(SRCS:.c=.o)

$(MAIN): $(OBJS)
	$(CC) $(OBJS) -o $(MAIN)

%.o: %.c
	$(CC) -c $(CC_FLAGS) $< -o $@  

clean:
	rm -f *.o *.out
