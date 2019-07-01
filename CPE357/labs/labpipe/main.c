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
    int p[2];
    pipe(p);
    pid_t pid;

    if ((pid = fork()) == 0) {
        /*child*/
        char cmd[100];
        sprintf(cmd, "/usr/bin/%s", argv[3]);
        dup2(p[PIPE_RD], STDIN_FILENO);
        close(p[0]);
        close(p[1]);
        execl(cmd, argv[3], NULL);
    } else {
        char cmd[100];
        sprintf(cmd, "/bin/%s", argv[1]);
        dup2(p[PIPE_WR], STDOUT_FILENO);
        close(p[0]);
        close(p[1]);
        execl(cmd, argv[1], NULL);
    }
}
