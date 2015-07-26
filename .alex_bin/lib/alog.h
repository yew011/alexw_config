#ifndef ALOG
#define ALOG_H 1

void alog_init(const char *pname);
void alog_log(const char *level, ...);

#define ALOG_DBG(...)  alog_log("dbg", __VA_ARGS__)
#define ALOG_INFO(...) alog_log("info", __VA_ARGS__)
#define ALOG_WARN(...) alog_log("warn", __VA_ARGS__)
#define ALOG_ERR(...)  alog_log("err", __VA_ARGS__)

#endif  /* alog.h */
