#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char** argv)
{
    char buff[3000];
    int size = atoi(argv[1]);
    int fd;

    fd = open("/usr/lib/locale/locale-archive", O_RDONLY);
    perror("");
    while (read(fd, buff, size) == size)
        ;
}
