#ifndef ALMOND_UTIL_H
#define ALMOND_UTIL_H

#ifdef ALMOND_DEBUG
#include <stdio.h>
  #define ALMOND_NOTE(arg) printf arg
#else
  #define ALMOND_NOTE(arg)
#endif

#include <Foundation/Foundation.h>

char *util_string_copy(const char *text);
int util_string_is_all_zeros(const char *text);
char *util_cfstring_to_string(CFStringRef text);

#endif

