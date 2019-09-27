#include "log.h"
#include "util.h"

#include <stdarg.h> /* for varargs */

void log(void *log_ctx,
         const char *text)
{
  if (!log_ctx)
    return;

  char *buffer = util_string_compose("PEANUT MSG: %s");
  if (!buffer)
    return;

  PIMoaMmUtils2 pMoaUtils = (PIMoaMmUtils2) log_ctx;
  pMoaUtils->PrintMessage(buffer);
}

void log_message(void *log_ctx,
                 const char *format,
                 ...)
{
  if (!log_ctx)
    return;

  char *buffer = util_string_compose("PEANUT MSG: %s");
  if (!buffer)
    return;

  PIMoaMmUtils2 pMoaUtils = (PIMoaMmUtils2) log_ctx;
  pMoaUtils->PrintMessage(buffer);
}

void log_error_code(void *log_ctx,
                    const char *format,
                    ...)
{
  int error_code = errno;

  char *error_description = util_string_from_error_code(error_code);
  if (error_description) {
    char *buffer = util_string_compose("%s - %s", message, error_description);
    if (buffer) {
      log(log_ctx, buffer);
      free(buffer);
    }
    free(error_description);
  }
  else {
    log(log_ctx, message);
  }
}

