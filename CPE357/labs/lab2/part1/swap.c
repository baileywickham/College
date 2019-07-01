#include <stdio.h>

void swap(int* a, int* b)
{
    int* temp = a;
    a = b;
    b = temp;
}

int main()
{
    int i = 1;
    int j = 2;
    swap(&i, &j);
    printf("%d %d\n", i, j);
}
