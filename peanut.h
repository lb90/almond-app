#ifndef PEANUT_PROCESS_H
#define PEANUT_PROCESS_H

#include "log.h"

void peanut_get(log_ctx_t *log,
                const char *file_name,
                char **result);
void peanut_set(log_ctx_t *log,
                const char *file_name,
                const char *mode_string,
                int *result);

#endif

