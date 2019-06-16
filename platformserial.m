#import <CoreFoundation/CoreFoundation.h>
#import <IOKit/IOKitLib.h>

#import "util.h"

char* get_platform_sn() {
  CFMutableDictionaryRef matching;
  io_service_t           service;
  CFStringRef            serial_number;
  char                   *text = NULL;

  matching = IOServiceMatching("IOPlatformExpertDevice");
  service = IOServiceGetMatchingService(kIOMasterPortDefault, matching);
  serial_number = IORegistryEntryCreateCFProperty(service,
                                                  CFSTR("IOPlatformSerialNumber"),
                                                  kCFAllocatorDefault,
                                                  0);

  /*TODO CFStringRef to c string */

  CFRelease(serial_number);
  IOObjectRelease(service);
  CFRelease(matching); /*TODO is this right?*/

  return text;
}

/*

int get_platform_sn() {
  CFTypeRef platSN = IORegistryEntryCreateCFProperty(platformExpertDevice,
                                                     CFSTR("IOPlatformSerialNumber"),
                                                     kCFAllocatorDefault,
                                                     0);
  if (CFGetTypeID(platSN) == CFStringGetTypeID())
    {
      serialNumber = [NSString stringWithString:(__bridge NSString*)platSN];
      CFRelease(platSN);
    }

  IOObjectRelease(platformExpertDevice);
  return 0;
}

*/

