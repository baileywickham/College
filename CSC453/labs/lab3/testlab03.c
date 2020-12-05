/* testlab03.c
 *
 # gcc testlab03.c  # compile
 *
 * ./a.out 'hello kernel' # test
 * Calling mysyscall with: hello kernel
 * mysyscall returned 0
 */

#define _GNU_SOURCE
#include <unistd.h>
#include <sys/syscall.h>
#include <stdio.h>
#include <string.h>

#define SYS_mysyscall 440

int main(int argc, char **argv)
{
    long ret;
    char buf[80];
    if ( argc <= 1 ) {
        printf("mysyscall requires arg1 'string'.\n");
        return -1;
    }
    strcpy(buf, argv[1]);
    printf("Calling mysyscall with: \"%s\"\n", buf);
    ret = syscall(SYS_mysyscall, buf);

    if ( ret ) { // non-zero return value is an error
        printf("Error, mysyscall returned %ld\n", ret);
        return 1;
    }
    printf("mysyscall returned %ld\n", ret);

    return 0;
}
