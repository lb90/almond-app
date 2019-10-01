#import <sys/types.h>
#import <sys/stat.h>
#import <fcntl.h>

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#import "peanut.h"
#import "log.h"
#import "macutil.h"

void peanut_get(log_ctx_t *log,
                const char *path_hfs,
                char **result)
{
	const size_t max_size = 4;

	if (!path_hfs || !result)
		return;

	if (strlen(path_hfs) == 0) {
		log_message_simple(
			log,
			LOG_LEVEL_INFO,
			"Path vuoto"
		);
		*result = NULL;
		return;
	}

	*result = (char*) malloc(max_size);
	if (!result) {
		log_message_errno(
			log,
			LOG_LEVEL_ERROR,
			"Impossibile allocare memoria per %lu byte",
			(unsigned long) max_size
		);
		return;
	}
	else {
		memset(*result, 0, max_size);
	}

	char *path = util_hfs_path_to_posix_path(log, path_hfs);
	if (!path) {
		free(*result);
		*result = NULL;
		return;
	}
	else {
		log_message(
			log,
			LOG_LEVEL_DEBUG,
			"Ottenuto POSIX path \"%s\"",
			path
		);
	}

	struct stat st;
	if (stat(path, &st) < 0) {
		log_message_errno(
			log,
			LOG_LEVEL_ERROR,
			"Impossibile eseguire stat di \"%s\"",
			path
		);
		free(path);
		free(*result);
		*result = NULL;
		return;
	}

	size_t i = 0;
	(*result)[i++] = (st.st_mode & S_IWUSR)?'w':'r';
	(*result)[i++] = (st.st_flags & UF_HIDDEN)?'h':'v';
	(*result)[i++] = (st.st_flags & UF_IMMUTABLE)?'l':'s';

	(*result)[i] = 0;

	free(path);
}

int apply_mod(log_ctx_t *log,
              const char *path,
              struct stat *st_new)
{
  if (!st_new)
    return -1;

  if (chmod(path, st_new->st_mode) < 0) {
    log_message_errno(
      log,
      LOG_LEVEL_ERROR,
      "Impossibile eseguire chmod di \"%s\"",
      path
    );
    return -1;
  }

  return 0;
}

int checked_apply_mod(log_ctx_t *log,
                      const char *path,
                      struct stat *st_original,
                      struct stat *st_new)
{
  if (!st_original || ! st_new)
    return -1;

  if (st_original->st_mode != st_new->st_mode)
    return apply_mod(log, path, st_new);

  return 0;
}

int apply_flags(log_ctx_t *log,
                const char *path,
                struct stat *st_new)
{
  if (!st_new)
    return -1;

  if (chflags(path, st_new->st_flags) < 0) {
    log_message_errno(
      log,
      LOG_LEVEL_ERROR,
      "Impossibile eseguire chflags di \"%s\"",
      path
    );
    return -1;
  }

  return 0;
}

int checked_apply_flags(log_ctx_t *log,
                        const char *path,
                        struct stat *st_original,
                        struct stat *st_new)
{
  if (!st_original || ! st_new)
    return -1;

  if (st_original->st_flags != st_new->st_flags)
    return apply_flags(log, path, st_new);

  return 0;
}

void peanut_set(log_ctx_t *log,
                const char *path_hfs,
                const char *mode_string,
                int *result)
{
	typedef enum {
		OP_APPLY_FIRST_FLAGS,
		OP_APPLY_FIRST_PERMISSIONS,
		OP_APPLY_FLAGS_AND_PERMISSIONS_WITH_TRICK,
	} op_t;

	*result = 1;

	char *path = util_hfs_path_to_posix_path(log, path_hfs);
	if (!path) {
		*result = 0;
		return;
	}

	struct stat st_original;
	if (stat(path, &st_original) < 0) {
		log_message_errno(
			log,
			LOG_LEVEL_ERROR,
			"Impossibile eseguire stat di \"%s\"",
			path
		);
		*result = 0;
		free(path);
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
	int locked_change = (   (st_original.st_flags & UF_IMMUTABLE)
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
		case OP_APPLY_FIRST_FLAGS:
			if (checked_apply_flags(log, path, &st_original, &st_new) < 0)
				*result = 0;
			if (checked_apply_mod(log, path, &st_original, &st_new) < 0)
				*result = 0;
		break;
		case OP_APPLY_FIRST_PERMISSIONS:
			if (checked_apply_mod(log, path, &st_original, &st_new) < 0)
				*result = 0;
			if (checked_apply_flags(log, path, &st_original, &st_new) < 0)
				*result = 0;
		break;
		case OP_APPLY_FLAGS_AND_PERMISSIONS_WITH_TRICK:
			/* trick
			   a) togliamo il locked
			   b) cambiamo i permessi
			   c) rimettiamo il locked */
			st_new.st_flags &= ~UF_IMMUTABLE;
			if (apply_flags(log, path, &st_new) < 0)
				*result = 0;
			if (checked_apply_mod(log, path, &st_original, &st_new) < 0)
				*result = 0;
			st_new.st_flags |= UF_IMMUTABLE;
			if (apply_flags(log, path, &st_new) < 0)
				*result = 0;
		break;
	}

	free(path);
}

