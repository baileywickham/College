/**
 * CSC 225, Assignment 6
 */

#include "stack.h"
#include <stdio.h>

/**
 * Pushes a value onto a stack of integers.
 * stack - The array containing the stack
 * size - A pointer to the number of elements in the stack
 * val - The value to push
 *
 * Returns 0 on success, 1 on overflow.
 */
int push(int stack[], int* size, int val)
{
    /* TODO: Complete this function. */
    if (*size + 1 > MAX_SIZE) {
        return 1;
    }
    stack[(*size)++] = val;
    return 0;
}

/**
 * Pops a value off of a stack of integers.
 * stack - The array containing the stack
 * size - A pointer to the number of elements in the stack
 * val - A pointer to the variable in which to place the popped value
 *
 * Returns 0 on success, 1 on underflow.
 */
int pop(int stack[], int* size, int* val)
{
    if (*size == 0) {
        return 1;
    }
    (*size)--;
    *val = stack[*size];
    return 0;
}

/**
 * Prints a stack of integers.
 * stack - The array containing the stack
 * size - The number of elements in the stack
 * mode - How to print elements, one of: DEC_MODE, HEX_MODE, or CHAR_MODE
 */
void printStack(int stack[], int size, int mode)
{
    /* TODO: Complete this function. */
    int i;
    printf("[");
    for (i = 0; i < size; i++) {
        switch (mode) {
        case DEC_MODE:
            printf("%d", stack[i]);
            break;
        case HEX_MODE:
            printf("0x%X", stack[i]);
            break;
        case CHAR_MODE:
            printf("'%c'", stack[i]);
            break;
        }
        if (i < size - 1) {
            printf(", ");
        }
    }
    printf("]\n");
}
