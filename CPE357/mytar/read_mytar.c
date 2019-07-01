#include "read_mytar.h"
#include "mytar.h"
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <time.h>
#include <unistd.h>

extern unsigned char v;
extern unsigned char x;
extern unsigned char t;
extern unsigned char c;
extern unsigned char S;


int read_mytar(FILE *tarfile, int argc, char **argv) {
    char f = 1;
    int i;
    unsigned int ck;
    while (1) {
        BlockHeader *header = calloc(BLOCKSIZE, 1);
        if ((fread(header, 1, BLOCKSIZE, tarfile) < BLOCKSIZE))
            break;

        if (!header->name[0])
            break;
        ck = strtol(header->chksum, NULL, 8);
        strcpy(header->chksum, "       ");
        header->chksum[7] = ' ';
        if (cal_chk(header) != ck) {
            fprintf(stderr, "bad header\n");
            return 1;
        }
        if (S && strict(header)) {
            fprintf(stderr, "bad header\n");
            return 1;
        }

        char *path = calloc(255, 1);
        if (header->prefix[0]) {
            sprintf(path, "%s/%s", header->prefix, header->name);
        } else {
            strncpy(path, header->name, 100);
        }

        f = in_args(argc, argv, path);

        if (x && f) {
            char *p;
            for (p = strchr(path + 1, '/'); p; p = strchr(p + 1, '/')) {
                *p = '\0';
                mkdir(path, 0777);
                *p = '/';
            }
        }
        write_file(header, tarfile, f, path);

        free(header);
    }
    return 0;
}

int in_args(int argc, char** args, char* path) {
    int i, f;
    if (argc < 4) return 1;
    f = 0;
    for (i = 3; i < argc; i++) {
        f = strstr(path, args[i]) ? 1 : f;
    }
    return f;
}

int write_file(BlockHeader *header, FILE *tarfile, char f, char* path) {
    unsigned char *data;

    if (t && f) {
        if (v) {
            char *p = perm(header);
            p[10] = '\0';
            time_t rawtime = strtol(header->mtime, NULL, 8);
            struct tm *timeinfo;
            char date[17];
            char name[17];
            snprintf(name, 17, "%s/%s", header->uname, header->gname);

            timeinfo = localtime(&rawtime);
            strftime(date, 17, "%Y-%m-%d %H:%M", timeinfo);
            printf("%10s %-17s %8ld %16s %s\n", p,
                   name,
                   strtol(header->size, NULL, 8),
                   date,
                   path);
            free(p);
        } else {
            printf("%s\n", path);
        }
    }
    if (x && v && f) {
        printf("%s\n", path);
    }

    if (header->typeflag[0] == '5' && x && f) {
            mkdir(path, strtol(header->mode, NULL, 8));

    }
    if (header->typeflag[0] == '2' && x && f) {
            symlink(header->linkname, path);
            chown(path, strtol(header->uid, NULL, 8),
                  strtol(header->gid, NULL, 8));
            chmod(path, strtol(header->mode, NULL, 8));
    }
    if (!header->typeflag[0] || header->typeflag[0] == '0') {
        FILE *file;
        long int size;
        unsigned int rsize;
        size = strtol(header->size, NULL, 8);
        rsize = -((size % BLOCKSIZE) - 512);

        data = calloc(rsize + size, 1);
        fread(data, rsize + size, 1, tarfile);

        if (x && f) {
            file = fopen(path, "w");

            fwrite(data, size, 1, file);
            chown(path, strtol(header->uid, NULL, 8),
                  strtol(header->gid, NULL, 8));
            chmod(path, strtol(header->mode, NULL, 8));
            /*Don't have to worry about time probably */
        }
        free(path);
        free(data);
    }

    return 0;
}

int strict(BlockHeader *header) {
    if (!strcmp(header->version, "00") && !strcmp(header->magic, "ustar")) {
        return 0;
    }
    return 1;
}

char *perm(BlockHeader *header) {
    char *p = calloc(11, 1);
    char mask[4];
    int i = 0;
    p[0] = '-';
    if (header->typeflag[0] == '5') {
        p[0] = 'd';
    }
    if (header->typeflag[0] == '2') {
        p[0] = 'l';
    }

    mask[0] = header->mode[4];
    mask[1] = header->mode[5];
    mask[2] = header->mode[6];

    for (i = 0; i < 3; i++) {
        switch (mask[i]) {
            case '0':
                strcat(p, "---");
                break;
            case '1':
                strcat(p, "--x");
                break;
            case '2':
                strcat(p, "-w-");
                break;
            case '3':
                strcat(p, "-wx");
                break;
            case '4':
                strcat(p, "r--");
                break;
            case '5':
                strcat(p, "r-x");
                break;
            case '6':
                strcat(p, "rw-");
                break;
            case '7':
                strcat(p, "rwx");
                break;
        }
    }
    return p;
}
