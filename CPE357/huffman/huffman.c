#include <stdlib.h>
#include <stdio.h>
#include "huffman.h"
#include <stdint.h>

/* Returns > 0 if a comes before b in tree*/
int comes_before(const void* c, const void* d) {
    Node *a = *(Node **) c;
    Node *b = *(Node **) d;
    return (a->freq == b->freq) ? a->c - b->c : a->freq - b->freq;
}
int lame_comes_before(const void* c, const void* d) {
    Node *a = *(Node **) c;
    Node *b = *(Node **) d;
    return (a->freq == b->freq) ? -1 : a->freq - b->freq;
}

Node* create_huffman_tree(uint32_t freq[]) {
    int i;
    int size = 0;
    Node** nodeList;
    for (i = 0; i <= BUFFSIZE; i++) if (freq[i] > 0) size++;
    nodeList = malloc(size * sizeof(Node*));

    size = 0;
    for (i = 0; i <= BUFFSIZE; i++) {
        if (freq[i] > 0) {
            Node* newNode = create_node(freq[i], i);
            nodeList[size++] = newNode;
        }
    }
    i = 0;
    qsort(nodeList, size, sizeof(Node*), comes_before);
    while (size > 1) {
        /* Bad implimentation*/
        Node* a;
        Node* b;
        qsort(nodeList + i, size, sizeof(Node*),
              lame_comes_before);
        a = nodeList[i++];
        b = nodeList[i];
        nodeList[i] = combine(a, b);
        size--;
    }

    return nodeList[i];
}

Node* create_node(int freq, int c) {
    Node* new = malloc(sizeof(Node));
    new->freq = freq;
    new->c = c;
    new->left = NULL;
    new->right = NULL;
    return new;

}

Node* combine(Node* a, Node* b) {
    Node* newNode = create_node(a->freq + b->freq, 0);
    newNode->left = a;
    newNode->right = b;
    return newNode;
}

void treeDelete(Node *node) {
    if (node->left) treeDelete(node->left);

    if (node->right) treeDelete(node->right);

    if (node && !node->right && !node->left) {
        free(node);
        return;
    }

}

void printInOrder(Node *node) {
    if (!node) {
        return;
    }
    printInOrder(node->left);
    if (node->c) {
    printf("char %d, freq %d\n", node->c, node->freq);
    }
    printInOrder(node->right);
}



void create_code(Node* node, CodeNode codeNode, CodeNode** list) {
    if (node) {
        if (!node->right && !node->left) {
            CodeNode *newNode = malloc(sizeof(CodeNode));

            strcpy(newNode->code, codeNode.code);
            newNode->size = codeNode.size;
            list[node->c] = newNode;

        } else {
            if (node->left) {
                CodeNode newNode = codeNode;
                newNode.size++;
                strcat(newNode.code, "0");

                create_code(node->left, newNode, list);
            }
            if (node->right) {
                CodeNode newNode = codeNode;
                newNode.size++;
                strcat(newNode.code, "1");
                create_code(node->right, newNode, list);
            }
        }
    }
}
