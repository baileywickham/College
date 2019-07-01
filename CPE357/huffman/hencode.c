#include "huffman.h"
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

void usage();
__uint32_t cnt_freq(FILE*, __uint32_t[]);
void create_header(__uint32_t*, __uint32_t, int);

int main(int argc, char** argv)
{
    __uint32_t* arr = calloc(BUFFSIZE, sizeof(__uint32_t));
    CodeNode** codes = calloc(BUFFSIZE + 1, sizeof(CodeNode*));
    Node* head;
    FILE* in_file;
    int out_file;
    int c;
    CodeNode _c1;
    __uint32_t uniq; /*number of chars in the file to be written*/
    /*Writeout stuff*/
    int buff = 0;
    int bufLen = 0;
    int i = 0;

    if (argc < 2 || argc > 4) {
        usage();
        return 1;
    }
    if (argc == 2 || !strcmp("-", argv[2])) {
        out_file = 1;
    } else {
        out_file = open(argv[2], O_WRONLY | O_CREAT | O_TRUNC,
            S_IRUSR | S_IWUSR);

        if (out_file < 0) {
            perror("");
            return 1;
        }
    }

    in_file = fopen(argv[1], "r");
    if (!in_file) {
        fprintf(stderr, "%s: ", argv[1]);
        perror("");
        return 1;
    }

    uniq = cnt_freq(in_file, arr);

    head = create_huffman_tree(arr);

    _c1.size = 0;
    for (i = 0; i < 64; i++) {
        _c1.code[i] = '\0';
    }

    create_header(arr, uniq, out_file); /*write 256 contiguous bytes */

    create_code(head, _c1, codes);
    in_file = fopen(argv[1], "r");

    printInOrder(head);

    while (((c = fgetc(in_file)) != EOF)) {
        for (i = 0; i < codes[c]->size; i++) {
            if (codes[(__uint8_t)c]->code[i] == '1') {
                buff = (buff << 1) + 1;
            } else {
                buff = buff << 1;
            }
            bufLen++;

            if (bufLen == 8) {
                write(out_file, &buff, 1);
                bufLen = 0;
                buff = 0;
            }
        }
    }
    if (bufLen != 0) {
        buff = buff << (8 - bufLen);
        write(out_file, &buff, 1);
    }
    for (i = 0; i < BUFFSIZE + 1; i++) {
        if (codes[i])
            free(codes[i]);
    }

    treeDelete(head);

    fclose(in_file);
    close(out_file);
    free(arr);
    return 0;
}

void create_header(__uint32_t* arr, __uint32_t uniq, int out_file)
{
    __uint8_t i;
    write(out_file, &uniq, sizeof(__uint32_t));
    for (i = 0; i < BUFFSIZE; i++) {
        if (arr[i] > 0) {
            write(out_file, &i, sizeof(__uint8_t));
            write(out_file, &arr[i], sizeof(__uint32_t));
        }
    }
    i = 255;
    if (arr[255]) {
        write(out_file, &i, sizeof(__uint8_t));
        write(out_file, &arr[255], sizeof(__uint32_t));
    }
}

void usage()
{
    printf("hencode infile [ outfile ]\n");
}

/*cannot handle unicode*/
__uint32_t cnt_freq(FILE* file, __uint32_t buff[])
{
    int c = 0;
    __uint32_t uniq = 0;
    while (((c = fgetc(file)) != EOF)) {
        buff[(__uint32_t)c] += 1;
        if (buff[(__uint32_t)c] == 1) {
            uniq++;
        }
    }
    fclose(file);
    return uniq;
}
