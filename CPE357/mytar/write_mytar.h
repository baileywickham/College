#include "mytar.h"
#include <sys/stat.h>
#include <stdio.h>

int add_entry(struct stat, char*, FILE*);
int parse_dir(char*, FILE*);
