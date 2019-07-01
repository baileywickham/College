#include "checkit.h"
#include "mytr.h"

void test_parse();
void test_parse1();

int main()
{
    test_parse();
    return 0;
}

void test_parse()
{
    test_parse1();
}
void test_parse1()
{
    char* str1 = "abcdef";
    int buff[6];
    int size;
    size = parse(str1, buff);
    checkit_int(size, 6);
}
