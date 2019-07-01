#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "table.h"

#define TABLE_SIZE 191 /* intial size, can be resized*/
#define CHUNK 8

Table *reads(FILE *, Table *);

void usage();

char *lower(char *);

int tableComparitor(const void *, const void *);

int main(int argc, char **argv) {
    int i, j = 0;
    char **files = calloc(argc, sizeof(char *));
    FILE *file;
    WordBucket **minList;
    Table *table = malloc(sizeof(Table));

    table->num_items = 0;
    table->size = TABLE_SIZE;
    table->top = 10;

    /*Init buckets as null*/
    table->buckets = malloc(TABLE_SIZE * sizeof(WordBucket *));
    for (i = 1; i < table->size; i++) {
        table->buckets[i] = NULL;
    }

    /*parse args, if -n, int must follow.
     * else, read file. */
    for (i = 1; i < argc; i++) {
        /*Check -n*/
        if (!strcmp(argv[i], "-n")) {
            if (i + 1 < argc && atoi(argv[i + 1])) {
                table->top = atoi(argv[i + 1]);
                i++;
            } else {
                free(table);
                free(files);
                usage();
                return 1;
            }
        } else {
            /* Uses argv[i] as a file */
            j++; /*no stdin flag*/
            file = fopen(argv[i], "r");
            if (file) {
                table = reads(file, table);
                fclose(file);
            } else {
                fprintf(stderr, "%s: ", argv[i]);
                perror("");
            }
        }

    }
    /*Use stdin*/
    if (!j) {
        table = reads(stdin, table);
    }

    j = 0;
    minList = malloc(sizeof(WordBucket *) * table->num_items); /*qsort*/
    for (i = 0; i < table->size; i++) {
        if (table->buckets[i]) {
            minList[j++] = table->buckets[i];
        }
    }
    qsort(minList, table->num_items, sizeof(WordBucket *), tableComparitor);

    printf("The top %d words (out of %d) are:\n", table->top,
           table->num_items);
    if (table->num_items < table->top) table->top = table->num_items;
    printTable(minList, table->top);

    freeTable(table);
    free(files);
    free(minList);
    return 0;
}

/*Must return a non empty word or EOF*/
char *readWords(FILE *file) {
    char *buff = NULL;
    size_t size = 8;
    size_t end = 0;
    int c = 0;
    buff = malloc(CHUNK);
    while ((c = getc(file))) {
        if (c == EOF) { return NULL;}
        if (!isalpha(c)) { /*Ugly, but checks if empty string by checking 0len*/
            if (end == 0) {
                continue;
            } else {
                break;
            }
        }
        if (end == size -1) {
            size += CHUNK;
            buff = realloc(buff, size);
        }
        buff[end] = c;
        end++;
    }
    buff[end] = '\0';
    return buff;
}

/* takes a FILE ptr and reads from it*/
Table *reads(FILE *file, Table *table) {
    char *word = NULL;

    unsigned long hashed_value = 0;
    WordBucket *found = NULL;

    while ((word = readWords(file))) {
        WordBucket *new;

        word = lower(word);
        hashed_value = hash(word, table->size);
        found = find(hashed_value, table, word);
        if (found) {
            found->count++;
            free(word); /*Free duplicates*/
        } else {
            new = (WordBucket *) malloc(sizeof(WordBucket));
            new->word = word; /*Movinig pointer, not copying */
            new->count = 1;
            table = insert(hashed_value, new, table);
        }
    }
    return table;
}

void usage() {
    printf("usage: fw [-n num] [ file1 [ file 2 ...] ]\n");
}

int tableComparitor(const void *p1, const void *p2) {

    WordBucket *w1 = *(WordBucket **) p1;
    WordBucket *w2 = *(WordBucket **) p2;
    if (w1->count - w2->count == 0) {
        return strcmp(w2->word, w1->word);
    }
    return w2->count - w1->count;
}


char *lower(char *c) {
    int i = 0;
    while (c[i]) {
        c[i] = tolower(c[i]);
        i++;
    }
    return c;
}


