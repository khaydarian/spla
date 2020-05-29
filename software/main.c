// vi: ts=2:sw=2:sts=2:noet

#include <stdio.h>
#include <stdbool.h>
#include <unistd.h>
#include <string.h>

#include "command.h"
#include "ftdiutil.h"

status global_flag(int argc, char** argv, int* absorbed) {
	if (!strcmp(argv[0], "--device")) {
		if (argc < 2) {
			return errorf("Missing argument to '--device'.");
		} else {
			// TODO: Parse some format in ftdiutil_set_usb_device
			// TODO: fix this flag to match ftdi_list_devices
			ftdiutil_set_usb_device(argv[1]);
			*absorbed = 2;
			return OK;
		}
	}
	if (!strcmp(argv[0], "--debug")) {
		ftdiutil_debug_logging(true);
		*absorbed = 1;
		return OK;
	}
	return errorf("Unknown flag: %s", argv[0]);
}

void global_flag_usage() {
	fprintf(stderr, "  %-24s  %s\n", "--device", "Select FTDI USB device to use.");
}

static status invoke_command(int argc, char** argv) {
	const char* command_name = argv[0];
	struct command* cmd = find_command(command_name);
	if (!cmd) {
		return errorf("Unknown subcommand \"%s\". Try \"%s help\".\n",
				command_name, invoked_as);
	}
	RETURN_IF_ERROR(ftdiutil_init());
	status err;
	if (cmd->default_usb_device) {
		ftdiutil_set_default_usb_device(cmd->default_usb_device);
	}
	if (cmd->open_usb) {
		RETURN_IF_ERROR(ftdiutil_open_usb());
	}
	err = cmd->fn(argc - 1, argv + 1);
	if (cmd->open_usb) {
		status_ignore(ftdiutil_close_usb());
	}
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
			int absorbed;
			status err = global_flag(argc, argv, &absorbed);
			if (is_error(err)) {
				fprintf(stderr, "%s\n", err->message);
				status_free(err);
				return 1;
			}
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
