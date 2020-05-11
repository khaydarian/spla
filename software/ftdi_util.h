// vi: ts=2:sw=2:sts=2:noet

#ifndef FTDI_UTIL_H
#define FTDI_UTIL_H

#include "ftdi.h"
#include "status.h"

extern struct ftdi_context* ftdi;

status ftdiutil_init();
void ftdiutil_deinit();

status ftdiutil_error(const char* fn, int ret);

status ftdiutil_set_default_usb_device(const char* which);
status ftdiutil_set_usb_device(const char* which);
status ftdiutil_open_usb();
status ftdiutil_close_usb();

void ftdiutil_write_data(unsigned char* data, int size);
status ftdiutil_flush_writes(const char* caller);

void ftdiutil_read_data(unsigned char* data, int size);
status ftdiutil_flush_reads(const char* caller);

#endif
