// vi: ts=2:sw=2:sts=2:noet

#ifndef COMMAND_H
#define COMMAND_H

#include "status.h"

typedef status (*command_fn)(int,char**);

struct command {
	const char* name;
	command_fn fn;
	const char* desc;
};

extern const char* invoked_as;

struct command* find_command(const char* name);

// Individual commands
status usage();
status help(int argc, char** argv);
status ftdi_list_devices(int argc, char** argv);
status ftdi_test_toggle(int argc, char** argv);
status ftdi_test_spi(int argc, char** argv);
status ftdi_test_raw(int argc, char** argv);

#endif
