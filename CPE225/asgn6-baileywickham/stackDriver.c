#include "stack.h"
#include <stdio.h>

int main()
{
    int ret = 0;
    int stack[MAX_SIZE];
    char input = 0;
    int mode = 0;
    int newNumber, size = 0;
    printf("Welcome to the stack program.\n\n");
    for (;;) {
        printf("Enter option: ");
        scanf(" %c", &input);
        switch (input) {
        case 'd':
            mode = 0;
            break;
        case 'x':
            mode = 1;
            break;
        case 'c':
            mode = 2;
            break;
        case 'q':
            printf("Goodbye!\n");
            return 0;
            break;
        case '+':
            printf("What number? ");
            scanf("%d", &newNumber);
            ret = push(stack, &size, newNumber);
            if (ret == 1) {
                printf("Error: Stack overflow!\n");
            }
            break;
        case '-':
            ret = pop(stack, &size, &newNumber);
            if (ret == 0) {
                printf("Popped %d.\n", newNumber);
            } else {
                printf("Error: Stack underflow!\n");
            }
            break;
        }
        printf("Stack: ");
        printStack(stack, size, mode);
        printf("\n");
    }
}
