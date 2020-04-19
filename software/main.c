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

int invoke_command(int argc, char** argv) {
	const char* command_name = argv[0];
	struct command* cmd = find_command(command_name);
	if (cmd) {
		ftdiutil_init();
		if (!ftdi) {
			return 1;
		}
		int ret = cmd->fn(argc - 1, argv + 1);
		ftdiutil_deinit();
		return ret;
	} else {
		fprintf(stderr, "Unknown subcommand \"%s\". Try \"%s help\".\n",
				command_name, invoked_as);
		return 1;
	}
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
			return invoke_command(argc, argv);
		}
	}
	return usage();
}
