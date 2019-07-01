#include "mytr.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int parse(char*, int*);

int main(int argc, char** argv)
{
    int map[256];
    int i = 0;
    int c = 0;
    int* set2 = NULL;
    int* set1 = NULL;
    int set2_size = 0;
    int set1_size = 0;

    /*alloc array*/
    for (i = 0; i < 256; i++) {
        map[i] = i;
    }

    if (argc != 3) {
        printf("Usage: mytr -d ...\n");
        return 1;
    }

    set2 = malloc(strlen(argv[2]) * sizeof(int));
    set2_size = parse(argv[2], set2);
    if (argv[1][0] == '-' && argv[1][1] != 'd') {
        printf("Usage: mytr -d\n");
        return 1;
    }
    if (strcmp(argv[1], "-d")) {
        /*parse "*/
        set1 = malloc(strlen(argv[1]) * sizeof(int));
        set1_size = parse(argv[1], set1);
        for (i = 0; i < set2_size + 1 && i < set1_size; i++) {
            map[set1[i]] = set2[i];
        }
        for (i = set2_size - 1; i < set1_size; i++) {
            map[set1[i]] = set2[set2_size - 1];
        }

    } else {
        for (i = 0; i < set2_size; i++) {
            map[set2[i]] = 0;
        }
    }
    while ((c = getchar()) != EOF) {
        if (map[c] != 0) {
            putchar(map[c]);
        }
    }
    return 0;
}
/* takes a "set" and mutatues an array with the ascii, returns new size */
int parse(char* c, int* arr)
{
    int size = 0;
    int i = 0;
    /*fails on strlen 0*/
    /*if (c[0] != '"' || c[strlen(c) - 1] != '"') {
        printf("Improperly formatted strings: %s\n", c);
        exit(1);
    }
     */
    for (i = 0; i < strlen(c); i++) {
        if (c[i] == '\\') {
            switch (c[i + 1]) {
            case '\\':
                arr[size] = 92;
                break;
            case 'n':
                arr[size] = 10;
                break;
            case 't':
                arr[size] = 9;
                break;
            default:
                arr[size] = (int)c[i + 1];
            }
            i++;
            size++;
        } else {
            arr[i] = (int)c[i];
            size++;
        }
    }
    return size;
}
