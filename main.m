#include <stdlib.h>

#import "process.h"
#import "util.h"

int main(int argc, char **argv) {
  int ret = 0;

  /* only allow one argument */
  if (argc != 2)
    {
      ALMOND_NOTE(("Usage: %s disksn,platsn\n\n", argv[0]));
      exit(EXIT_FAILURE);
    }

  ret = process(argv[1]);

  if (ret < 0)
    return EXIT_FAILURE;

  return EXIT_SUCCESS;
}

