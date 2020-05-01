// vi: ts=2:sw=2:sts=2:noet

#include <string.h>
#include <stdio.h>

#include "command.h"

const char* invoked_as;

static struct command all_commands[] = {
	{
		"help", help,
		"Show command listing, or options.",
	},
	{
		"ftdi_list_devices", ftdi_list_devices,
		"Show all relevant devices connected by USB.",
	},
	{
		"ftdi_test_raw", ftdi_test_raw,
		"Test FTDI interface with individual commands.",
	},
	{
		"ftdi_test_spi", ftdi_test_spi,
		"Test FTDI SPI interface.",
	},
	{
		"ftdi_test_toggle", ftdi_test_toggle,
		"Test FTDI interface by toggling GPIOs.",
	},
	{0, 0, 0},
}; 

struct command* find_command(const char* name) {
	for (int i = 0; all_commands[i].name; i++) {
		if (strcmp(name, all_commands[i].name) == 0) {
			return &all_commands[i];
		}
	}
	return NULL;
}

status usage() {
	fprintf(stderr, "usage: %s <global-options> [subcommand] <options...>\n", invoked_as);
	fprintf(stderr, "global-options:\n");
	fprintf(stderr, "  (none)\n"); // TODO add table here
	fprintf(stderr, "subcommands:\n");
	for (int i = 0; all_commands[i].name; i++) {
		fprintf(stderr, "  %-24s  %s\n",
				all_commands[i].name, all_commands[i].desc);
	}
	return OK;
}
