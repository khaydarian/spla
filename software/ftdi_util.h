// vi: ts=2:sw=2:sts=2:noet

#ifndef FTDI_UTIL_H
#define FTDI_UTIL_H

#include "ftdi.h"
#include "status.h"

extern struct ftdi_context* ftdi;

status ftdiutil_init();
void ftdiutil_deinit();

status ftdiutil_error(const char* fn, int ret);

void ftdiutil_write_data(unsigned char* data, int size);
int ftdiutil_flush_data();
int ftdiutil_read_data(unsigned char* data, int size);

#endif
