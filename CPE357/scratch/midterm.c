#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char** argv)
{
    char cmd[512];
    sprintf(cmd, "%s < %s", argv[1], argv[2]);
    system(cmd);
}
