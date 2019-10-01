#ifndef PEANUT_PROCESS_H
#define PEANUT_PROCESS_H

#include "log.h"

void peanut_get(log_ctx_t *log,
                const char *path,
                char **result);
void peanut_set(log_ctx_t *log,
                const char *path,
                const char *mode_string,
                int *result);

#endif

