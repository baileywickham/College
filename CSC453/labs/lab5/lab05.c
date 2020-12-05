/* lab05.c
 * Wickham, Bailey
 * Calculates the sum of n, passed in as argv1. Calculates using pthreads,
 * uses a mutex to remain in sync.
 *
 * Example:
 * ./a.out 10
 * ./a.out 1
 * for i in $(seq 1 10); do ./a.out 100; done
 *
 */
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

int sum; // shared variable
pthread_mutex_t lock;

void *runner(void *arg) {
    pthread_mutex_lock(&lock);
    sum = sum + *(int*)arg;
    pthread_mutex_unlock(&lock);
    pthread_exit(NULL);
}

int main(int argc, char **argv)
{
    int n = -1;
    if (argc < 2 || ((n = atoi(argv[1]))) < 0) {
        printf("Error: invalid input\n");
        exit(EXIT_FAILURE);
    }

    if (pthread_mutex_init(&lock, NULL) != 0) {
        printf("\n mutex init has failed\n");
        return 1;
    }
    // std99
    pthread_t t[n];
    int i, a[n];
    sum = 0;

    for (i = 0; i < n; ++i) {
        a[i] = i + 1;
        if ( pthread_create(&t[i], NULL, runner, a+i) ) {
            fprintf(stderr, "Error: pthread_create\n");
            return 1;
        }
    }

    for (i = 0; i < n; ++i)
        pthread_join(t[i], NULL);
    pthread_mutex_destroy(&lock);

    printf("%d\n", sum);

    return 0;
}

