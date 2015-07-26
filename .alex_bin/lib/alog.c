#include <assert.h>
#include <errno.h>
#include <inttypes.h>
#include <pthread.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "alog.h"

/* XXX: only applicable to single-thread, single-process program, or one
 * process in multi-process program. */

static FILE *alog_fd;
static uint64_t line_cnt;
static const char *file_name;

/* Opens the log file, can only be called while single-threaded. */
void
alog_init(const char *pname)
{
    static bool init = false;
    time_t rawtime;
    struct tm *tm;
    int error;

    if (init) {
        return;
    }

    assert(asprintf(&file_name, "/tmp/%s.log", pname));
    alog_fd = fopen(file_name, "a");
    if (!alog_fd) {
        error = errno;
        fprintf(stderr, "Cannot open log file %s (%s)", pname,
                strerror(error));
        exit(error);
    }
    init = true;
    ALOG_INFO("opened log file (/tmp/%s.log)", pname);
}

void
alog_log(const char *level, ...)
{
    const char *format;
    char *content;
    char prefix[255] = {'\0'};
    time_t rawtime;
    struct tm *tm;
    va_list a_list;

    va_start(a_list, level);
    format = va_arg(a_list, const char *);
    assert(vasprintf(&content, format, a_list));
    va_end(a_list);

    time(&rawtime);
    tm = localtime(&rawtime);
    if (tm) {
        strftime(prefix, sizeof prefix, "%FT%T", tm);
    }
    fprintf(alog_fd, "%s|%06"PRIu64"|%s|%s\n", prefix, line_cnt, level,
            content);
    free(content);
}
