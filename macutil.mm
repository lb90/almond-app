#import "macutil.h"
#import "util.h"

#import <Foundation/Foundation.h>

char* hfs_path_to_posix_path(const char *hfs_path) {
  char *ret = NULL;

  CFURLRef *cfurl = CFURLCreateWithFileSystemPath(
                      NULL,
                      kCFAllocatorDefault,
                      kCFURLHFSPathStyle,
                      false);

  if (cfurl) {
    ret = util_string_copy([(__bridge NSURL*)cfurl path]);
    CFRelease(cfurl);
  }

  return ret;
}

