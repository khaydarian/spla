// vi: ts=2:sw=2:sts=2:et

#ifndef FTDI_UTIL_H
#define FTDI_UTIL_H

#include "ftdi.h"
#include "status.h"

extern struct ftdi_context* ftdi;

void ftdiutil_debug_logging(bool enable);

status ftdiutil_init() __attribute__((warn_unused_result));
void ftdiutil_deinit();

status ftdiutil_error(const char* fn, int ret)
    __attribute__((warn_unused_result));

void ftdiutil_set_default_usb_device(const char* which);
void ftdiutil_set_usb_device(const char* which);
status ftdiutil_open_usb() __attribute__((warn_unused_result));
status ftdiutil_close_usb() __attribute__((warn_unused_result));
void ftdiutil_set_interface(enum ftdi_interface interface);

const char* ftdiutil_channel_type_name(int channel_type);

status ftdiutil_set_bitmode_bitbang(unsigned char outputs)
    __attribute__((warn_unused_result));
status ftdiutil_set_bitmode_mpsse(unsigned char outputs)
    __attribute__((warn_unused_result));
status ftdiutil_set_bitmode_uart() __attribute__((warn_unused_result));
status ftdiutil_set_bitmode_syncff(unsigned char outputs)
    __attribute__((warn_unused_result));

int ftdiutil_describe(struct ftdi_context* ftdi, struct libusb_device* dev,
                      char* manufacturer, int manufacturer_len,
                      char* description, int description_len, char* serial,
                      int serial_len);

void ftdiutil_write_data(unsigned char* data, int size);
status ftdiutil_flush_writes(const char* caller)
    __attribute__((warn_unused_result));

void ftdiutil_read_data(unsigned char* data, int size);
status ftdiutil_flush_reads(const char* caller)
    __attribute__((warn_unused_result));

#endif
