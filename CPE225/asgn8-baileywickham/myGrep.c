#include "wordList.h"
#include <stdio.h>
#include <string.h>

int main(int argc, char** argv)
{
    int wordCounter = 0, lineCounter = 0, numOfSeen = 0;
    char buff[100];
    char* ptr = NULL;
    char longest[100];
    int len = 0;
    FILE* file;
    Node* tail = NULL;
    Node* head = NULL;

    if (argc != 3) {
        printf("myGrep: Improper number of arguments\n");
        printf("Usage: %s <word> <filename>\n", argv[0]);
        return 1;
    }
    file = fopen(argv[2], "r");
    if (file == NULL) {
        printf("myGrep: Unable to open file: %s", argv[2]);
        return 1;
    }
    printf("%s %s %s\n", argv[0], argv[1], argv[2]);

    while (fgets(buff, 100, file) != NULL) {
        char line[100];
        strcpy(line, buff);

        if (strlen(buff) > len) {
            len = strlen(buff);
            strcpy(longest, line);
        }

        ptr = strtok(buff, "\",:;!?.\n\t ");
        wordCounter = -1;
        while (ptr) {
            wordCounter++;
            if (strcmp(ptr, argv[1]) == 0) {
                numOfSeen++;
                if (head == NULL) {
                    head = addToTail(NULL, line, lineCounter, wordCounter);
                    tail = head;
                } else {
                    tail = addToTail(tail, line, lineCounter, wordCounter);
                }
            }
            ptr = strtok(NULL, "\",:;!?.\n\t ");
        }
        lineCounter++;
    }
    printf("Longest line (%d characters): %s", len, longest);
    printf("Number of lines: %d\n", lineCounter);
    printf("Total occurrences of \"%s\": %d\n", argv[1], numOfSeen);
    while (head) {
        char line[100];
        int lineNum;
        int wordNum;
        head = rmFromHead(head, line, &lineNum, &wordNum);
        printf("Line %d, word %d: %s", lineNum, wordNum, line);
    }

    return 0;
}
