// vi: ts=2:sw=2:sts=2:et

#include "mpsse.h"

#include <assert.h>
#include <unistd.h>
#include "freq_util.h"
#include "ftdiutil.h"

#define BIT_CLOCK 0x01
#define BIT_MOSI 0x02
#define BIT_MISO 0x04
#define BIT_CS 0x08
#define BIT_GPIOL0 0x10
#define BIT_GPIOL1 0x20
#define BIT_GPIOL2 0x40
#define BIT_GPIOL3 0x80

// See FTDI document AN-108 for MPSSE protocol details.

#define ERR_BAD_COMMAND 0xFA

#define CMD_SET_DATA_BITS_LO 0x80
#define CMD_SET_DATA_BITS_HI 0x82
#define CMD_READ_DATA_BITS_LO 0x81
#define CMD_READ_DATA_BITS_HI 0x83
#define CMD_LOOPBACK_ENABLE 0x84
#define CMD_LOOPBACK_DISABLE 0x85
#define CMD_SET_CLOCK_DIVISOR 0x86
#define CMD_SEND_IMMEDIATE 0x87
#define CMD_CLOCK_DIV5_DISABLE 0x8A
#define CMD_CLOCK_DIV5_ENABLE 0x8B
#define CMD_CLOCK_FOR_N_BITS 0x8E
#define CMD_CLOCK_FOR_N_BYTES 0x8F

#define CMD_TRANSFER_OUT_NEG_EDGE 0x01
#define CMD_TRANSFER_OUT_POS_EDGE 0x00
#define CMD_TRANSFER_BYTE_MODE 0x00
#define CMD_TRANSFER_BIT_MODE 0x02
#define CMD_TRANSFER_IN_NEG_EDGE 0x04
#define CMD_TRANSFER_IN_POS_EDGE 0x00
#define CMD_TRANSFER_LSB_FIRST 0x08
#define CMD_TRANSFER_MSB_FIRST 0x00
#define CMD_TRANSFER_WRITE 0x10
#define CMD_TRANSFER_READ 0x20

static unsigned char data_bits_lo_dir = BIT_CS | BIT_CLOCK | BIT_MOSI;
static unsigned char data_bits_lo_val = BIT_CS;
static unsigned char data_bits_hi_dir = 0;
static unsigned char data_bits_hi_val = 0;

static void flush_data_bits_lo() {
  unsigned char buf[3];
  buf[0] = CMD_SET_DATA_BITS_LO;
  buf[1] = data_bits_lo_val;
  buf[2] = data_bits_lo_dir;
  ftdiutil_write_data(buf, sizeof(buf));
}

static void flush_data_bits_hi() {
  unsigned char buf[3];
  buf[0] = CMD_SET_DATA_BITS_HI;
  buf[1] = data_bits_hi_val;
  buf[2] = data_bits_hi_dir;
  ftdiutil_write_data(buf, sizeof(buf));
}

status mpsse_init() {
  RETURN_IF_ERROR(ftdiutil_set_bitmode_mpsse(0));
  // data_bits_lo_dir = BIT_CS | BIT_CLOCK | BIT_MOSI;
  // data_bits_lo_val = BIT_CS;
  // flush_data_bits_lo();
  // RETURN_IF_ERROR(ftdiutil_flush_writes("flush_data_bits_lo"));
  return OK;
}

status mpsse_deinit() { return OK; }

status mpsse_set_frequency(const char* frequency_str) {
  bool div5;
  int divisor;
  RETURN_IF_ERROR(parse_frequency(frequency_str, &div5, &divisor));

  // Set div5 state
  unsigned char buf[3];
  buf[0] = (div5 ? CMD_CLOCK_DIV5_ENABLE : CMD_CLOCK_DIV5_DISABLE);
  ftdiutil_write_data(buf, 1);

  // Set divisor
  buf[0] = CMD_SET_CLOCK_DIVISOR;
  buf[1] = (divisor >> 0) & 0xff;
  buf[2] = (divisor >> 8) & 0xff;
  ftdiutil_write_data(buf, sizeof(buf));

  return OK;
}

void mpsse_loopback(bool enabled) {
  unsigned char buf[1];
  buf[0] = enabled ? CMD_LOOPBACK_ENABLE : CMD_LOOPBACK_DISABLE;
  ftdiutil_write_data(buf, sizeof(buf));
}

void mpsse_set_data_bits_low(unsigned char bits) {
  data_bits_lo_val = bits;
  flush_data_bits_lo();
}

void mpsse_set_data_bits_low_dir(unsigned char mask, unsigned char dir,
                                 unsigned char val) {
  data_bits_lo_dir = (data_bits_lo_dir & ~mask) | (dir & mask);
  data_bits_lo_val = (data_bits_lo_val & ~mask) | (val & mask);
  flush_data_bits_lo();
}

void mpsse_set_data_bits_high_dir(unsigned char mask, unsigned char dir,
                                  unsigned char val) {
  data_bits_hi_dir = (data_bits_hi_dir & ~mask) | (dir & mask);
  data_bits_hi_val = (data_bits_hi_val & ~mask) | (val & mask);
  flush_data_bits_hi();
}

void mpsse_chip_select(bool select) {
  data_bits_lo_val = (data_bits_lo_val & ~BIT_CS) | (select ? 0 : BIT_CS);
  flush_data_bits_lo();
}

void mpsse_get_data_bits_low(unsigned char* val) {
  unsigned char buf[1];
  buf[0] = CMD_READ_DATA_BITS_LO;
  ftdiutil_write_data(buf, sizeof(buf));
  ftdiutil_read_data(val, sizeof(*val));
}

void mpsse_get_data_bits_high(unsigned char* val) {
  unsigned char buf[1];
  buf[0] = CMD_READ_DATA_BITS_HI;
  ftdiutil_write_data(buf, sizeof(buf));
  ftdiutil_read_data(val, sizeof(*val));
}

void mpsse_clock_only(int bytes) {
  assert(bytes <= 65536);
  unsigned char buf[3];
  buf[0] = CMD_CLOCK_FOR_N_BYTES;
  buf[1] = ((bytes - 1) >> 0) & 0xFF;
  buf[2] = ((bytes - 1) >> 8) & 0xFF;
  ftdiutil_write_data(buf, sizeof(buf));
}

void mpsse_write_data(unsigned char* data, int bytes) {
  assert(bytes <= 65536);
  unsigned char opcode = CMD_TRANSFER_WRITE;
  opcode |= CMD_TRANSFER_BYTE_MODE;
  opcode |= CMD_TRANSFER_OUT_NEG_EDGE;
  opcode |= CMD_TRANSFER_IN_NEG_EDGE;
  opcode |= CMD_TRANSFER_MSB_FIRST;
  unsigned char buf[3];
  buf[0] = opcode;
  buf[1] = ((bytes - 1) >> 0) & 0xff;
  buf[2] = ((bytes - 1) >> 8) & 0xff;
  ftdiutil_write_data(buf, sizeof(buf));
  ftdiutil_write_data(data, bytes);
}

void mpsse_read_data(unsigned char* data, int bytes) {
  assert(bytes <= 65536);
  unsigned char opcode = CMD_TRANSFER_READ;
  opcode |= CMD_TRANSFER_BYTE_MODE;
  opcode |= CMD_TRANSFER_OUT_NEG_EDGE;
  opcode |= CMD_TRANSFER_IN_NEG_EDGE;
  opcode |= CMD_TRANSFER_MSB_FIRST;
  unsigned char buf[3];
  buf[0] = opcode;
  buf[1] = ((bytes - 1) >> 0) & 0xff;
  buf[2] = ((bytes - 1) >> 8) & 0xff;
  ftdiutil_write_data(buf, sizeof(buf));
  ftdiutil_read_data(data, bytes);
}

void mpsse_transfer_data(unsigned char* write, unsigned char* read, int bytes) {
  assert(bytes <= 65536);
  unsigned char opcode = CMD_TRANSFER_READ | CMD_TRANSFER_WRITE;
  opcode |= CMD_TRANSFER_BYTE_MODE;
  opcode |= CMD_TRANSFER_OUT_NEG_EDGE;
  opcode |= CMD_TRANSFER_IN_NEG_EDGE;
  opcode |= CMD_TRANSFER_MSB_FIRST;
  unsigned char buf[3];
  buf[0] = opcode;
  buf[1] = ((bytes - 1) >> 0) & 0xff;
  buf[2] = ((bytes - 1) >> 8) & 0xff;
  ftdiutil_write_data(buf, sizeof(buf));
  ftdiutil_write_data(write, bytes);
  ftdiutil_read_data(read, bytes);
}
