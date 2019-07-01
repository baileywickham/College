#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

void handle_sigalrm(int);
pid_t child_pid;

int main(int argc, char** argv)
{
    signal(SIGALRM, handle_sigalrm);
    alarm(strtol(argv[1], NULL, 10));
    child_pid = fork();
    if (child_pid == 0) {
        int i;
        char* args[10];
        for (i = 2; i < argc; i++) {
            args[i - 2] = argv[i];
        }
        args[i] = NULL;
        char a[100];
        sprintf(a, "/bin/%s", argv[2]);
        execv(a, args);
        perror("");
    } else {
        wait(NULL);
    }
}

void handle_sigalrm(int sig)
{
    printf("too long, killing\n");
    kill(child_pid, 9);
}
