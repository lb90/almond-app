#import <Foundation/Foundation.h>
#import <DiskArbitration/DiskArbitration.h>

#include <sys/param.h>
#include <sys/mount.h>

#import "util.h"

char* get_boot_disk_sn()
{
  char *text = NULL;
  DASessionRef session;

  ALMOND_NOTE(("Reading boot disk serial number.\n"));

  session = DASessionCreate(kCFAllocatorDefault);
  if (session)
    {
      /*TODO optimize for OSX 10.7+ */
      struct statfs st;
      DADiskRef disk;

      statfs("/", &st);
      disk = DADiskCreateFromBSDName(kCFAllocatorDefault,
                                     session,
                                     st.f_mntfromname);
      if (disk)
        {
          CFDictionaryRef desc_dict;

          desc_dict = DADiskCopyDescription(disk);
#ifdef ALMOND_DEBUG
          NSLog(@"%@", desc_dict);
#endif
          if (desc_dict)
            {
              CFTypeRef value;
              CFStringRef value_as_string;

              /* what happens if desc_dict do not contain such entry? */
              value = (CFTypeRef) CFDictionaryGetValue(desc_dict,
                                                       CFSTR("DAMediaUUID"));
                                                       /*TODO kDADiskDescriptionMediaUUIDKey*/
              value_as_string = CFStringCreateWithFormat(NULL,
                                                         NULL,
                                                         CFSTR("%@"),
                                                         value);

              /* CFStringRef to c string */
              if (value_as_string)
                {
#if 1
                  const char *u8 = [(__bridge NSString*)value_as_string UTF8String]; /*TODO should we release? Don't think so, being const... */
                  text = util_string_copy(u8);
#else
                  CFIndex length = CFStringGetLength(value_as_string);
                  CFIndex max_size = CFStringGetMaximumSizeForEncoding(length, kCFStringEncodingUTF8) + 1;
                  char *buffer = (char*) malloc(max_size);
                  if (CFStringGetCString(value_as_string, buffer, max_size, kCFStringEncodingUTF8))
                    text = buffer;
                  else {
                    ALMOND_NOTE(("Cannot convert CFString to UTF8\n"));
                    free(buffer);
                  }
#endif
                }

              CFRelease(value_as_string);
              CFRelease(desc_dict);
            }
          CFRelease(disk);
        }
      CFRelease(session);
    }

  return text;
}

/*

#include <IOKit/IOKitLib.h>
#include <Cocoa/Cocoa.h>

int get_boot_disk_sn()
{
  kern_return_t kr;
  io_iterator_t io_objects;
  io_service_t  io_service;

  kr = IOServiceGetMatchingServices(kIOMasterPortDefault),
                                    IOServiceNameMatching("AppleAHCIDiskDriver"),
                                    &io_objects);

  if (kr == KERN_SUCCESS)
    {
      while (io_service = IOIteratorNext(io_objects))
        {
          kr = IORegistryEntryCreateCFProperties(io_service, &service_properties, kCFAllocatorDefault);
          if (kr == KERN_SUCCESS)
            {
              NSDictionary *m = (NSDictionary*) service_properties;
              NSLog(@"%@", m);
              CFRelease(service_properties);
            }
          {
          io_iterator_t iter;
          kr = IORegistryEntryGetChildIterator(io_service, kIOServicePlane, &iter);
          
          }
        }
    }
}

*/

