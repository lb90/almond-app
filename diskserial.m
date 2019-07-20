#import <Foundation/Foundation.h>
#import <DiskArbitration/DiskArbitration.h>

#include <sys/param.h>
#include <sys/mount.h>

#import "util.h"

char* get_boot_disk_sn(void)
{
  kern_return_t          kr        = KERN_SUCCESS;
  io_iterator_t          iter      = IO_OBJECT_NULL;
  io_service_t           service   = IO_OBJECT_NULL;
  CFMutableDictionaryRef props     = NULL;
  CFStringRef            serial    = NULL;
  char                   *text     = NULL;

  ALMOND_NOTE(("Reading boot disk serial number.\n"));

  kr = IOServiceGetMatchingServices(kIOMasterPortDefault,
                                    IOServiceNameMatching("AppleAHCIDiskDriver"),
                                    &iter);
  if (kr != KERN_SUCCESS)
    {
      ALMOND_NOTE(("Cannot find AppleAHCIDiskDriver services in I/O Registry.\n"));
      goto cleanup;
    }
  service = IOIteratorNext(iter);
  if (service == IO_OBJECT_NULL)
    {
      ALMOND_NOTE(("Cannot find AppleAHCIDiskDriver services in I/O Registry.\n"));
      goto cleanup;
    }
  kr = IORegistryEntryCreateCFProperties(service,
                                         &props,
                                         kCFAllocatorDefault,
                                         kNilOptions);
  if (kr != KERN_SUCCESS)
    {
      ALMOND_NOTE(("Cannot inspect I/O Registry entry.\n"));
      goto cleanup;
    }

#ifdef ALMOND_DEBUG
  NSLog(@"%@", props);
#endif

  serial = CFStringCreateWithFormat(
               NULL, NULL, CFSTR("%@"),
               (CFTypeRef)CFDictionaryGetValue(props, CFSTR("Serial Number")));
  text = util_cfstring_to_string(serial);

cleanup:
  if (serial) {
    CFRelease(serial);
  }
  if (props) {
    CFRelease(props);
  }
  if (service != IO_OBJECT_NULL) {
    IOObjectRelease(service);
  }
  if (iter != IO_OBJECT_NULL) { /*TODO: before or after service? */
    IOObjectRelease(iter);
  }

  return text;
}

char* get_boot_disk_sn_from_disk_arbitration(void)
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
          CFMutableDictionaryRef properties = CFDictionaryCreateMutable(NULL, 0, NULL, NULL);
          io_service_t service = DADiskCopyIOMedia(disk);
          kern_return_t kr = IORegistryEntryCreateCFProperties(service,
                                                               &properties,
                                                               kCFAllocatorDefault,
                                                               kNilOptions);
          if (kr != KERN_SUCCESS)
            {
              ALMOND_NOTE(("Cannot inspect I/O Registry entry.\n"));
            }
          else
            {
              NSDictionary *desc_dict = (__bridge NSDictionary*) properties;
#ifdef ALMOND_DEBUG
              NSLog(@"%@", desc_dict);
#endif
              NSString *sn = [desc_dict objectForKey:@"Serial Number"];
              text = util_string_copy([sn UTF8String]);
              CFRelease(properties);
            }

          IOObjectRelease(service);
          CFRelease(disk);
        }
      CFRelease(session);
    }

  return text;
}

