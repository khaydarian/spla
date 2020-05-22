// vi: ts=2:sw=2:sts=2:noet

#ifndef STATUS_H
#define STATUS_H

#include <stdbool.h>

struct status_s {
	const char* message;
};
typedef struct status_s* status;

#define OK ((status)0)
status errorf(const char* format, ...);
#define RETURN_IF_ERROR(what) { status err = what; if (is_error(err)) return err; }

#define is_error(s) ((s) != OK)

void status_free(status s);
void status_ignore(status s);

#endif
