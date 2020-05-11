// vi: ts=2:sw=2:sts=2:noet

#ifndef MPSSE_H
#define MPSSE_H

#include "status.h"

status mpsse_init();

status mpsse_deinit();

status mpsse_set_frequency(const char* frequency_str);

void mpsse_loopback(bool enabled);

void mpsse_set_data_bits_low(unsigned char bits);

void mpsse_chip_select(bool select);

void mpsse_clock_only(int bytes);

void mpsse_write_data(unsigned char* data, int bytes);

void mpsse_read_data(unsigned char* data, int bytes);

#endif
