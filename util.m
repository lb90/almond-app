#import "util.h"

#include <stdlib.h>
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
      ALMOND_NOTE(("Cannot allocate memory for string copy operation.\n"));
      return NULL;
    }
  memset(dst, 0, len + 1);
  strncpy(dst, src, len + 1);
  dst[len] = '\0';

  return dst;
}

int util_string_is_all_zeros(const char *text)
{
  size_t len = 0;
  if (!text)
    return 1;

  len = strlen(text);
  if (len == 0)
    return 1;

  for (size_t i = 0; i < len; i++)
    {
      if (text[i] != '0' && text[i] != ' ')
        return 0;
    }

  return 1;
}

char* util_cfstring_to_string(CFStringRef text)
{
  const char *u8 = [(__bridge NSString*)text UTF8String];
  return util_string_copy(u8);
/*
  CFIndex length = CFStringGetLength(serial_number);
  CFIndex max_size = CFStringGetMaximumSizeForEncoding(length, kCFStringEncodingUTF8) + 1;
  char *buffer = (char*) malloc(max_size);

  if (CFStringGetCString(serial_number, buffer, max_size, kCFStringEncodingUTF8))
    return buffer;
  else
    {
      ALMOND_NOTE(("Cannot convert CFString to UTF8\n"));
      free(buffer);
      return NULL;
    }
*/
}

