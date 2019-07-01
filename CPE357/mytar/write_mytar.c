#include "write_mytar.h"
#include <dirent.h>
#include <grp.h>
#include <pwd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>


extern unsigned char v;
extern unsigned char x;
extern unsigned char t;
extern unsigned char c;

int parse_dir(char path[256], FILE* tar_file)
{
    /*Assume this path is a dir*/
    struct stat head;

    if ((stat(path, &head)) < 0) {
        printf("\n%s\n", path);
        perror("");
        return 1;
    }

    if (S_ISDIR(head.st_mode) && path[strlen(path)] != '/') {
        strcat(path, "/");
    }

    add_entry(head, path, tar_file);


    if (v) {
        printf("%s\n", path);
    }
    if (S_ISDIR(head.st_mode)) {

        DIR* dir = opendir(path);
        struct dirent* entry;
        if (!dir)
            perror("");
        while ((entry = readdir(dir))) {
            char newpath[256];
            if (!strcmp(entry->d_name, ".") || !strcmp(entry->d_name, "..")) {
                continue;
            }
            strcpy(newpath, path);
            strcat(newpath, entry->d_name);
            parse_dir(newpath, tar_file);
        }
        closedir(dir);
    }
    return 0;
}

int add_entry(struct stat filestat, char* name, FILE* tar_file)
{
    BlockHeader* fileheader = calloc(BLOCKSIZE, 1);
    struct passwd* pws;
    struct group* grp;

    if (strlen(name) > 100) {
        char *l = strrchr(name, '/');
        *l = '\0';
        strcpy(fileheader->prefix, name);
        strcpy(fileheader->name, l + 1);
        *l = '/';
    } else {
        strcpy(fileheader->name, name);
    }
    /*mode*/
    sprintf(fileheader->mode, "%07o", filestat.st_mode); /*possibly clean 012*/
    fileheader->mode[2] = '0';
    fileheader->mode[1] = '0';
    fileheader->mode[0] = '0';

    sprintf(fileheader->uid, "%07o", filestat.st_uid);
    sprintf(fileheader->gid, "%07o", filestat.st_gid);
    sprintf(fileheader->size, "%011lo", filestat.st_size);
    sprintf(fileheader->mtime, "%011lo", filestat.st_mtime);

    strcpy(fileheader->chksum, "       ");
    fileheader->chksum[7] = ' ';

    if (S_ISREG(filestat.st_mode)) {
        fileheader->typeflag[0] = '0';
    } else if (S_ISDIR(filestat.st_mode)) {
        fileheader->typeflag[0] = '5';
        strcpy(fileheader->size, "00000000000");
    } else if (S_ISLNK(filestat.st_mode)) {
        strcpy(fileheader->size, "00000000000");
        fileheader->typeflag[0] = '2';
        /*
        readlink(name, fileheader.linkname, 100);
*/
    }
    strcpy(fileheader->magic, "ustar");
    strcpy(fileheader->version, "00");

    pws = getpwuid(filestat.st_uid);
    strcpy(fileheader->uname, pws->pw_name);

    grp = getgrgid(filestat.st_gid);
    strcpy(fileheader->gname, grp->gr_name);

    sprintf(fileheader->chksum, "%07o", cal_chk(fileheader));

    if (c) {
        fwrite(fileheader, BLOCKSIZE, 1, tar_file);
    }

    if (fileheader->typeflag[0] == '0' && c && filestat.st_size > 0) {
        FILE* in_file = fopen(name, "r");
        /*yikes*/
        int rsize = -((filestat.st_size % BLOCKSIZE) - 512);
        unsigned char* data = calloc(filestat.st_size + rsize, 1);

        fread(data, filestat.st_size, 1, in_file);
        fwrite(data, rsize + filestat.st_size, 1, tar_file);

        fclose(in_file);
        free(data);
    }
    free(fileheader);
    return 0;
}



