/* lab06.c
 * Wickham, Bailey
 *
 * Uses a semaphore and a ring buffer to calculate the sum of a set
 * the ring buffer can be smaller than the data structure we used in the
 * previous lab.
 *
 * gcc lab06.c -lpthread
 *
 */

#include <pthread.h>
#include <semaphore.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

void* producer(void* arg);
void* consumer(void* arg);

sem_t NUM; // number in use
sem_t MAX; // max size of bounded buffer semaphore
int* buf;  // buffer size 1, NOTE: you will need to change this to a int *buf;
int sum = 0;

int n = 0, size = 0;
// Note you may add additional global variables if needed

int main(int argc, char** argv)
{
    if (argc < 3) {
        printf("Error need 2 ints, datsize bufsize\n");
        exit(EXIT_FAILURE);
    }
    if ((n = atoi(argv[1])) <= 0 || (size = atoi(argv[2])) <= 0) {
        printf("Error datsize, bufsize must be ints\n");
        exit(EXIT_FAILURE);
    }
    buf = (int*)calloc(size, sizeof(int));
    pthread_t p, c;

    sem_init(&NUM, 0, 0);    // start with number in use NUM 0
    sem_init(&MAX, 0, size); // start with max size 1, you will need
                             // to increase this to the buffer size

    pthread_create(&p, NULL, producer, NULL);
    pthread_create(&c, NULL, consumer, NULL);

    pthread_join(p, NULL);
    pthread_join(c, NULL);

    sem_destroy(&MAX);
    sem_destroy(&NUM);

    printf("%d\n", sum);

    return 0;
}

void* producer(void* arg)
{
    for (int i = 1; i <= n; i++) {
        sem_wait(&MAX); // decrement MAX size
        // store 1...n, not 0...n-1
        buf[(i-1) % size] = i;
        sem_post(&NUM); // increment NUM in use
    }
    pthread_exit(0);
}

void* consumer(void* arg)
{
    char output[32];
    for (int i = 0; i < n; i++) {
        sem_wait(&NUM); // decrement NUM in use
        sum += buf[i % size];
        sprintf(output, "buf[%d] %d\n", i % size, buf[i % size]);
        write(1, output, strlen(output));
        sem_post(&MAX); // increment MAX size
    }
    pthread_exit(0);
}
