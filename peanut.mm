#import <sys/types.h>
#import <sys/stat.h>
#import <fcntl.h>

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#import "peanut.h"
#import "log.h"
#import "macutil.h"

void peanut_get(log_ctx_t *log_ctx,
                const char *file_name,
                char **result)
{
	const size_t max_size = 4;

	*result = (char*) malloc(max_size);
	if (!result) {
		log_message_with_error_code(log_ctx, LOG_LEVEL_ERROR,
		"Impossibile allocare memoria per %lu byte", (unsigned long) max_size);
		return;
	}
	memset(*result, 0, max_size);

	char *file_name_posix = util_hfs_path_to_posix_path(file_name);
	if (!file_name_posix)
		return;

	struct stat st;
	if (stat(file_name_posix, &st) < 0) {
		log_message_with_error_code(log_ctx, LOG_LEVEL_ERROR,
		"Impossibile eseguire stat di %s", file_name_posix);
		free(file_name_posix);
		return;
	}

	size_t i = 0;
	(*result)[i++] = (st.st_mode & S_IWUSR)?'w':'r';
	(*result)[i++] = (st.st_flags & UF_HIDDEN)?'h':'v';
	(*result)[i++] = (st.st_flags & UF_IMMUTABLE)?'l':'s';

	(*result)[i] = 0;

	free(file_name_posix);
}

void peanut_set(log_ctx_t *log_ctx,
                const char *file_name,
                const char *mode_string,
                int *result)
{
	typedef enum {
		OP_APPLY_FIRST_FLAGS,
		OP_APPLY_FIRST_PERMISSIONS,
		OP_APPLY_FLAGS_AND_PERMISSIONS_WITH_TRICK,
	} op_t;

	*result = 1;

	char *file_name_posix = util_hfs_path_to_posix_path(file_name);
	if (!file_name_posix) {
		*result = 0;
		return;
	}

	struct stat st_original;
	if (stat(file_name_posix, &st_original) < 0) {
		log_message_with_error_code(log_ctx, LOG_LEVEL_ERROR,
		"Impossibile eseguire stat di %s", file_name_posix);
		*result = 0;
		free(file_name_posix);
		return;
	}

	struct stat st_new = st_original;

	size_t mode_string_length = strlen(mode_string);
	if (mode_string_length == 0) {
		/* con una stringa vuota fai un reset di tutto */
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
	 * In Mac OS non e' possibile cambiare i permessi a un file se ha il flag locked.
	 * Per ovviare a questo ordiniamo le operazioni in modo opportuno.
	*/

	op_t operation = OP_APPLY_FIRST_FLAGS; /* default */

	int permissions_change = (st_original.st_mode != st_new.st_mode)? 1 : 0;
	int locked_change = (    (st_original.st_flags & UF_IMMUTABLE)
	                      != (st_new.st_flags      & UF_IMMUTABLE))? 1 : 0;
	int is_locked = (st_original.st_flags & UF_IMMUTABLE)? 1 : 0;
	if (permissions_change) {
		if (locked_change) { /* just a matter of order */
			if (!is_locked) {
				operation = OP_APPLY_FIRST_PERMISSIONS;
			}
		}
		else {
			if (is_locked) { /* trick */
				operation = OP_APPLY_FLAGS_AND_PERMISSIONS_WITH_TRICK;
			}
		}
	}

	switch (operation) {
		case OP_APPLY_FIRST_FLAGS: {
			if (st_original.st_flags != st_new.st_flags) {
				if (chflags(file_name_posix, st_new.st_flags) < 0) {
					log_message_with_error_code(log_ctx, LOG_LEVEL_ERROR,
					"Impossibile eseguire chflags di %s (mode: %s)", file_name_posix, mode_string);
					*result = 0;
				}
			}
			if (st_original.st_mode != st_new.st_mode) {
				if (chmod(file_name_posix, st_new.st_mode) < 0) {
					log_message_with_error_code(log_ctx, LOG_LEVEL_ERROR,
					"Impossibile eseguire chmod di %s (mode: %s)", file_name_posix, mode_string);
					*result = 0;
				}
			}
		}
		break;
		case OP_APPLY_FIRST_PERMISSIONS: {
			if (st_original.st_mode != st_new.st_mode) {
				if (chmod(file_name_posix, st_new.st_mode) < 0) {
					log_message_with_error_code(log_ctx, LOG_LEVEL_ERROR,
					"Impossibile eseguire chmod di %s (mode: %s)", file_name_posix, mode_string);
					*result = 0;
				}
			}
			if (st_original.st_flags != st_new.st_flags) {
				if (chflags(file_name_posix, st_new.st_flags) < 0) {
					log_message_with_error_code(log_ctx, LOG_LEVEL_ERROR,
					"Impossibile eseguire chflags di %s (mode: %s)", file_name_posix, mode_string);
					*result = 0;
				}
			}
		}
		break;
		case OP_APPLY_FLAGS_AND_PERMISSIONS_WITH_TRICK:
			/* se siamo qui sappiamo che
			   a) il file è locked
			   b) non cambieremo nulla del locked */
			if (chflags(file_name_posix, (st_new.st_flags & ~UF_IMMUTABLE)) < 0) {
				log_message_with_error_code(log_ctx, LOG_LEVEL_ERROR,
				"Impossibile eseguire chflags per rimuovere flag locked a %s", file_name_posix);
				*result = 0;
			}
			if (st_original.st_mode != st_new.st_mode) {
				if (chmod(file_name_posix, st_new.st_mode) < 0) {
					log_message_with_error_code(log_ctx, LOG_LEVEL_ERROR,
					"Impossibile eseguire chmod di %s (mode: %s)", file_name_posix, mode_string);
					*result = 0;
				}
			}
			if (chflags(file_name_posix, (st_new.st_flags)) < 0) {
				log_message_with_error_code(log_ctx, LOG_LEVEL_ERROR,
				"Impossibile eseguire chflags per aggiungere flag locked a %s", file_name_posix);
				*result = 0;
			}
		break;
	}

	free(file_name_posix);
}

