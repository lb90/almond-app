/*
 *
 */

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include <dlfcn.h>

static
void find_error_reason(void);

int main(int argc, char **argv) {
  const char  *bundle_name   = "Peanut.xtra";
  const char  *func_name     = "DllGetInterface";
  void        *bundle        = NULL;
  void        *func_address  = NULL;
  int          ret_value     = EXIT_FAILURE;

  bundle = dlopen(bundle_name, RTLD_NOW);
  if (!bundle)
    {
      printf("Cannot open bundle \"%s\"\n", bundle_name);
      find_error_reason();
      goto cleanup;
    }
  func_address = dlsym(bundle, func_name);
  if (!func_address)
    {
      printf("Cannot find symbol \"%s\" in bundle.", func_name);
      find_error_reason();
      goto cleanup;
    }

  ret_value = EXIT_SUCCESS;
cleanup:
  if (bundle) {
    dlclose(bundle);
  }

  return ret_value;
}

static
void find_error_reason(void)
{
  char *reason = dlerror();
  if (reason && strlen(reason))
    printf("\nReason: %s\n", reason);
  else
    printf("\nUnknown error.\n");
}

