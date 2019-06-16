#import <Foundation/Foundation.h>
#import <IOKit/IOKitLib.h>

#import "util.h"

char* get_platform_sn() {
  CFMutableDictionaryRef matching;
  io_service_t           service;
  CFStringRef            serial_number;
  char                   *text = NULL;

  ALMOND_NOTE(("Reading platform serial number.\n"));

  matching = IOServiceMatching("IOPlatformExpertDevice");
  if (!matching)
    {
      ALMOND_NOTE(("Cannot find IOPlatformExpertDevice matching IOKit service.\n"));
      return NULL;
    }
  service = IOServiceGetMatchingService(kIOMasterPortDefault, matching);
  serial_number = IORegistryEntryCreateCFProperty(service,
                                                  CFSTR("IOPlatformSerialNumber"),
                                                  kCFAllocatorDefault,
                                                  0);
  if (!serial_number)
    {
      ALMOND_NOTE(("Cannot find IOPlatformSerialNumber key/value for IOPlatformExpertDevice.\n"));
      return NULL;
    }

  /* CFStringRef to c string */
#if 1
  const char *u8 = [(__bridge NSString*)serial_number UTF8String]; /*TODO should we release? Don't think so, being const... */
  text = util_string_copy(u8);
#else
  CFIndex length = CFStringGetLength(serial_number);
  CFIndex max_size = CFStringGetMaximumSizeForEncoding(length, kCFStringEncodingUTF8) + 1;
  char *buffer = (char*) malloc(max_size);
  if (CFStringGetCString(serial_number, buffer, max_size, kCFStringEncodingUTF8))
    text = buffer;
  else
    {
      ALMOND_NOTE(("Cannot convert CFString to UTF8\n"));
      free(buffer);
    }
#endif
/*
  CFRelease(serial_number);
  IOObjectRelease(service);
  CFRelease(matching);
*/
  return text;
}

