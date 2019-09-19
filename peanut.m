#import <Cocoa/Cocoa.h>
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
	*result = NULL;

/*	NSString *file_name_ns = [NSString stringWithUTF8String:file_name];
	NSFileManager *file_manager = [NSFileManager defaultManager];
	NSError *error = NULL;
	NSDictionary *attributes = [file_manager attributesOfItemAtPath:file_name_ns error:&error];

	struct stat st;
	stat(file_name, &st);

	

	*result = ;*/
}

void peanut_set(const char *file_name, const char *mode_string, int *result)
{
	*result = 1;

	struct stat st;
	if (stat(file_name, &st) < 0) { /* for file flags (hidden, immutable) */
		*result = 0;
		return;
	}

	size_t mode_string_length = strlen(mode_string);
	if (mode_string_length == 0) {
		/* fai un reset di tutto */
		st.st_flags &= ~(UF_HIDDEN | UF_IMMUTABLE);
		/*TODO r/w*/
	}
	else {
		for (size_t i = 0; i < mode_string_length; i++) {
			char a = mode_string[i];

			switch (a) {
				case 'r':
				break;
				case 'w':
				break;
				case 'h': st.st_flags |= UF_HIDDEN;
				break;
				case 'v': st.st_flags &= ~UF_HIDDEN;
				break;
				case 'l': st.st_flags |= UF_IMMUTABLE;
				break;
				case 's': st.st_flags &= ~UF_IMMUTABLE;
				break;
			}
		}
	}

	if (chflags(file_name, st.st_flags) < 0) { /*TODO check return value */
		*result = 0;
		return; /*TODO potremmo anche andare avanti */
	}
/*
	NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
*/
	/* set attributes */
/*	[attributes setObject:[NSNumber numberWithInt:1] forKey:NSFileImmutable];

	NSString *file_name_ns = [NSString stringWithUTF8String:file_name];
	NSFileManager *file_manager = [NSFileManager defaultManager];
	NSError *error = NULL;
	BOOL success = [file_manager setAttributes:attributes ofItemAtPath:file_name_ns error:&error];

	if (success && !error)
	{
	}
	else
	{
	}*/
}

