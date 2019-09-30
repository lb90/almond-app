#import "../peanut.h"
#import "../log.h"

#import <stdlib.h>
#import <string.h>
#import <stdio.h>

typedef enum {
	operation_get,
	operation_set
} operation_t;

operation_t operation;
char *mode_string; /* only used for operation_set */
char *file_path;

void log_print(const char *message, void *data) {
	printf("%s\n", message);
}

void print_invalid_arguments(const char *arg_0) {
	printf("Usage: %s [set/get] [rwhvls] path\n", arg_0);
}

int detect_args(int argc, char **argv) {
	if (argc >= 2) {
		if (strcmp(argv[1], "get") == 0)
			operation = operation_get;
		else if (strcmp(argv[1], "set") == 0)
			operation = operation_set;
		else return -1;

		if (operation == operation_get) {
			if (argc == 3) {
				file_path = argv[2];
			}
			else return -1;
		}
		else if (operation == operation_set) {
			if (argc == 4) {
				mode_string = argv[2];
				file_path = argv[3];
			}
			else return -1;
		}
	}
	else return -1;

	return 0;
}

int main(int argc, char **argv) {
	if (detect_args(argc, argv) < 0) {
		print_invalid_arguments(argv[0]);
		return -1;
	}

	log_ctx_t log = {
		.level = LOG_LEVEL_DEBUG,
		.func = log_print,
		.data = NULL
	};

	if (operation == operation_get) {
		char *result = NULL;

		peanut_get(&log, file_path, &result);

		if (result) {
			printf("%s\n", result);
			free(result);
		}
		else {
			printf("error\n");
		}
	}
	else if (operation == operation_set) {
		int result = 0;

		peanut_set(&log, file_path, mode_string, &result);

		printf("%d\n", result);
	}

	return 0;
}

