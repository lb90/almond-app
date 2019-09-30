#ifndef PEANUT_MACUTIL_H
#define PEANUT_MACUTIL_H

#import <Foundation/Foundation.h>

#import "log.h"

char* util_hfs_path_to_posix_path(log_ctx_t *log, const char *hfs_path);

#endif

