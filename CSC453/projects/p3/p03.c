/* p03.c
 * Wickham, Bailey
 * Description:
 * p03 creates a round robin scheduler. This starts multiple processes and
 * lets the run for a set of time called the "quanta". After a quanta, the
 * process is paused and the next process is ran.
 *
 * The quanta is in miliseconds.
 *
 * Use
 * ./p03 quantum [cmda 1 [args] [: cmdb 2 [args] [: cmdc [args] [: … ]]]]
 *
 * Examples:
 * ./p03 500 ./two 1 : ./two 2 : ./two 3
 * ./p03 10000 ps aux : ls : cat /proc/sys/fs/epoll/max_user_watches
 *
 *
 *
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <signal.h>
#include <unistd.h>
#include<sys/wait.h>
#include <stdio.h>
#include <errno.h>
#include <stdlib.h>

#define head(tail) (tail->next)
#define STATE_STARTED 1
#define STATE_STOPPED 2
#define STATE_SUSPENDED 3

typedef struct Proc {
    pid_t pid;
    char* process[4];
    int state;
    int index; // A unique id which represents the loctation in the list
} Proc;


typedef struct Node {
    struct Node* next;
    struct Proc* proc;
} Node;

void _clist_free_node(Node*);
Node* clist_remove(Node*);
Node* clist_add(Node*, Proc*);

void rr(Node*, int);

void print_proc(Proc*);
void clist_print(Node*);
void start_timer(int);
void handle_alarm(int);
void start_proc(Proc*);
void start_or_resume();


void help() {
    printf("p03 <quanta> <program> : ...\n");
}

int main(int argc, char** argv) {
    Node* tail = NULL;
    int i = 2;
    int nproc = 0;
    if (argc < 3){
        help();
        exit(EXIT_FAILURE);
    }

    int quanta = atoi(argv[1]);
    if (!quanta) {
        printf("Quanta error\n");
        exit(EXIT_FAILURE);
    }


    int offset = 0;
    while (i+offset<argc) {
        Proc* curr = (struct Proc*)malloc(sizeof(Proc));
        while (i+offset < argc && strcmp(argv[i+offset], ":")) {
            curr->process[offset] = argv[i+offset];
            offset++;
        }
        curr->process[offset+1] = NULL;
        curr->index = nproc++;
        curr->state = 0;
        tail = clist_add(tail, curr);
        i = offset + i + 1;
        offset = 0;
    }
    rr(head(tail), quanta);
}

Node* clist_add(Node* tail, Proc* proc) {
    Node* new = (struct Node*)malloc(sizeof(Node));
    new->proc = proc;
    if (!tail){
        // List starts empty
        new->next = new;
    } else {
        new->next = tail->next;
        tail->next = new;
    }
    return new;
}

void _clist_free_node(Node* freed) {
    // For internal use only. mem free a node
    free(freed->proc);
    free(freed);
}

void clist_print(Node* head) {
    Node* curr = head;
    do  {
        print_proc(curr->proc);
        curr = curr->next;
    } while (curr != head);
}

Node* clist_remove(Node* remove) {
    // O(n) remoProgram:val is fine at this scale
    // Infinite loop on not in list
    if (remove->next == remove) {
        _clist_free_node(remove);
        return NULL;
    } else {
        Node* curr = remove;
        while (curr->next != remove)
            curr = curr->next;
        curr->next = remove->next;

        _clist_free_node(remove);
        return curr->next;
    }
}

void print_proc(Proc* proc) {
    int i = 0;
    printf("Index: %d\nProgram: ",proc->index);
    while (proc->process[i])
        printf("%s ", proc->process[i++]);
    printf("\n");
}

Node* running = NULL;

void rr(Node* head, int quanta) {
    int status;
    signal(SIGALRM, handle_alarm);
    running = head;
    while (running) {
        start_timer(quanta);

        start_or_resume();
        waitpid(running->proc->pid, &status, WUNTRACED);
        if (WIFSTOPPED(status) || errno == EINTR) {
            running = running->next;
        } else {
            //printf("Exit with status: %d\n", WEXITSTATUS(status));
            running = clist_remove(running);
        }
    }
}

void start_or_resume() {
    if (!running->proc->state){
        start_proc(running->proc);
    } else if (running->proc->state == STATE_STOPPED) {
        kill(running->proc->pid, SIGCONT);
    }
}

void start_proc(Proc* p){
    pid_t pid = fork();
    if (pid < 0) {
        perror("failed to fork daemon");
        exit(EXIT_FAILURE);
    }
    if (pid > 0) {
        // Parent
        running->proc->pid = pid;
        running->proc->state = STATE_STARTED;
    } else  {
        if(execvp(p->process[0], p->process) < 0)
           exit(EXIT_FAILURE);
    }
}

void handle_alarm(int sig) {
    kill(running->proc->pid, SIGSTOP);
    running->proc->state = STATE_STOPPED;
}

void start_timer(int quanta) {
    struct itimerval old, new;
    new.it_interval.tv_usec = 0;
    new.it_interval.tv_sec = 0;
    new.it_value.tv_sec = quanta / 1000;
    new.it_value.tv_usec = (quanta % 1000) * 1000;
    if (setitimer(ITIMER_REAL, &new, &old) < 0) {
        perror("");
        exit(EXIT_FAILURE);
    }
}
