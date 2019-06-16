#include <stdlib.h>
#include <string.h>

#import "mangler.h"
#import "util.h"

static
int isascii(const char *text);
static
int isallprintablechars(const char *text);

char* mangle(const char *text) {
  if (!isascii(text))
    {
      ALMOND_NOTE(("Error: string is outside ASCII character set.\n"));
      return NULL;
    }
  if (!isallprintablechars(text))
    {
      ALMOND_NOTE(("Error: string contains control characters.\n"));
      return NULL;
    }

  return NULL/*TODO strcpy(text)*/;
}

static
int isascii(const char *text) {
  const unsigned char *iter = (const unsigned char*) text;

  for (; *iter != 0; iter++)
    if (*iter > 127) /*TODO*/
      return 0;

  return 1;
}

static
int isallprintablechars(const char *text) {
  const unsigned char *iter = (const unsigned char*) text;

  for (; *iter != 0; iter++)
    if (*iter < 32) /*TODO*/
      return 0;

  return 1;
}

