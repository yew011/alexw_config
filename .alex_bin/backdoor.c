#include <arpa/inet.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>

#define DOOR_PORT       5813
#define DOOR_QUEUE_SIZE 3

static void
print_error(const char *error, int errno)
{
    fprintf(stderr, "ERROR: %s (%s)", error, strerror(errno));
}

static int
create_ptcp_socket(void)
{
    struct sockaddr_in sin;
    int sock;

    sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock == -1) {
        print_error("could not open socket", errno);
        goto err;
    }

    memset(&sin, 0, sizeof sin);
    sin.sin_port = htons(DOOR_PORT);
    sin.sin_addr.s_addr = INADDR_ANY;
    sin.sin_family = AF_INET;

    if (bind(sock, (struct sockaddr *)&sin, sizeof sin) == -1) {
        print_error("could not bind socket", errno);
        close(sock);
        goto err;
    }

    if (listen(sock, DOOR_QUEUE_SIZE) == -1) {
        print_error("could not listen on socket", errno);
        close(sock);
        goto err;
    }

    return sock;
err:
    return -1;
}

int
main(void)
{
    int ptcp_sock = create_ptcp_socket();

    fork();

    return 0;
}
