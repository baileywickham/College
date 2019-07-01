#include <limits.h>
#include <stdio.h>
#include <unistd.h>

int main()
{

    printf("CHILD: %d\nOPEN: %d\nPAGE: %d\n", sysconf(_SC_CHILD_MAX), sysconf(_SC_OPEN_MAX), sysconf(_SC_PAGE_SIZE));
}
