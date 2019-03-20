CC = gcc
CC_FLAGS = -Wall -Werror -ansi -pedantic

EXEC = run
SRCS = $(wildcard *.c)
OBJECTS = $(SRCS:.c=.o)

$(EXEC): $(OBJECTS)
	$(CC) $(OBJECTS) -o $(EXEC)

%.o: %.c
	$(CC) -c $(CC_FLAGS) $< -o $@  
