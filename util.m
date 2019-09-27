#import "util.h"

#include <stdlib.h>
#include <stdarg.h> /* for varargs */
#include <string.h>

char *util_string_copy(const char *src)
{
  char *dst = NULL;
  size_t len;

  if (src == NULL)
    return NULL;

  len = strlen(src);
  dst = (char*) malloc(len + 1);
  if (!dst)
    {
      /*log("Cannot allocate memory for string copy operation.\n")*/;
      return NULL;
    }
  memset(dst, 0, len + 1);
  strncpy(dst, src, len + 1);
  dst[len] = '\0';

  return dst;
}

char *util_string_compose(const char *format_string, ...)
{
  va_list args;
  va_start(args, format_string);

  int ret = vsnprintf(NULL, 0, format_string, args);
  if (ret < 0)
    return NULL;
  size_t length = ((size_t)ret) + 1;
  char *buffer = malloc(length);
  if (!buffer)
    return NULL;
  memset(buffer, 0, length);

  int ret = vsnprintf(buffer, length, format_string, args);
  if (ret < 0) {
    free(buffer);
    return NULL;
  }
  /* buffer is NULL terminated */

  va_end(args);

  return buffer;
}

char *util_string_from_error_code(int error_code) {
  const size_t length = 1024;  /*TODO*/
  char *buffer = malloc(length);
  if (!buffer)
    return NULL;
  memset(buffer, 0, length);

  if (strerror_r(error_code, buffer, length) < 0) {
    free(buffer);
    return NULL;
  }
  /* buffer is NULL terminated */

  if (strlen(buffer) == 0) {
    free(buffer);
    return NULL;
  }
}

