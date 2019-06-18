#import <Foundation/Foundation.h>
#import <DiskArbitration/DiskArbitration.h>

#include <sys/param.h>
#include <sys/mount.h>

#import "util.h"

char* get_boot_disk_sn(void)
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

char* get_boot_disk_sn_v2(void)
{
  kern_return_t kr = KERN_SUCCESS;
  io_iterator_t iter = IO_OBJECT_NULL;
  io_service_t service = IO_OBJECT_NULL;
  CFMutableDictionaryRef properties = CFDictionaryCreateMutable(NULL, 0, NULL, NULL);
  char *text = NULL;

  ALMOND_NOTE(("Reading boot disk serial number.\n"));

  kr = IOServiceGetMatchingServices(kIOMasterPortDefault,
                                    IOServiceNameMatching("AppleAHCIDiskDriver"),
                                    &iter);

  if (kr != KERN_SUCCESS)
    {
      ALMOND_NOTE(("Cannot find AppleAHCIDiskDriver services in I/O Registry.\n"));
      return NULL;
    }

  service = IOIteratorNext(iter);
  if (service == IO_OBJECT_NULL)
    {
      ALMOND_NOTE(("Cannot find AppleAHCIDiskDriver services in I/O Registry.\n"));
      return NULL;
    }

  kr = IORegistryEntryCreateCFProperties(service,
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

      /*NSLog(@"%@", desc_dict);*/

      NSString *sn = [desc_dict objectForKey:@"Serial Number"];
      text = util_string_copy([sn UTF8String]);
      CFRelease(properties);
    }

  return text;
}

