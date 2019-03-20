/**
 * CSC 225, Assignment 8
 */

/* TODO: Included any required libraries. */
#include "wordList2.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
/**
 * Adds a new occurrence to the end of a list.
 * tail - A pointer to the current tail of a list, NULL if it's empty.
 * line - The line in which the word occurs
 * lineNum - The number of that line within the file
 * wordNum - The position of that word within that line
 *
 * Returns a pointer to the new tail of the list.
 */
Node* addToTail(Node* tail, char* line, int lineNum, int wordNum)
{
    /* TODO: Implement this function. */
    struct Node* newNode = NULL;
    struct Internal* newInternal = NULL;

    newNode = (struct Node*)malloc(sizeof(struct Node));
    newInternal = (struct Internal*)malloc(sizeof(struct Internal));
    newInternal->wordNum = wordNum;
    newInternal->next = NULL;

    strcpy(newNode->line, line);
    newNode->lineNum = lineNum;
    newNode->next = NULL;
    if (tail) {
        tail->next = newNode;
        if (tail->inHead == NULL) {
            printf("enter\n");
            tail->inHead = newInternal;
            tail->inTail = newInternal;
        } else {
            tail->inTail->next = newInternal;
        }
    }

    return newNode;
}

/**
 * Removes an occurrence from the beginning of a list.
 * head - A pointer to the current head of a list, NULL if it's empty
 * line - A pointer at which to store the removed line
 * lineNum - A pointer at which to store the removed line number
 * wordNum - A pointer at which to store the removed word number
 *
 * Returns a pointer to the new head of the list, NULL if it's (now) empty.
 */
Node* rmFromHead(Node* head, char* line, int* lineNum)
{
    /* TODO: Implement this function. */
    Node* tmp = NULL;
    if (head == NULL) {
        return NULL;
    }
    strcpy(line, head->line);
    *lineNum = head->lineNum;
    tmp = head->next;
    free(head);
    return tmp;
}

Internal* rmFromInternal(Internal* in, int* num)
{
    Internal* tmp = NULL;
    if (!in) {
        return NULL;
    }
    *num = in->wordNum;
    tmp = in->next;
    free(in);
    return tmp;
}
/**
 * Prints out every node in a list.
 * head - A pointer to the head of a list, NULL if it's empty
 */
void printList(Node* head)
{
    /* TODO: Implement this function. */
    Node* current = head;
    while (current != NULL) {
        current = current->next;
    }
}
