all:
	gcc -g -Wall client.c -o client -lpthread
	gcc -g -Wall server.c -o server -lpthread


test: all
	cp server ./test
	cp client ./test
	rm ./test/log
