#include <stdlib.h>
#include <stdio.h>

#import "process.h"

int main(int argc, char **argv) {
  char *result = NULL;
  int ret = 0;

  /* only allow one argument */
  if (argc != 2)
    {
      printf("Usage: %s disksn,platsn\n\n", argv[0]);
      exit(EXIT_FAILURE);
    }

  ret = process(argv[1], &result);

  if (ret >= 0 && result != NULL)
    printf("%s\n", result);

  return ret >= 0 ? EXIT_SUCCESS
                  : EXIT_FAILURE;
}

