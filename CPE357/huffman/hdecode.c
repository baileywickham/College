#include "huffman.h"
#include <fcntl.h>
#include <stdio.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>


Node* check_node(Node*, char*, Node*, int*);

int main(int argc, char** argv)
{
    /* Todo handle files*/
    int in_file = open(argv[1], O_RDONLY);
    int error;
    int tail = 0;
    __uint32_t uniq = 0;
    __uint32_t intBuff = 0;
    __uint8_t charBuff = 0;
    int i = 0;
    int totalChars = 0;
    Node* head;
    Node* node;
    char* outBuff;
    FILE* out_file = fopen(argv[2], "w");

    __uint32_t* arr = calloc(BUFFSIZE + 1, sizeof(__uint32_t));

    error = read(in_file, &intBuff, 4);
    if (error < 0)
        perror("");
    uniq = (__uint32_t)intBuff;

    for (i = 0; i < uniq; i++) {
        read(in_file, &charBuff, 1);
        read(in_file, &intBuff, 4);
        arr[charBuff] = intBuff;
        totalChars += intBuff; /*count numebr of chars*/
    }

    head = create_huffman_tree(arr);

    outBuff = calloc(totalChars + 100, sizeof(char));

    if (uniq == 1) {
        for (i = 0; i < totalChars; i++) {
            outBuff[i] = head->c;
        }
        fwrite(outBuff, totalChars, 1, out_file);
        return 0;
    }


    node = head;
    charBuff = 0;
    while ((error = read(in_file, &charBuff, 1)) > 0) {
        __uint8_t mask = 128;
        int res;
        for (i = 0; i < 8; i++) {
            res = mask & charBuff;
            mask = mask >> 1;
            if (res) {
                node = node->right;
                node = check_node(node, outBuff, head, &tail);

            } else {
                node = node->left;
                node = check_node(node, outBuff, head, &tail);
            }
        }
    }


    fwrite(outBuff, totalChars, 1, out_file);
    return 0;
}


Node* check_node(Node* node, char* outBuff, Node* head, int* tail) {
    if (!node->left && !node->right) {
        outBuff[(*tail)++] = node->c;
        node = head;
        return node;
    } else {
        return node;
    }
}

