#include <ctype.h>
#include <stdio.h>

char* str_lower(char* str, char buff[])
{
    int i = 0;
    while (str[i]) {
        buff[i] = tolower(str[i]);
        i++;
    }
    buff[i + 1] = '\0';
    return buff;
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
