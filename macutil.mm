#import "macutil.h"
#import "util.h"

#import <Foundation/Foundation.h>

char* util_hfs_path_to_posix_path(const char *hfs_path) {
  char *ret = NULL;

  CFStringRef hfs_path_cf = CFStringCreateWithCString(
                              kCFAllocatorDefault,
                              hfs_path,
                              kCFStringEncodingUTF8);
  if (!hfs_path_cf)
    return NULL;

  CFURLRef url_cf = CFURLCreateWithFileSystemPath(
                      kCFAllocatorDefault,
                      hfs_path_cf,
                      kCFURLHFSPathStyle,
                      false);

  if (url_cf) {
    ret = util_string_copy([[ (__bridge NSURL*)url_cf path] UTF8String]);
    CFRelease(url_cf);
  }

  CFRelease(hfs_path_cf);
  return ret;
}

