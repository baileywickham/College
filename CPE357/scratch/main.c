#include "ctype.h"
#include "stdio.h"
#include "stdlib.h"
#define CHUNK 8

char* readWords(FILE*);

int main()
{
    char* c = NULL;
    c = readWords(stdin);
    printf("%s\n", c);
    c = readWords(stdin);
    printf("%s\n", c);
}

char* readWords(FILE* file)
{
    char* buff = NULL;
    size_t size = 8;
    size_t end = 0;
    char c;
    buff = malloc(CHUNK);
    while (isalpha((c = getc(file)))) {
        if (end == size) {
            size += CHUNK;
            buff = realloc(buff, size);
        }
        buff[end] = c;
        end++;
    }
    return buff;
}
