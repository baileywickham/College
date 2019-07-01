#define BUFFSIZE 255
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>

typedef struct Node {
    __uint8_t c;
    __uint32_t freq;
    struct Node* left;
    struct Node* right;
} Node;

typedef struct{
    char code[64];
    int size;
} CodeNode;

Node* create_node(int, int);
Node* combine(Node*, Node*);
Node* create_huffman_tree(__uint32_t[]);
void create_code(Node*, CodeNode , CodeNode**);
void treeDelete(Node*);
void printInOrder(Node*);


