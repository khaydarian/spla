// vi: ts=2:sw=2:sts=2:noet

#ifndef FTDI_UTIL_H
#define FTDI_UTIL_H

extern struct ftdi_context* ftdi;

void ftdiutil_init();
void ftdiutil_deinit();

void ftdiutil_error(const char* fn, struct ftdi_context* ftdi, int ret);

#endif
