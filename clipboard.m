#import <Cocoa/Cocoa.h>

int copy_text_to_clipboard(const char *text)
{
  [[NSPasteboard generalPasteboard] clearContents];
  /*TODO replace NSStringPboardType, deprecated*/
  [[NSPasteboard generalPasteboard] setString:[NSString stringWithUTF8String:text]
                                    forType:NSStringPboardType];

  return 0;
}

