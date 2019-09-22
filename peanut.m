#import <sys/types.h>
#import <sys/stat.h>
#import <fcntl.h>

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#import "peanut.h"
#import "util.h"

void peanut_get(const char *file_name, char **result)
{
	static const size_t max_size = 4;

	*result = (char*) malloc(max_size);
	if (!result)
		return;
	memset(*result, 0, max_size);

	struct stat st;
	if (stat(file_name, &st) < 0) {
		return;
	}

	size_t i = 0;
	(*result)[i++] = (st.st_mode & S_IWUSR)?'w':'r';
	(*result)[i++] = (st.st_flags & UF_HIDDEN)?'h':'v';
	(*result)[i++] = (st.st_flags & UF_IMMUTABLE)?'l':'s';

	(*result)[i] = 0;
}

void peanut_set(const char *file_name, const char *mode_string, int *result)
{
	*result = 1;

	struct stat st_original;
	if (stat(file_name, &st_original) < 0) {
		*result = 0;
		return;
	}

	struct stat st_new = st_original;

	size_t mode_string_length = strlen(mode_string);
	if (mode_string_length == 0) {
		/* fai un reset di tutto */
		st_new.st_flags &= ~(UF_HIDDEN | UF_IMMUTABLE);
		st_new.st_mode |= S_IWUSR;
	}
	else {
		for (size_t i = 0; i < mode_string_length; i++) {
			char a = mode_string[i];

			switch (a) {
				case 'r': st_new.st_mode &= ~(S_IWUSR | S_IWGRP | S_IWOTH);
				break;
				case 'w': st_new.st_mode |= S_IWUSR;
				break;
				case 'h': st_new.st_flags |= UF_HIDDEN;
				break;
				case 'v': st_new.st_flags &= ~UF_HIDDEN;
				break;
				case 'l': st_new.st_flags |= UF_IMMUTABLE;
				break;
				case 's': st_new.st_flags &= ~UF_IMMUTABLE;
				break;
			}
		}
	}

	if (st_original.st_flags != st_new.st_flags) {
		if (chflags(file_name, st_new.st_flags) < 0) { /*TODO check return value */
			*result = 0;
		}
	}

	if (st_original.st_mode != st_new.st_mode) {
		if (chmod(file_name, st_new.st_mode) < 0) { /*TODO check return value */
			*result = 0;
		}
	}
}

