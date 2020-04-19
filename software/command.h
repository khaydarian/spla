// vi: ts=2:sw=2:sts=2:noet

#ifndef COMMAND_H
#define COMMAND_H

typedef int (*command_fn)(int,char**);

struct command {
	const char* name;
	command_fn fn;
	const char* desc;
};

extern const char* invoked_as;

struct command* find_command(const char* name);

// Individual commands
int usage();
int help(int argc, char** argv);
int ftdi_list_devices(int argc, char** argv);
int ftdi_test_toggle(int argc, char** argv);

#endif
