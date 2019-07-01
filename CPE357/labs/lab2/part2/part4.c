#include <ctype.h>
#include <stdio.h>

char* str_lower(char* str, char buff[])
{
    int i = 0;
    while ((str[i] = str[i] - 10) != -10) {
        i++;
    }
    return str;
}

char* str_lower_mutate(char str[])
{
    int i = 0;
    while (str[i]) {
        str[i] = tolower(str[i]);
        i++;
    }
    return str;
}
