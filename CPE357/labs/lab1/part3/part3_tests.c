#include <stdio.h>

#include "checkit.h"
#include "part3.h"

void test_calc_1()
{
    int arr[1];
    checkit_int(sum(arr, 0), 0);
}
void test_calc_2()
{
    int arr[] = { 1, 2, 3 };
    checkit_int(sum(arr, 3), 6);
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
