#include <stdio.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

int main()
{
    int pid = fork();
    if (pid) {
        printf("hello from parent\n");
        wait(NULL);
    }
    if (!pid) {
        printf("child %d\n", getpid());
    } else {
        printf("parent %d\n", getpid());
        printf("goodbye from parent %d\n", getpid());
    }
}
