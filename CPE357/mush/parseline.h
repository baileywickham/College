#define MAXLINE 512
#define MAXCOMMAND 10

#define MAXARGS 10
#define ARGLEN 36

typedef struct {
    char command[ARGLEN];
    int argc;
    char argv[MAXARGS][ARGLEN];
    char in[ARGLEN];
    char out[ARGLEN];
    int stage;
    char stagec[ARGLEN];
} cmd;