// vi: ts=2:sw=2:sts=2:et

#ifndef MPSSE_H
#define MPSSE_H

#include "status.h"

status mpsse_init();

status mpsse_deinit();

status mpsse_set_frequency(const char* frequency_str);

void mpsse_loopback(bool enabled);

void mpsse_set_data_bits_low(unsigned char bits);
void mpsse_set_data_bits_low_dir(unsigned char mask, unsigned char dir,
                                 unsigned char val);
void mpsse_set_data_bits_high_dir(unsigned char mask, unsigned char dir,
                                  unsigned char val);

void mpsse_get_data_bits_low(unsigned char* val);
void mpsse_get_data_bits_high(unsigned char* val);

void mpsse_chip_select(bool select);

void mpsse_clock_only(int bytes);

void mpsse_write_data(unsigned char* data, int bytes);

void mpsse_read_data(unsigned char* data, int bytes);

void mpsse_transfer_data(unsigned char* write, unsigned char* read, int bytes);

#endif
