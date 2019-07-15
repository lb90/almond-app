#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#import "platformserial.h"
#import "diskserial.h"
#import "clipboard.h"
#import "mangler.h"
#import "util.h"

const char *stock_text_invalid = "1000001";
const char *stock_text_missing = "1111111";
const char *stock_text_zero    = "1001001";

int process(const char *arg, char **result)
{
  const char *text = NULL;

  *result = NULL;

  if (strcmp(arg, "disksn") == 0)
    {
      text = get_boot_disk_sn_v2();
    }
  else if (strcmp(arg, "platsn") == 0)
    {
      text = get_platform_sn();
    }
  else
    {
      ALMOND_NOTE(("Invalid argument: %s\n", arg));
      return -1;
    }

  if (text)
    {
      ALMOND_NOTE(("Retrieved string:       %s\n", text));
    }

  if (!text)
    {
      text = util_string_copy(stock_text_invalid);
    }
  else if ( strlen(text) == 0 ||
            util_string_is_all_zeros(text) )
    {
      free((void*)text);
      text = util_string_copy(stock_text_zero);
    }
  else
    {
      char *new_text = mangle(text);
      free((void*)text);
      text = new_text;
    }

  copy_text_to_clipboard(text);
  *result = text;
/*ALMOND_NOTE(("Copied to clipboard:    %s\n", text));*/

  return 0;
}

