#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <sys/time.h>
#include <unistd.h>

void wave();

int main(int argc, char** argv)
{
    int a;
    signal(SIGALRM, wave);
    a = alarm(strtol(argv[2], NULL, 10));
    struct timeval interval = {} setitimer(NULL, )
}
void wave()
{
    printf("TICK\n");
}
