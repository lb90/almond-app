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

int main(int argc, char **argv) {
  const char *text = NULL;

  /* only allow one argument */
  if (argc != 2)
    {
      ALMOND_NOTE(("Usage: %s disksn,platsn\n\n", argv[0]));
      exit(EXIT_FAILURE);
    }

  if (strcmp(argv[1], "disksn") == 0)
    {
      text = get_boot_disk_sn_v2();
    }
  else if (strcmp(argv[1], "platsn") == 0)
    {
      text = get_platform_sn();
    }
  else
    {
      ALMOND_NOTE(("Invalid argument: %s\n", argv[1]));
      exit(EXIT_FAILURE);
    }

  if (text)
    {
      ALMOND_NOTE(("* Retrieved string:       %s\n", text));
    }

  if (!text)
    {
      text = stock_text_invalid;
    }
  else if ( strlen(text) == 0 ||
            util_string_is_all_zeros(text) )
    {
      free((void*)text);
      text = stock_text_zero;
    }
  else
    {
      char *new_text = mangle(text);
      free((void*)text);
      text = new_text;
    }

  copy_text_to_clipboard(text);
/*ALMOND_NOTE(("* Copied to clipboard:    %s\n", text));*/

  exit(EXIT_SUCCESS);
}

