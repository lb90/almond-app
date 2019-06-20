/*
 *
 */

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include <dlfcn.h>

int main(int argc, char **argv) {
  const char  *bundle_name   = "almond.xtra";
  const char  *func_name     = "DllGetInterface";
  void        *bundle        = NULL;
  void        *func_address  = NULL;
  int          ret_value     = EXIT_FAILURE;

  bundle = dlopen(bundle_name, RTLD_NOW);
  if (!bundle)
    {
      printf("Cannot open bundle \"%s\"\n", bundle_name);
      goto cleanup;
    }
  func_address = dlsym(bundle, func_name);
  if (!func_address)
    {
      char *reason = NULL;
      printf("Cannot find symbol \"%s\" in bundle.", func_name);

      reason = dlerror();
      if (reason && strlen(reason))
        printf("\nReason: %s\n", reason);
      else
        printf("\nUnknown error.\n");

      goto cleanup;
    }

  ret_value = EXIT_SUCCESS;
cleanup:
  if (bundle) {
    dlclose(bundle);
  }

  return ret_value;
}

