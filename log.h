#ifndef PEANUT_LOG_H
#define PEANUT_LOG_H

#include <stdarg.h>

typedef enum {
	LOG_LEVEL_DEBUG = 0,
	LOG_LEVEL_INFO,
	LOG_LEVEL_ERROR,
	LOG_LEVEL_NONE
} log_level_t;

/* signature of logger callback */
typedef void (*log_func_t)(const char *message, void *data);

typedef struct {
	log_level_t  level;
	log_func_t   func;
	void        *data;
} log_ctx_t;

void log_message_simple(log_ctx_t *log,
                        log_level_t level,
                        const char *message);

void log_message(log_ctx_t *log,
                 log_level_t level,
                 const char *format,
                 ...);

void log_message_with_error_code(log_ctx_t *log_ctx,
                                 log_level_t level,
                                 const char *format,
                                 ...);

#endif

