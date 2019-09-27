#include <stdlib.h>
#include <string.h>

#import "mangler.h"
#import "util.h"

static
int string_is_ascii(const char *text);
static
char* transform(const char *src);

char* mangle(const char *text) {
  if (!text)
    return NULL;

  if (!string_is_ascii(text))
    {
      ALMOND_NOTE(("Error: string is outside ASCII character set.\n"));
      return NULL;
    }

  return transform(text);
}

static
int string_is_ascii(const char *text) {
  if (!text)
    return 1;

  const unsigned char *iter = (const unsigned char*) text;
  for (; *iter != 0; iter++)
    if (*iter > 127)
      return 0;

  return 1;
}

static
char* transform(const char *src) {
  if (!src)
    return NULL;

  size_t length = strlen(src) + 1;
  char *dst = (char*) malloc(length);
  if (!dst)
    {
      ALMOND_NOTE(("Cannot allocate memory for string mangling operation.\n"));
      return NULL;
    }
  memset(dst, 0, length);

  const unsigned char *src_iter = (const unsigned char*) src;
  unsigned char *dst_iter = (unsigned char*) dst;
  for (; *src_iter != 0; src_iter++)
    {
      unsigned char val = *src_iter;
      if ( (val >= 48 && val <= 57) ) /* 0-9 */
        *dst_iter++ = val;
      else if ( (val >= 65 && val <= 73) ) /* A-I */
        *dst_iter++ = val - 64 + 48;
      else if ( (val >= 74 && val <= 82) ) /* J-R */
        *dst_iter++ = val - 64 - 9 + 48;
      else if ( (val >= 83 && val <= 90) ) /* S-Z */
        *dst_iter++ = val - 64 - 9 - 9 + 48;
      else if ( (val >= 97 && val <= 105) ) /* a-i */
        *dst_iter++ = val - 96 + 48;
      else if ( (val >= 106 && val <= 114) ) /* j-r */
        *dst_iter++ = val - 96 - 9 + 48;
      else if ( (val >= 115 && val <= 122) ) /* s-z */
        *dst_iter++ = val - 96 - 9 - 9 + 48;
    }
  *dst_iter = 0;

  return dst;
}

