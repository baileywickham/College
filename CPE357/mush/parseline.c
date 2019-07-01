#include "parseline.h"
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int parseline(char*);
char* trimheader(char*);
char* getnextword(char*);
void err();

int main(int argc, char** argv)
{
    char line[MAXLINE];
    printf("line: ");

    fgets(line, MAXLINE, stdin);
    if (strlen(line) == MAXLINE) {
        fprintf(stderr, "command too long");
        err();
        exit(1);
    }
    line[strlen(line) - 1] = '\0';

    if (line[0] == ' ' && !line[1]) {
        fprintf(stderr, "no empty");
        exit(1);
    }

    parseline(line);

    return 0;
}

int parseline(char* line)
{
    char* token;
    char* r = line;
    int stage = 0;
    int i;

    while ((token = strtok_r(r, "|", &r))) {
        cmd curr;
        curr.stage = stage;
        curr.argc = 0;
        curr.command[0] = '\0';
        strcpy(curr.stagec, token);

        char* stoken;
        char* s = token;
        char* end;
        curr.out[0] = 0;
        curr.in[0] = 0;
        if (stage > 0) {
            sprintf(curr.in, "pipe from stage %d", curr.stage - 1);
        }

        while ((stoken = strtok_r(s, " ", &s))) {
            if (!(curr.command[0])) {
                strcpy(curr.command, stoken);
                strcpy(curr.argv[0], stoken);
                curr.argc++;
                continue;
            }

            if (!strcmp(stoken, ">")) {
                /*next word is null or a number*/
                if (!(end = getnextword(s)) || *curr.out) {
                    fprintf(stderr, "out conflict");
                    exit(1);
                }
                strcpy(curr.out, s);
                s = end + 1;
            } else if (!strcmp(stoken, "<")) {
                if (!(end = getnextword(s)) || *curr.in) {
                    fprintf(stderr, "in conflict");
                    exit(1);
                }
                strcpy(curr.in, s);
                s = end + 1;
            } else {

                strcpy(curr.argv[curr.argc++], stoken);
            }
        }

        if (*r) {
            if (*curr.out) {
                fprintf(stderr, "in confligt");
                exit(1);
            }
            sprintf(curr.out, "pipe to stage %d", curr.stage + 1);
        }
        if (!*curr.out) {
            snprintf(&(curr.out), 36, "%s", "original stdout");
        }
        if (!*curr.in) {
            sprintf(&(curr.in), "%s", "original stdin");
        }

        printf("--------\nStage %d: \"%s\"\n--------\n", curr.stage,
            curr.stagec);
        printf("%10s %s\n", "input:", curr.in);
        printf("%10s %s\n", "output:", curr.out);
        printf("%10s %d\n", "argc:", curr.argc);
        printf("%11s", "argv: ");

        for (i = 0; i < curr.argc; i++) {
            printf("\"%s\"", curr.argv[i]);

            if (i < curr.argc - 1)
                printf(", ");
        }
        printf("\n");

        if (curr.argc > MAXARGS) {
            printf("%s: too many arguments", curr.command);
            exit(1);
        }
        if (stage++ > MAXCOMMAND) {
            fprintf(stderr, "pipeline too deep\n");
            exit(1);
        }
        if (!strcmp(curr.stagec, " ")) {
            fprintf(stderr, "invalid null command");
            exit(1);
        }
    }

    return 0;
}

char* getnextword(char* s)
{
    if (!s)
        return NULL;
    while ((*s != ' ' && *s != '\0')) {
        if (*s == '<' || *s == '>' || *s == '|')
            return NULL;
        s++;
    }
    *s = '\0';
    return s;
}
void err()
{
    printf("usage: parseline [ -c ] [ -d ] set1 [ set2 ]\n");
}
