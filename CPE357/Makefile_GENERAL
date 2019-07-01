CC = gcc
CC_FLAGS = -Wall -Werror -ansi -pedantic -g

EXEC = run
SRCS = $(wildcard *.c)
OBJECTS = $(SRCS:.c=.o)

$(EXEC): $(OBJECTS)
	$(CC) $(OBJECTS) -o $(EXEC)

%.o: %.c
	$(CC) -c $(CC_FLAGS) $< -o $@  

clean:
	rm -f *.o *.out
