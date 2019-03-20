/**
 * CSC 225, Assignment 8
 */

#define MAXLINE 101 /* The maximum length of a line, plus one. */
/**
 * Represents a node in a linked list of word occurrences.
 */
typedef struct Node {
    char line[MAXLINE]; /* The line in which the word occurs */
    int lineNum;        /* The number of that line within the file */
    struct Internal* inHead;
    struct Internal* inTail;
    struct Node* next; /* The next node in the list, NULL if none */
} Node;

typedef struct Internal {
    int wordNum;
    struct Internal* next;
} Internal;

Node* addToTail(Node*, char*, int, int);
Node* rmFromHead(Node*, char*, int*);
Internal* rmFromInternal(Internal*, int*);
void printList(Node*);
