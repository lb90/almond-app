#ifndef PEANUT_UTIL_H
#define PEANUT_UTIL_H

#include <stdarg.h> /* for varargs */

char *util_string_copy(const char *text);
char *util_string_compose(const char *format_string, ...);
char *util_string_compose_va(const char *format_string, va_list ap);
char *util_string_from_error_code(int error_code);

#endif

