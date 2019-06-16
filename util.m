#import "util.h"

#include <stdlib.h>
#include <string.h>

char *util_string_copy(const char *src) {
  char *dst = NULL;
  size_t len;

  len = strlen(src);
  dst = (char*) malloc(len + 1);
  if (!dst)
    {
      ALMOND_NOTE(("Cannot allocate memory for string copy operation.\n"));
      return NULL;
    }
  memset(dst, 0, len + 1);
  strncpy(dst, src, len + 1);
  dst[len] = '\0';

  return dst;
}

