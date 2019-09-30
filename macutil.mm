#import "macutil.h"
#import "log.h"
#import "util.h"

#import <Foundation/Foundation.h>

char* util_hfs_path_to_posix_path(log_ctx_t *log,
                                  const char *hfs_path)
{
  char *ret = NULL;

  CFStringRef hfs_path_cf = CFStringCreateWithCString(
                              kCFAllocatorDefault,
                              hfs_path,
                              kCFStringEncodingUTF8);
  if (!hfs_path_cf) {
    log_message(log, LOG_LEVEL_ERROR,
    "Impossibile allocare memoria o encoding della stringa errato, richiesto UTF8");
    return NULL;
  }

  CFURLRef url_cf = CFURLCreateWithFileSystemPath(
                      kCFAllocatorDefault,
                      hfs_path_cf,
                      kCFURLHFSPathStyle,
                      false);

  if (url_cf) {
    ret = util_string_copy([[ (__bridge NSURL*)url_cf path] UTF8String]);
    CFRelease(url_cf);
  }
  else {
    log_message(log, LOG_LEVEL_ERROR,
    "Errore durante la conversione la conversione in POSIX path dell'HFS path \"%s\"", hfs_path);
  }

  CFRelease(hfs_path_cf);
  return ret;
}

