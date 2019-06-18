#import <Foundation/Foundation.h>
#import <IOKit/IOKitLib.h>

#import "util.h"

char* get_platform_sn(void) {
  CFMutableDictionaryRef matching   = NULL;
  io_service_t           service    = IO_OBJECT_NULL;
  CFStringRef            serial     = NULL;
  char                   *text      = NULL;

  ALMOND_NOTE(("Reading platform serial number.\n"));

  matching = IOServiceMatching("IOPlatformExpertDevice");
  if (!matching)
    {
      ALMOND_NOTE(("Cannot find IOPlatformExpertDevice matching IOKit service.\n"));
      goto cleanup;
    }
  service = IOServiceGetMatchingService(kIOMasterPortDefault, matching);
  if (service == IO_OBJECT_NULL)
    {
      ALMOND_NOTE(("Cannot find IOPlatformExpertDevice matching IOKit service.\n"));
      goto cleanup;
    }
  serial = IORegistryEntryCreateCFProperty(service,
                                           CFSTR("IOPlatformSerialNumber"),
                                           kCFAllocatorDefault,
                                           0);
  if (!serial)
    {
      ALMOND_NOTE(("Cannot find IOPlatformSerialNumber key/value for IOPlatformExpertDevice.\n"));
      goto cleanup;
    }

  text = util_cfstring_to_string(serial);

cleanup:
  if (serial) {
      CFRelease(serial);
  }
  if (service != IO_OBJECT_NULL) {
      IOObjectRelease(service);
  }
  if (matching) {
      CFRelease(matching);
  }

  return text;
}

