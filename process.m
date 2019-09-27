#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#import "platformserial.h"
#import "diskserial.h"
#import "mangler.h"
#import "clipboard.h"
#import "util.h"

const char *stock_text_invalid = "1000001";
const char *stock_text_missing = "1111111";
const char *stock_text_zero    = "1001001";

int process(const char *arg, char **result)
{
  *result = NULL;

  if (strcmp(arg, "disksn") == 0)
    {
      *result = get_boot_disk_sn();
    }
  else if (strcmp(arg, "platsn") == 0)
    {
      *result = get_platform_sn();
    }
  else
    {
      ALMOND_NOTE(("Invalid argument: %s\n", arg));
      return -1;
    }

  if (*result)
    {
      ALMOND_NOTE(("Retrieved string:       %s\n", *result));
    }

  if (!(*result))
    {
      *result = util_string_copy(stock_text_invalid);
    }
  else if ( strlen(*result) == 0 ||
            util_string_is_all_zeros(*result) )
    {
      free(*result);
      *result = util_string_copy(stock_text_zero);
    }
  else
    {
      char *new_text = mangle(*result);
      free(*result);
      *result = new_text;
    }

  copy_text_to_clipboard(*result);

  return 0;
}

