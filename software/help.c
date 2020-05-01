// vi: ts=2:sw=2:sts=2:noet

#include "command.h"

#include <stdio.h>

status help(int argc, char** argv) {
	if (argc == 0) {
		return usage();
	}
	if (argc == 1) {
		const char* command = argv[0];
		struct command* cmd = find_command(command);
		if (!cmd) {
			fprintf(stderr, "Unknown command '%s'.", command);
		} else {
			fprintf(stderr, "usage: %s %s <options...>\n", invoked_as, command);
			fprintf(stderr, "\n");
			fprintf(stderr, "%s\n", cmd->desc); // TODO replace with detailed help
			fprintf(stderr, "\n");
			fprintf(stderr, "options:\n");
			fprintf(stderr, "  (none)\n"); // TODO add table here
		}
	}
	return OK;
}
