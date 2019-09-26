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

	/*
	*/

	BOOL read_write_changes = (st_original.st_mode != st_new.st_mode)? YES : NO;

	if (read_write_changes) {
		printf("ro/w permissions are going to change.\n");

		BOOL locked_unlocked_changes = ((st_original.st_flags & UF_IMMUTABLE)
		                                != (st_new.st_flags & UF_IMMUTABLE))?
		                                YES : NO;
		BOOL original_locked = (st_original.st_flags & UF_IMMUTABLE)? YES : NO;

		if (locked_unlocked_changes) {
			printf("locked/unlocked is going to change.\n");
			if (original_locked) {
				printf("original file is locked, but we have to unlock it. "
				       "first change the flags (which unlocks) and then set ro/w permissions.\n");
				if (chflags(file_name, st_new.st_flags) < 0)
					*result = 0;
				if (chmod(file_name, st_new.st_mode) < 0)
					*result = 0;
			}
			else {
				printf("original is not locked, but we have to lock it. "
				       "first change ro/w permissions and then change flags (which locks).\n");
				if (chmod(file_name, st_new.st_mode) < 0)
					*result = 0;
				if (chflags(file_name, st_new.st_flags) < 0)
					*result = 0;
			}
		}
		else {
			printf("we won't change locked/unocked at all.\n");
			if (original_locked) {
				printf("file is locked (and so will stay). "
				       "but we have to change permissions.\n");
				printf("trick: unlock, change permissions, re-lock the file\n");
				if (chflags(file_name, (st_original.st_flags & ~UF_IMMUTABLE)) < 0)
					*result = 0;
				if (chmod(file_name, st_new.st_mode) < 0)
					*result = 0;
				if (chflags(file_name, st_original.st_flags) < 0)
					*result = 0;
			}
			else {
				printf("file is not locked, we have no problems at all!\n.");
				if (chmod(file_name, st_new.st_mode) < 0)
					*result = 0;
				if (chflags(file_name, st_new.st_flags) < 0)
					*result = 0;
			}
		}
	}
	else {
		printf("we don't have to change ro/w permissions, no problems at all!\n.");
		if (st_original.st_flags != st_new.st_flags) {
			if (chflags(file_name, st_new.st_flags) < 0) {
				*result = 0;
			}
		}
	}
}

