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
      text = get_boot_disk_sn();
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
/*
  if (!text)
    text = stock_text_invalid;
  if (strcmp(text, "0") == 0)
    {
      free(text);
      text = stock_text_zero;
    }
*/
  if (text)
    {
      ALMOND_NOTE(("Retrieved string:       %s\n", text));
      text = mangle(text);
      ALMOND_NOTE(("Copied to clipboard:    %s\n", text));
      copy_text_to_clipboard(text);
    }

  exit(EXIT_SUCCESS);
}

