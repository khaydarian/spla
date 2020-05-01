// vi: ts=2:sw=2:sts=2:noet

#include <stdio.h>
#include <stdbool.h>
#include <unistd.h>
#include <string.h>

#include "command.h"
#include "ftdi_util.h"

int global_flag(int argc, char** argv) {
	// TODO parse global flags here, and not just skip over them
	(void) argc;
	(void) argv;
	return 1;
}

static status invoke_command(int argc, char** argv) {
	const char* command_name = argv[0];
	struct command* cmd = find_command(command_name);
	if (!cmd) {
		return errorf("Unknown subcommand \"%s\". Try \"%s help\".\n",
				command_name, invoked_as);
	}
	RETURN_IF_ERROR(ftdiutil_init());
	status err = cmd->fn(argc - 1, argv + 1);
	ftdiutil_deinit();
	return err;
}

int main(int argc, char** argv) {
	// Skip over invoked filename
	invoked_as = argv[0];
	argc--;
	argv++;
	// Scan for arguments
	while (argc > 0) {
		const char* arg = argv[0];
		if (arg[0] == '-') {
			int absorbed = global_flag(argc, argv);
			argc -= absorbed;
			argv += absorbed;
		} else {
			status err = invoke_command(argc, argv);
			if (is_error(err)) {
				fprintf(stderr, "%s\n", err->message);
				status_free(err);
				return 1;
			}
			return 0;
		}
	}
	usage();
	return 0;
}
