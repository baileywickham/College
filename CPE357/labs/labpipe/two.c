#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>
#define PIPE_RD 0
#define PIPE_WR 1
// stdin 0
// stdout 1
//  ls | wc
int main(int argc, char** argv)
{
    int i = strtol(argv[1], NULL, 10);
    int p[2];
    pipe(p);
    pid_t pid;

    if ((pid = fork()) == 0) {
        /*child*/
        close(p[0]);
        close(p[1]);
        printf("num: %d\n", i * 2 + 1);
    } else {
        close(p[0]);
        close(p[1]);
        write(p[PIPE_WR], &i, 1);
    }
}
