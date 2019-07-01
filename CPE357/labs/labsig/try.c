#include <stdio.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

int main(int argc, char** argv)
{
    char* args[2];
    args[0] = argv[1];
    args[1] = NULL;
    int st;

    int pid = fork();
    if (!pid) {
        if (execv(argv[1], args) < 0) {
            perror("");
            return 1;
        }
    } else {
        waitpid(pid, &st, 0);
        if (st > 0) {
            printf("child exited with error: %d\n", st);
        } else {
            printf("%d done\n", st);
        }
    }
}
