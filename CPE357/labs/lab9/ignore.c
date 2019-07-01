#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void handle_sigint(int);

int main(int argc, char** argv)
{
    signal(SIGINT, handle_sigint);
    while (1) {
        char* block = calloc(512, 1);
        scanf("%s", block);
        if (!strcmp(block, "quit"))
            return 0;
        printf("%s\n", block);
        free(block);
    }
}

void handle_sigint(int sig)
{
    printf("caught sigint, use quit, not ctrl c\n");
}
