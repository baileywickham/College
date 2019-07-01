#include <stdio.h>
#include <string.h>
#include <arpa/inet.h>
#include <stdint.h>
#include "read_mytar.h"
#include "write_mytar.h"
#include <stdlib.h>

unsigned char c=0,t=0,x=0,v=0,f=0,S=0;
void usage();

int main(int argc, char** argv) {
    int i = 0;
    char *_;
    if (argc < 3) {
        usage();
        return 1;
    }

    for (i = 0; i < strlen(argv[1]); i++) {
        switch (argv[1][i]) {
            case 'c':
                c++;
                break;
            case 't':
                t++;
                break;
            case 'x':
                x++;
                break;
            case 'v':
                v++;
                break;
            case 'f':
                f++;
                break;
            case 'S':
                S++;
                break;
        }
    }
    if (!(c || t || x)) {
        usage();
        return 1;
    }

    if (c) {
        FILE* tarfile;
        tarfile = fopen(argv[2], "w");
        for (i = 3; i < argc; i++ ) {
            parse_dir(argv[i], tarfile);
        }
        _ =calloc(BLOCKSIZE * 2, 1);
        fwrite(_, BLOCKSIZE * 2, 1, tarfile);
        free(_);
        fclose(tarfile);
    }
    if (t || x) {
        FILE* file = fopen(argv[2], "r");
        if (!file) {
            perror("");
            return 1;
        }
        read_mytar(file, argc, argv);
    }

    return 0;

}

void usage() {
    fprintf(stderr, "Usage: mytar [ctxvS]f tarfile [ path [ ... ] ]\n");
}


unsigned int cal_chk(BlockHeader* h)
{
    unsigned int chksum = 0;
    unsigned char* header = (unsigned char*)h;
    int i;
    for (i = 0; i <= BLOCKSIZE; i++) {
        chksum += *header++;
    }
    return chksum;
}