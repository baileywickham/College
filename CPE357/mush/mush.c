#include "parseline.h"
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <sys/stat.h>
#include <fcntl.h>


int parseline(char*);
char* getnextword(char*);
void err();
void hangup(int);
void overlay(int);

pid_t pid;
volatile int inter = 0;

int main(int argc, char** argv)
{
    while (1) {
        signal(SIGINT, overlay);
        signal(SIGHUP, hangup);

        char line[MAXLINE]; /*512*/
        printf("mush> ");
        fflush(stdout);
/*        if (!inter) {
            printf("mush> ");
            fflush(stdout);
        } else {
            inter = 0;
        }*/

        if (!fgets(line, MAXLINE, stdin)) exit(0);

        if (strlen(line) == MAXLINE) {
            fprintf(stderr, "command too long");
            err();
            exit(1);
        }
        line[strlen(line) - 1] = '\0';

        parseline(line);

    }

}


int parseline(char* line)
{
    char* token;
    char* r = line;
    int stage = 0, i;
    cmd pipeline[10];

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
            sprintf(curr.in, "pipe from stage %d", curr.stage-1);
        }

        while ((stoken = strtok_r(s, " ", &s))) {
            if (!(curr.command[0])) {
                strcpy(curr.command, stoken);
                sprintf(curr.argv[0], "%s", stoken);
                curr.argc++;
                continue;
            }

            if (!strcmp(stoken, ">")) {
                /*next word is null or a number*/
                if (!(end = getnextword(s)) ||  *curr.out) {
                    fprintf(stderr, "out conflict");
                    return 1;
                }
                strcpy(curr.out, s);
                s = end + 1;
            } else if (!strcmp(stoken, "<")) {
                if (!(end = getnextword(s)) ||  *curr.in) {
                    fprintf(stderr, "in conflict");
                    return 1;
                }
                strcpy(curr.in, s);
                s = end + 1;
            } else {
                strcpy(curr.argv[curr.argc++], stoken);
            }
        }

        if (*r) {
            if (*curr.out) {
                fprintf(stderr, "in conflig\nt");
                return (1);
            }
            sprintf(curr.out, "pipe to stage %d", curr.stage + 1);
        }
        if (!*curr.out) {
            sprintf(&(curr.out), "%s", "stdout");
        }
        if (!*curr.in) {
            sprintf(&(curr.in), "%s", "stdin");
        }



        if (curr.argc > MAXARGS) {
            printf("%s: too many arguments", curr.command);
            return (1);
        }
        if (stage > MAXCOMMAND) {
            fprintf(stderr, "pipeline too deep\n");
            return (1);
        }
        if (!strcmp(curr.stagec, " ")) {
            fprintf(stderr, "invalid null command");
            exit(1);
        }
        pipeline[stage++] = curr;

    }

    int inpipe[2] = {0};
    int outpipe[2] = {0};

    pipe(inpipe);

    for (i = 0; i < stage; i++) {
        int o, f, j;
        cmd curr = pipeline[i];
        if (!strcmp(curr.command, "cd")) {
            if (chdir(curr.argv[1]) < 0) perror("");
            return 0;
        }

        if (!strcmp(curr.command, "exit")) exit(0);

        pipe(outpipe);

        if ((pid = fork()) == 0) {
            /*forked my dude*/
            char* list[10];
            for (j = 0; j < curr.argc; j++) {
                list[j] = &(curr.argv[j]);
            }
            list[j] = NULL;

            if (strcmp(curr.out, "stdout")) {
                if (!strncmp(curr.out, "pipe to stage", 13)) {
                    if (i == 0) {
                        dup2(outpipe[1], STDOUT_FILENO);
                    } else if (i == stage-1){
                        dup2(inpipe[0], STDIN_FILENO);
                    } else {
                        dup2(inpipe[0], STDIN_FILENO);
                        dup2(outpipe[1], STDOUT_FILENO);
                    }
                } else {
                    f = open(curr.out, O_WRONLY | O_CREAT,
                            S_IRUSR | S_IWUSR);
                    dup2(f, STDOUT_FILENO);
                    close(f);
                }
            }

            if (strcmp(curr.in, "stdin")) {
                if (!strncmp(curr.in, "pipe from stage", 4)) {
                    if (i == 0) {
                        dup2(outpipe[1], STDOUT_FILENO);
                    } else if (i == stage-1) {
                        dup2(inpipe[0], STDIN_FILENO);
                    } else {
                        dup2(inpipe[0], STDIN_FILENO);
                        dup2(outpipe[1], STDOUT_FILENO);
                    }
                } else {
                    o = open(curr.in, O_RDONLY);
                    dup2(o, STDIN_FILENO);
                    close(o);
                }
            }
            close(inpipe[0]);
            close(inpipe[1]);
            close(outpipe[0]);
            close(outpipe[1]);

            if (execvp(curr.argv[0], list) < 0) {
                perror("");
                return 1;
            }
        } else {
            wait(NULL);
            close(inpipe[0]);
            close(inpipe[1]);
            close(outpipe[1]);
            dup2(outpipe[0], inpipe[0]);
            close(outpipe[0]);
        }
    }
    return 0;
}



char* getnextword(char* s){
    if (!s) return NULL;
    while ((*s != ' ' && *s != '\0')) {
        if (*s == '<' || *s == '>' || *s == '|')
            return NULL;
        s++;
    }
    *s = '\0';
    return s;

}
void err(){
    printf("usage: parseline [ -c ] [ -d ] set1 [ set2 ]\n");
}

void hangup(int i) {
    kill(0, SIGTERM);
    exit(0);
}

void overlay(int i) {
    printf("\nmush> ");
    fflush(stdout);
    if (pid) kill(pid,1);
    inter = 1;
}