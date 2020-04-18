// vi: ts=2:sw=2:sts=2:noet
#include <stdio.h>
#include <stdbool.h>
#include <unistd.h>
#include <string.h>
#include <ftdi.h>
#include <libusb.h>

const char* invoked_as;

typedef int (*command_fn)(int,char**);

struct command {
	const char* name;
	command_fn fn;
	const char* desc;
};

struct command all_commands[];

struct command* find_command(const char* name) {
	for (int i = 0; all_commands[i].name; i++) {
		if (strcmp(name, all_commands[i].name) == 0) {
			return &all_commands[i];
		}
	}
	return NULL;
}

static int help_command_list() {
	fprintf(stderr, "usage: %s <global-options> [subcommand] <options...>\n", invoked_as);
	fprintf(stderr, "global-options:\n");
	fprintf(stderr, "  (none)\n"); // TODO add table here
	fprintf(stderr, "subcommands:\n");
	for (int i = 0; all_commands[i].name; i++) {
		fprintf(stderr, "  %-12s  %s\n",
				all_commands[i].name, all_commands[i].desc);
	}
	return 1;
}

static int help(int argc, char** argv) {
	if (argc == 0) {
		return help_command_list();
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
	return 1;
}

static inline void show_ftdi_error(const char* fn,
		struct ftdi_context* ftdi, int ret) {
	fprintf(stderr, "%s: error %d: %s\n",
			fn, ret, ftdi_get_error_string(ftdi));
}

static int show_ftdi(int argc, char** argv) {
	// TODO handle per-command arguments
	(void) argc;
	(void) argv;

	struct ftdi_context* ftdi = ftdi_new();
	if (!ftdi) {
		fprintf(stderr, "Error opening FTDI context.\n");
		return 1;
	}

	libusb_set_debug(ftdi->usb_ctx, LIBUSB_LOG_LEVEL_ERROR);

	struct ftdi_device_list* devlist;
	int ret = ftdi_usb_find_all(ftdi, &devlist, 0, 0);
	if (ret < 0) {
		show_ftdi_error("ftdi_usb_find_all", ftdi, ret);
		ftdi_free(ftdi);
		return 1;
	}

	printf("Found %d FTDI device%s:\n", ret, (ret == 1 ? "" : "s"));

	char manufacturer[256];
	char description[256];
	char serial[256];

	int i = 0;
	for (struct ftdi_device_list* cur = devlist; cur; cur = cur->next, i++) {
		printf("Device #%d:\n", i);
		ret = ftdi_usb_get_strings(ftdi, cur->dev,
				manufacturer, sizeof(manufacturer),
				description, sizeof(description),
				serial, sizeof(serial));
		if (ret < 0) {
			show_ftdi_error("ftdi_usb_get_strings", ftdi, ret);
			ftdi_list_free(&devlist);
			ftdi_free(ftdi);
			return 1;
		}
		printf("  Manufacturer: %s\n", manufacturer);
		printf("  Description:  %s\n", description);
		printf("  Serial:       %s\n", serial);
	}

	ftdi_list_free(&devlist);
	ftdi_free(ftdi);
	return 0;
}

#define FTDI_VENDOR_ID 0x0403
#define FTDI_PRODUCT_ID 0x6014

int test_ftdi_toggle(int argc, char** argv) {
	// TODO handle per-command arguments
	(void) argc;
	(void) argv;

	struct ftdi_context* ftdi = ftdi_new();
	if (!ftdi) {
		fprintf(stderr, "Error opening FTDI context.\n");
		return 1;
	}

	int ret = ftdi_usb_open_desc(ftdi, FTDI_VENDOR_ID, FTDI_PRODUCT_ID,
			"C232HM-DDHSL-0", "FT0J7C2U");
	if (ret) {
		show_ftdi_error("ftdi_usb_open_desc", ftdi, ret);
		ftdi_free(ftdi);
		return 1;
	}

	ret = ftdi_set_bitmode(ftdi, 0xFF, BITMODE_BITBANG);
	if (ret) {
		show_ftdi_error("ftdi_set_bitmode", ftdi, ret);
	} else {
		unsigned char buf[1];

		for (int i = 0; i < 10; i++) {
			printf("On\n");
			buf[0] = 0xFF;
			ret = ftdi_write_data(ftdi, buf, 1);
			if (ret < 0) {
				show_ftdi_error("ftdi_write_data", ftdi, ret);
			}
			usleep(1000000);
			printf("Off\n");
			buf[0] = 0x0;
			ret = ftdi_write_data(ftdi, buf, 1);
			if (ret < 0) {
				show_ftdi_error("ftdi_write_data", ftdi, ret);
			}
			usleep(1000000);
		}
	}

	ret = ftdi_usb_close(ftdi);
	if (ret) {
		show_ftdi_error("ftdi_usb_close", ftdi, ret);
	}

	ftdi_free(ftdi);
	return 0;
}

int global_flag(int argc, char** argv) {
	// TODO parse global flags here, and not just skip over them
	(void) argc;
	(void) argv;
	return 1;
}

struct command all_commands[] = {
	{
		"help", help,
		"Show command listing, or options.",
	},
	{
		"show_ftdi", show_ftdi,
		"Show all relevant devices connected by USB.",
	},
	{
		"test_ftdi_toggle", test_ftdi_toggle,
		"Test FTDI interface by toggling GPIOs.",
	},
	{0, 0, 0},
};

int invoke_command(int argc, char** argv) {
	const char* command_name = argv[0];
	struct command* cmd = find_command(command_name);
	if (cmd) {
		return cmd->fn(argc - 1, argv + 1);
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
	return help(argc, argv);
}
