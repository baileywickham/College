#include <stdlib.h>
#include "table.h"
#include <string.h>
#include <stdio.h>

/*returns table if resized, cannot modify if resized */
Table* insert(unsigned long hashed_value, WordBucket* wn, Table* t)
{
    unsigned long h = hashed_value;
    int i;
    for (i = 0; i < t->size; i++) {
        if (t->buckets[h] == NULL) {
            /* if the bucket is empty */
            t->buckets[h] = wn;
            t->num_items++;
            break;
        }
        h = (hashed_value + (i * i)) % t->size;
    }
    /*read to resize or return error*/
    if (getLoadFactor(t) > .5) {
        t = resize(t);
    }
    return t;
}
/* returns a pointer to the bucket containing the word */
WordBucket* find(unsigned long hashed_value, Table* table, char* word)
{
    unsigned long h = hashed_value;
    int i;
    for (i = 0; i < table->size; i++) {
        if (table->buckets[h] == NULL) return NULL;
        if (strcmp(table->buckets[h]->word, word) != 0) {
            /* if the bucket is either null, or not equal*/
            h = (hashed_value + (i * i)) % table->size;
        } else {
            return table->buckets[h];
        }
    }
    return NULL;
}

float getLoadFactor(Table* t)
{
    float a = t->num_items;
    float b = t->size;
    return a / b;
}

Table* resize(Table* table) {
    int i = 0;
    unsigned long h;
    Table* new = malloc(sizeof(Table *));
    new->size = 4 * table->size + 1;
    new->top = table->top;
    new->num_items = 0;
    new->buckets = malloc(sizeof(WordBucket*) * new->size);

    for (i = 0; i < new->size; i++) {
        new->buckets[i] = NULL;
    }
    for (i = 0; i < table->size; i++) {
        if (table->buckets[i]) {
            h = hash(table->buckets[i]->word, new->size);
            insert(h,table->buckets[i], new);
        }
    }
    free(table->buckets);
    free(table);

    return new;
}



void printTable(WordBucket** wb, int size)
{
    int i;
    for (i = 0; i < size; i++) {
        if (wb[i]) {
            printf("%9d %s\n", wb[i]->count, wb[i]->word);
        }
    }
}

/* stolen from some university. I am not smart enough to write a hash function*/
unsigned long
hash(char* str, int table_size)
{
    unsigned long hash = 5381;
    int c;

    while ((c = *str++))
        hash = ((hash << 5) + hash) + c; /* hash * 33 + c */
    return hash % table_size;
}

void freeTable(Table* table) {
    int i = 0;
    if (table->buckets) {
        for (i = 0; i < table->size; i++) {
            if (table->buckets[i]) {
                free(table->buckets[i]->word);
            }
        }
     free(table->buckets);
    }
    free(table);
}

