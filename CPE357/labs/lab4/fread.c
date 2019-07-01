#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char** argv)
{
    char buff[300000];
    int size = atoi(argv[1]);
    FILE* f = fopen("/usr/lib/locale/locale-archive", "r");
    while (fread(buff, size, 1, f) == size) {
    };
}
