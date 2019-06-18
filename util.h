#ifndef ALMOND_UTIL_H
#define ALMOND_UTIL_H

#ifdef ALMOND_DEBUG
#include <stdio.h>
  #define ALMOND_NOTE(arg) printf arg
#else
  #define ALMOND_NOTE(arg)
#endif

char *util_string_copy(const char *text);
int util_string_all_zeros(const char *text);

#endif

