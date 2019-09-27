#ifndef PEANUT_LOG_H
#define PEANUT_LOG_H

#include <stdarg.h>

typedef void (*log_func_t)(const char *message, void *data);
typedef struct {
	log_func_t func;
	void *data;
} log_ctx_t;

void log_message_simple(log_ctx_t *log,
                        const char *message);

void log_message(log_ctx_t *log,
                 const char *format, ...);

void log_message_with_error_code(log_ctx_t *log_ctx,
                                 const char *format, ...);

#endif

