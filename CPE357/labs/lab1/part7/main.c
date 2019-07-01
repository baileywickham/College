#include <stdio.h>

int main(int size, char** argv)
{
    int i = 0;
    for (i = 0; i < size; i++) {
        if (argv[i][0] == '-') {
            printf("%s\n", argv[i]);
        }
    }
    return 0;
}
