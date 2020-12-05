/* testlab04.c
 *
 # gcc testlab04.c  # compile
 *
 * ./a.out 'test ABC123xyz' 15 # test
 * Calling mysyscall2      "test ABC123xyz" 15
 * After mysyscall2 buf is "TEST abc123XYZ"
 *
 * Also use dmesg to verify that input 'test ABC123xyz' was received by kernel
 * dmesg | grep mysyscall | tail -2
 * [ 2080.841763] mysyscall2 received: "test ABC123xyz" 15
 * [ 2080.843994] mysyscall2 returned: "TEST abc123XYZ"
 *
 */

#define _GNU_SOURCE
#include <unistd.h>
#include <sys/syscall.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SYS_mysyscall2 441

int main(int argc, char **argv)
{
    long ret, size;
    char buf[80];
    if ( argc <= 2 ) {
        printf("mysyscall2 requires arg1 'string' arg2 long\n");
        return -1;
    }

    strcpy(buf,argv[1]);
    size = atoi(argv[2]);
    printf("Calling mysyscall2      \"%s\" %ld\n", buf, size);
    ret = syscall(SYS_mysyscall2, buf, size);

    if ( ret ) { /* non-zero return value is an error */
        fprintf(stderr, "Error: mysyscall2 returned %ld.\n", ret);
        return 1;
    }
    printf("After mysyscall2 buf is \"%s\"\n", buf);

    return 0;
}
