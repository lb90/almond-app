#include "log.h"
#include "util.h"

#include <stdlib.h>
#include <errno.h> /* for log_message_with_error_code */

static
void do_log(log_ctx_t *log,
            const char *message)
{
  if (!log || !(log->func))
    return;

  (log->func)(message, log->data);
}

void log_message_simple(log_ctx_t *log,
                        log_level_t level,
                        const char *message)
{
  if (log->level > level)
    return;

  do_log(log, message);
}

void log_message(log_ctx_t *log,
                 log_level_t level,
                 const char *format, ...)
{
  char *message = NULL;
  va_list ap;
  va_start(ap, format);

  if (log->level > level)
    goto cleanup;

  message = util_string_compose_va(format, ap);
  if (!message)
    goto cleanup;

  do_log(log, message);

cleanup:
  free(message);
  va_end(ap);
}

void log_message_with_error_code(log_ctx_t *log,
                                 log_level_t level,
                                 const char *format, ...)
{
  int code = errno;
  char *message = NULL;
  char *description = NULL;
  char *complete = NULL;
  va_list ap;
  va_start(ap, format);

  if (log->level > level)
    goto cleanup;

  message = util_string_compose_va(format, ap);
  if (!message)
    goto cleanup;

  description = util_string_from_error_code(code);
  if (!description)
    goto cleanup;
  
  complete = util_string_compose("%s - %s", message, description);
  if (!complete)
    goto cleanup;

  do_log(log, complete);

cleanup:
  free(complete);
  free(description);
  free(message);

  va_end(ap);
}

