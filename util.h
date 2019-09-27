#ifndef PEANUT_UTIL_H
#define PEANUT_UTIL_H

char *util_string_copy(const char *text);
char *util_string_compose(const char *format_string, ...);
char *util_string_from_error_code(int error_code);

#endif

