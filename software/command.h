// vi: ts=2:sw=2:sts=2:noet

#ifndef COMMAND_H
#define COMMAND_H

#include "status.h"

typedef status (*command_fn)(int,char**);

struct command {
	const char* name;
	command_fn fn;
	const char* desc;
	bool open_usb;
	const char* default_usb_device;
};

extern const char* invoked_as;

struct command* find_command(const char* name);

status no_arguments(int argc, char** argv);

status usage();

#endif
