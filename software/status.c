// vi: ts=2:sw=2:sts=2:noet

#include "status.h"

#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>
#include <string.h>

status errorf(const char* format, ...) {
	char buf[4096];
	va_list v;
	va_start(v, format);
	vsprintf(buf, format, v);
	va_end(v);
	status s = (struct status_s*)malloc(sizeof(struct status_s));
	s->message = strdup(buf);
	return s;
}

void status_free(status s) {
	if (s) {
		if (s->message) {
			free((void*)s->message);
			s->message = NULL;
		}
		free(s);
	}
}

void status_ignore(status s) {
	if (s != OK) {
		fprintf(stderr, "%s\n", s->message);
	}
	status_free(s);
}
