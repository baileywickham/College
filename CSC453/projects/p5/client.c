/* client.c
 * Wickham, Bailey
 * client.c -- a stream socket client demo
 * Description:
 *  This client sends a optional <finename> or "index" to a server running on a socket.
 *  This client prints the response from the server to the terminal.
 * Spec:
 *  Takes an ip;port and sends argv[2] to the server. argv[2] is a filename
 *  or a "index". The client prints the data to the terminal, validation is
 *  done on the server.
 * Examples:
 *  ./client localhost:8080 log
 *  ./client localhost:4443
 *  ./client 192.168.1.73:4443 not_a_file
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <netdb.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <sys/socket.h>

#include <arpa/inet.h>


// get sockaddr, IPv4 or IPv6:
void *get_in_addr(struct sockaddr *sa)
{
    if ( sa->sa_family == AF_INET ) {
        return &(((struct sockaddr_in*)sa)->sin_addr);
    }

    return &(((struct sockaddr_in6*)sa)->sin6_addr);
}

int main(int argc, char **argv)
{
    int sockfd, numbytes;
    char buf[BUFSIZ];
    struct addrinfo hints, *servinfo, *p;
    int rv;
    char s[INET6_ADDRSTRLEN];
    char ip_addr[40], port[8];

    if ( argc != 2 && argc != 3 ) {
        printf("Usage: client ipaddr:port [filename]\n");
        exit(1);
    }

    sscanf(argv[1], "%40[^:]:%s", ip_addr, port);

    memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;

    if ((rv = getaddrinfo(ip_addr, port, &hints, &servinfo)) != 0 ) {
        fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(rv));
        return 1;
    }

    // loop through all the results and connect to the first we can
    for(p = servinfo; p != NULL; p = p->ai_next) {
        if ( (sockfd = socket(p->ai_family,
                          p->ai_socktype,
                          p->ai_protocol)) == -1 ) {
            perror("client: socket");
            continue;
        }

        if ( connect(sockfd, p->ai_addr, p->ai_addrlen) == -1 ) {
            perror("client: connect");
            close(sockfd);
            continue;
        }

        break;
    }

    if ( p == NULL ) {
        fprintf(stderr, "client: failed to connect\n");
        return 2;
    }

    inet_ntop(p->ai_family, get_in_addr((struct sockaddr *)p->ai_addr),
        s, sizeof s);

    freeaddrinfo(servinfo); // all done with this structure

    if (argc == 3) {
        strcpy(buf, argv[2]);
    } else {
        buf[0] = '\n';
        buf[1] = '\0';
    }

    send(sockfd, buf, strlen(buf), 0);

    numbytes = recv(sockfd, buf, sizeof(buf)-1, 0);
    while (numbytes) {
        if (numbytes == -1) {
            perror("recv");
            exit(1);
        }
        write(1, buf, numbytes);
        numbytes = recv(sockfd, buf, sizeof(buf)-1, 0);
    }
    close(sockfd);

    return 0;
}
