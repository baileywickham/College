#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define CHUNK 4

char* readLongLines(FILE*);
int main(int argc, char** argv)
{
    char* ptr;
    FILE* f = fopen(argv[1], "r");
    char last[100] = "";
    while (*(ptr = readLongLines(f)) != '\0') {
        if (strcmp(last, ptr)) {
            printf("%s", ptr);
        }
        strcpy(last, ptr);
    }
}

char* readLongLines(FILE* file)
{
    char* buff = NULL;
    size_t size = 8; /*8 to begin*/
    size_t end = 0;
    buff = malloc(CHUNK);
    /* Start at buff but shifted over*/
    while (fgets(buff + end, CHUNK, file)) {
        size += CHUNK;
        end = strlen(buff);
        buff = realloc(buff, size);
        /*if last char is \n break, signifies EOL, probably could be more ellagant*/
        if (buff[strlen(buff) - 1] == '\n') {
            break;
        }
    }
    return buff ? buff : NULL;
}
