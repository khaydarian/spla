// vi: ts=2:sw=2:sts=2:et

#include <stdio.h>
#include <string.h>

#include "command.h"

const char* invoked_as;

struct command* all_commands;

struct command* find_command(const char* name) {
  for (int i = 0; all_commands[i].name; i++) {
    if (strcmp(name, all_commands[i].name) == 0) {
      return &all_commands[i];
    }
  }
  return NULL;
}

// TODO fix this hacky way of showing global flags
void global_flag_usage();

status no_arguments(int argc, char** argv) {
  if (argc > 0) {
    return errorf("No arguments accepted (got '%s'...).", argv[0]);
  }
  return OK;
}

status usage() {
  fprintf(stderr, "usage: %s <global-options> [subcommand] <options...>\n",
          invoked_as);
  fprintf(stderr, "global-options:\n");
  global_flag_usage();
  fprintf(stderr, "subcommands:\n");
  for (int i = 0; all_commands[i].name; i++) {
    fprintf(stderr, "  %-24s  %s\n", all_commands[i].name,
            all_commands[i].desc);
  }
  return OK;
}
