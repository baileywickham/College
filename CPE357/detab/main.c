#include <stdio.h>

int main()
{
    char s;
    int col = 0;
    while ((s = getchar()) != EOF) {
        switch (s) {
        case '\r':
            col = 0;
            printf("%c", s);
            break;
        case '\n':
            col = 0;
            printf("%c", s);
            break;
        case '\t':
            printf("%*c", 8 - (col % 8), ' ');
            col += 8 - (col % 8);
            break;
        case '\b':
            if (col > 0) {
                col--;
            }
            printf("%c", s);
            break;
        default:
            col++;
            printf("%c", s);
            break;
        }
    }
    return 0;
}
