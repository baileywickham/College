/* server.c
 * Wickham, Bailey
 *
 * server.c -- a stream socket server demo
 *
 * Description:
 *  This is a server which returns an index of the current directory or
 *  the contents of a file. The server runs on a ip:port and accepts
 *  connections from 0.0.0.0/0
 * Spec:
 *  Takes a port as argv[1]. Takes either "index" or <filename> on a socket.
 *  Filenames must only include A-z.-, and must not be preceeded with a '.'.
 *  The filename returns
 *  the entire contents of the file. The index returns the files in the
 *  current directory. If the file is not found, the text is printed to a
 *  log file. If the file is found, the request and size is logged to a log
 *  file.
 *
 * Examples:
 *  ./server 8080
 *  ./server 4443
 */

#include <arpa/inet.h>
#include <dirent.h>
#include <errno.h>
#include <libgen.h>
#include <netdb.h>
#include <netinet/in.h>
#include <pthread.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

//#define PORT "4443" // the port users will be connecting to
#define BAD_FILENAME 2
#define NOT_ALLOWED 3
#define INDEX 6
#define EMPTY_REQUEST 7

#define BACKLOG 10 // how many pending connections queue will hold

pthread_mutex_t lock;

void sigchld_handler(int s)
{
    (void)s; // quiet unused variable warning

    // waitpid() might overwrite errno, so we save and restore it:
    int saved_errno = errno;

    while (waitpid(-1, NULL, WNOHANG) > 0)
        ;

    errno = saved_errno;
}

// get sockaddr, IPv4 or IPv6:
void* get_in_addr(struct sockaddr* sa)
{
    if (sa->sa_family == AF_INET) {
        return &(((struct sockaddr_in*)sa)->sin_addr);
    }

    return &(((struct sockaddr_in6*)sa)->sin6_addr);
}

void logstr(char* ip, char* port, char* file, char* errorsize)
{
    char buf[2048];
    time_t rawtime;
    struct tm* timeinfo;
    time(&rawtime);
    timeinfo = localtime(&rawtime);

    char date[22];
    strftime(date, 22, "[%F %X]", timeinfo);
    sprintf(buf, "%s %s:%s %s %s\n", date, ip, port, file, errorsize);

    pthread_mutex_lock(&lock);
    FILE* f = fopen("log", "a");
    fwrite(buf, sizeof(char), strlen(buf), f);
    fflush(f);
    fclose(f);
    pthread_mutex_unlock(&lock);
}

int validatename(char* name, char* servername)
{
    if (name[0] == '\n' && name[1] == '\0') {
        return EMPTY_REQUEST;
    }
    if (name[0] == '.') {
        return BAD_FILENAME;
    }
    if (!strcmp(basename(servername), name)) {
        return NOT_ALLOWED;
    }
    if (!strcmp("index", name)) {
        return INDEX;
    }
    while (*name) {
        if (!((*name >= 65 && *name <= 90) || (*name <= 122 && *name >= 97) || (*name == 95) || (*name == 46))) {
            return BAD_FILENAME;
        }
        name++;
    }
    return 0;
}

char* readfile(char* path, char* ip, char* port, int* size)
{
    struct stat stats;
    if (stat(path, &stats) < 0) {
        // file doesn't exist
        logstr(ip, port, path, "NOT_FOUND");
        return NULL;
    }

    if (!S_ISREG(stats.st_mode)) {
        logstr(ip, port, path, "NOT_FOUND");
        return NULL;
    }

    // File exists, check if we have read access
    if (access(path, R_OK) == -1) {
        logstr(ip, port, path, "NOT_READABLE");
        return NULL;
    }

    char dsize[10];
    sprintf(dsize, "%ld", stats.st_size);
    logstr(ip, port, path, dsize);

    // Here we need to get a new instance of the stats struct to account
    // for the extra line added if we are reading from the log file
    stat(path, &stats);
    FILE* f = fopen(path, "r");
    if (f == NULL) {
        perror(path);
        return NULL;
    }
    char* buf = (char*)calloc(stats.st_size, 1);
    *size = stats.st_size;
    fread(buf, stats.st_size, 1, f);
    return buf;
}

char* readindex(char* ip, char* port)
{
    struct dirent* de;
    DIR* dr = opendir(".");
    char* buf = (char*)calloc(1024, 1);

    if (dr == NULL) {
        perror("Error opening index");
    }
    while ((de = readdir(dr)) != NULL) {
        if (de->d_type == DT_REG) {
            strcat(buf, de->d_name);
            strcat(buf, "\n");
        }
    }
    closedir(dr);
    char dsize[10];
    sprintf(dsize, "%ld", strlen(buf));
    logstr(ip, port, "index", dsize);
    return buf;
}

int main(int argc, char** argv)
{
    int sockfd, new_fd; // listen on sockfd, new connection on new_fd
    struct addrinfo hints, *servinfo, *p;
    struct sockaddr_storage their_addr; // connector's address information
    socklen_t sin_size;
    struct sigaction sa;
    int yes = 1;
    char s[INET6_ADDRSTRLEN];
    int rv;

    if (argc != 2) {
        printf("Usage: server port\n");
        exit(1);
    }

    char* port = argv[1];

    if (pthread_mutex_init(&lock, NULL) != 0) {
        perror("mutex");
        exit(EXIT_FAILURE);
    }

    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_flags = AI_PASSIVE; // use my IP

    if ((rv = getaddrinfo(NULL, port, &hints, &servinfo)) != 0) {
        fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(rv));
        return 1;
    }

    // loop through all the results and bind to the first we can
    for (p = servinfo; p != NULL; p = p->ai_next) {
        if ((sockfd = socket(p->ai_family, p->ai_socktype, p->ai_protocol)) == -1) {
            perror("server: socket");
            continue;
        }

        if (setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(int)) == -1) {
            perror("setsockopt");
            exit(1);
        }

        if (bind(sockfd, p->ai_addr, p->ai_addrlen) == -1) {
            close(sockfd);
            perror("server: bind");
            continue;
        }

        break;
    }

    freeaddrinfo(servinfo); // all done with this structure

    if (p == NULL) {
        fprintf(stderr, "server: failed to bind\n");
        exit(1);
    }

    // listen allows queue of up to BACKLOG number
    if (listen(sockfd, BACKLOG) == -1) {
        perror("listen");
        exit(1);
    }
    FILE* _log = fopen("log", "a");
    fclose(_log);

    sa.sa_handler = sigchld_handler; // reap all dead processes
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = SA_RESTART;
    if (sigaction(SIGCHLD, &sa, NULL) == -1) {
        perror("sigaction");
        exit(1);
    }

    while (1) { // main accept() loop
        sin_size = sizeof their_addr;
        new_fd = accept(sockfd, (struct sockaddr*)&their_addr, &sin_size);
        if (new_fd == -1) {
            perror("accept");
            continue;
        }

        inet_ntop(their_addr.ss_family,
            get_in_addr((struct sockaddr*)&their_addr),
            s, sizeof s);

        if (!fork()) { // this is the child process
            //char buf[1024] = { 0 };
            char* buf = (char*)calloc(1024, 1);
            close(sockfd); // child doesn't need the listener
            int size = 0;

            recv(new_fd, buf, 1023, 0);
            switch (validatename(buf, argv[0])) {
            case NOT_ALLOWED:
                logstr(s, port, buf, "NOT_ALLOWED");
                buf[0] = '\0';
                break;
            case BAD_FILENAME:
                logstr(s, port, buf, "BAD_FILENAME");
                buf[0] = '\0';
                break;
            case EMPTY_REQUEST:
                // Overwrite newline
                buf[0] = '\0';
                logstr(s, port, buf, "\0");
                break;
            case INDEX:
                buf = readindex(s, port);
                // we can assume files will all be printable
                // characters
                size = strlen(buf);
                break;
            case 0:
                // Good filename
                // size needs to be read from the file
                buf = readfile(buf, s, port, &size);
                break;
            }

            if (send(new_fd, buf, size, 0) == -1)
                perror("send");
            free(buf);
            close(new_fd);
            exit(0);
        }
        close(new_fd); // parent doesn't need this
    }

    return 0;
}
