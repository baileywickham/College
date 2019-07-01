#include <stdio.h>

#include "checkit.h"
#include "part4.h"

void test_calc_1()
{
    char* str = "Hello";
    char buff[6];
    checkit_string(str_lower(str, buff), "hello");
}
void test_calc_2()
{
    char str[] = "Hello";
    checkit_string(str_lower_mutate(str), "hello");
}

void test_calc()
{
    test_calc_1();
    test_calc_2();
}

int main(void)
{
    test_calc();
    return 0;
}
