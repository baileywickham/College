/* myshell.c
 * Wickham, Bailey
 * A small shell program. This program takes input, attempts to run it,
 * then returns to the shell.
 * The shell also allows IPC through |.
 * Examples:
 * $ ls
 * $ ls -ltr / | grep "abc"
 */
#include <ctype.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <limits.h>

#define PROMPT "myshell"
#define PIPE 1
#define MAXLINE 1024
#define MAXSTAGE 4

#define PREAD 0
#define PWRITE 1

#define MAXARGS 10
#define ARGLEN 36
#define lstrip(line) while (*line == ' ' || *(line) == '\t') line++;
#define fdclose(fd) if (fd != STDIN_FILENO && fd != STDOUT_FILENO) close(fd);

typedef struct {
    int argc;
    char** argv;
    int in;
    int out;
    int stage;
} CMD;

void parseline(char*);
void hangup(int);
void overlay(int);
void runpipeline(CMD[], int);
void printprompt();
void freeargv(int, char**);
char** parseargs(char*, int*);

// just in case
pid_t pid;

int main(int argc, char** argv) {
    while (1) {
        char* end = 0;
        printprompt();

        char _line[MAXLINE] = { 0 };
        char* line = _line;

        if (!fgets(_line, MAXLINE, stdin)) {
            exit(EXIT_SUCCESS);
        }
        if (strlen(_line) == MAXLINE) {
            fprintf(stderr, "command too long");
            exit(EXIT_FAILURE);
        }

        // rstrip
        end = line + strlen(line)-1;
        while (end >= line && isspace(*end))
            end--;
        *(end + 1) = '\0';
        //lstrip
        lstrip(line);

        if (!line) {
            continue;
        }

        parseline(line);
    }
}

void printprompt() {
    char wd[PATH_MAX];
    if (getcwd(wd, PATH_MAX)) {
        printf("%s $ ", wd);
        fflush(stdout);
    }
}

void parseline(char* line) {
    char* token;
    char* r = line;
    int stage = 0;
    CMD pipeline[MAXSTAGE];

    while ((token = strtok_r(r, "|", &r))) {
        char* end = 0;
        CMD curr = { 0 };
        curr.stage = stage;
        curr.argv = calloc(MAXARGS, sizeof(char));

        if (stage > 0) {
            // We are taking input from a pipe
            curr.in = PIPE;
        }
        // rstrip
        end = token + strlen(token)-1;
        while (end >= token && isspace(*end))
            end--;
        *(end + 1) = '\0';

        lstrip(token);

        curr.argv = parseargs(token, &(curr.argc));

        if (*r) {
            // there is another pipe, so we should send the out to a pipe
            curr.out = PIPE;
        }

        if (curr.argc > MAXARGS) {
            printf("%s: too many arguments", curr.argv[0]);
            return;
        }
        if (stage > MAXSTAGE) {
            fprintf(stderr, "pipeline too deep\n");
            return;
        }
        pipeline[stage++] = curr;
    }

    runpipeline(pipeline, stage);

    for (int i=0; i<stage; i++){
        freeargv(pipeline[i].argc, pipeline[i].argv);
    }
}

void runpipeline(CMD pipeline[MAXSTAGE], int stage) {
    int outpipe[2] = { 0 };
    int in, out, last=STDIN_FILENO;
    for (int i = 0; i < stage; i++) {
        CMD curr = pipeline[i];
        if (!strcmp(curr.argv[0], "cd")) {
            if (chdir(curr.argv[1]) < 0)
                perror("");
            return;
        } else if (!strcmp(curr.argv[0], "exit")) {
            exit(EXIT_SUCCESS);
        }
        // set in to be the prev pipe, or stdin
        in = last;
        if (i==0) {
            in = STDIN_FILENO;
            out = STDOUT_FILENO;
        }
        if (i < stage-1) {
            // we are in the middle of the pipe
            pipe(outpipe);
            last = outpipe[PREAD];
            out = outpipe[PWRITE];
        }
        if (i==stage-1) {
            // final stage
            in = outpipe[PREAD];
            out = STDOUT_FILENO;
        }

        // Start pipeline
        if ((pid = fork()) == 0) {
            // In child
            dup2(in, STDIN_FILENO);
            dup2(out, STDOUT_FILENO);

            fdclose(in);
            fdclose(out);
            if (execvp(curr.argv[0], curr.argv) < 0) {
                perror(curr.argv[0]);
                exit(EXIT_FAILURE);
            }
        } else {
            //in parent
            fdclose(in);
            fdclose(out);
            while ((wait(NULL))>0);
        }
    }
}

char** parseargs(char* token, int* argc) {
    int quoted = 0;
    *argc = 0;
    char** argv = (char**)calloc(strlen(token), sizeof(char*));

    char* curr = (char*)calloc(strlen(token), sizeof(char));
    for (int i=0; i < strlen(token) +1; i++) {
        if (token[i] == '"') {
            if (quoted) {
                argv[(*argc)++] = curr;
            } else {
                quoted = 1;
            }
        } else if (token[i] == ' ' || token[i] == '\0') {
            if (!quoted) {
                argv[(*argc)++] = curr;
                curr = (char*)calloc(strlen(token), sizeof(char));
                continue;
            }
        }
        if (token[i] != '"'){
            strncat(curr, &token[i], 1);
        }
    }
    return argv;
}

void freeargv(int argc, char** argv) {
    for (int i = 0; i < argc; i++){
        if (argv[i]) {
            free(argv[i]);
        }
    }
    free(argv);
}
