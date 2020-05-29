// vi: ts=2:sw=2:sts=2:et

#ifndef FTDI_UTIL_H
#define FTDI_UTIL_H

#include "ftdi.h"
#include "status.h"

extern struct ftdi_context* ftdi;

void ftdiutil_debug_logging(bool enable);

status ftdiutil_init();
void ftdiutil_deinit();

status ftdiutil_error(const char* fn, int ret);

void ftdiutil_set_default_usb_device(const char* which);
void ftdiutil_set_usb_device(const char* which);
status ftdiutil_open_usb();
status ftdiutil_close_usb();
status ftdiutil_set_interface(enum ftdi_interface interface);

int ftdiutil_describe(struct ftdi_context* ftdi, struct libusb_device* dev,
                      char* manufacturer, int manufacturer_len,
                      char* description, int description_len, char* serial,
                      int serial_len);

void ftdiutil_write_data(unsigned char* data, int size);
status ftdiutil_flush_writes(const char* caller);

void ftdiutil_read_data(unsigned char* data, int size);
status ftdiutil_flush_reads(const char* caller);

#endif
