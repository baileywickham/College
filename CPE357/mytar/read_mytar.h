#include "mytar.h"
#include <stdio.h>

int write_file(BlockHeader*, FILE*, char, char*);
int read_mytar(FILE*, int, char**);
int strict(BlockHeader*);
char* perm(BlockHeader*);
int in_args(int, char**, char*);
