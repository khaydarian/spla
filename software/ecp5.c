// vi: ts=2:sw=2:sts=2:et

#include "ecp5.h"

#include <stdio.h>
#include <unistd.h>
#include "ftdiutil.h"
#include "mpsse.h"

// BDBUS (B-interface low)
#define SPI_CLK_BIT 0x01
#define SPI_MOSI_BIT 0x02
#define SPI_MISO_BIT 0x04
#define SPI_CSN_BIT 0x08
#define DONE_BIT 0x10
#define INITN_BIT 0x20
#define PROGRAMN_BIT 0x40

// BCBUS (B-interface high)
#define LED3_BIT 0x01
#define JTAG_TCK 0x10
#define JTAG_TDI 0x20
#define JTAG_TDO 0x40
#define JTAG_TMS 0x80

status ecp5_init() {
  // Interface A is not used yet; tristate all pins.
  ftdiutil_set_interface(INTERFACE_A);
  RETURN_IF_ERROR(mpsse_init());
  RETURN_IF_ERROR(mpsse_set_frequency("1MHz"));
  mpsse_set_data_bits_low_dir(0xff, 0, 0);
  mpsse_set_data_bits_high_dir(0xff, 0, 0);

  // Set interface B appropriately.
  ftdiutil_set_interface(INTERFACE_B);
  RETURN_IF_ERROR(mpsse_init());
  RETURN_IF_ERROR(mpsse_set_frequency("1MHz"));
  mpsse_set_data_bits_low_dir(
      0xff,
      /*dir*/ SPI_CLK_BIT | SPI_MOSI_BIT | SPI_CSN_BIT | PROGRAMN_BIT,
      /*val*/ SPI_CSN_BIT);
  mpsse_set_data_bits_high_dir(0xff,
                               /*dir*/ JTAG_TCK | JTAG_TDI | JTAG_TMS,
                               /*val*/ JTAG_TMS);
  // Leave interface B enabled.

  RETURN_IF_ERROR(ftdiutil_flush_writes(NULL));
  return OK;
}

void ecp5_set_led3(bool active) {
  mpsse_set_data_bits_high_dir(LED3_BIT, LED3_BIT, active ? LED3_BIT : 0);
}

void ecp5_set_program(bool active) {
  mpsse_set_data_bits_low_dir(PROGRAMN_BIT, PROGRAMN_BIT,
                              active ? 0 : PROGRAMN_BIT);
}

void ecp5_set_hold(bool active) {
  (void)active;
  // Oversight! This pin isn't connected, and really should be.
}

status ecp5_reset() {
  // Drive PROGRAMN high for 5ms to make sure we're in a known state.
  ecp5_set_program(false);
  ecp5_set_led3(false);
  mpsse_chip_select(false);
  RETURN_IF_ERROR(ftdiutil_flush_writes("ecp5_set_program"));
  usleep(5000);
  // usleep(1000000);

  // Disable HOLD (we don't need it);
  ecp5_set_hold(false);

  // Drive PROGRAMN low to reset and enable programming mode.
  ecp5_set_program(true);
  ecp5_set_led3(true);
  RETURN_IF_ERROR(ftdiutil_flush_writes("ecp5_set_program"));

  // Wait 50ms (plus a bit of padding) to complete reset.
  usleep(60000);
  // usleep(1000000);
  return OK;
}

status ecp5_release_reset() {
  ecp5_set_program(false);
  ecp5_set_led3(false);
  RETURN_IF_ERROR(ftdiutil_flush_writes("ecp5_release_reset"));
  return OK;
}

static status class_a_op(uint8_t opcode, uint32_t param, uint32_t* val,
                         const char* name) {
  uint8_t wr[4];
  wr[0] = opcode;
  wr[1] = (param >> 16) & 0xff;
  wr[2] = (param >> 8) & 0xff;
  wr[3] = param & 0xff;
  uint8_t rd[4];
  mpsse_chip_select(true);
  mpsse_write_data(wr, sizeof(wr));
  mpsse_read_data(rd, sizeof(rd));
  mpsse_chip_select(false);
  RETURN_IF_ERROR(ftdiutil_flush_reads(name));
  // Return ID as big-endian uint32_t.
  *val = ((rd[0] << 24) | (rd[1] << 16) | (rd[2] << 8) | rd[3]);
  return OK;
}

static status class_b_op(uint8_t opcode, uint32_t param, uint32_t val,
                         const char* name) {
  uint8_t wr[8];
  wr[0] = opcode;
  wr[1] = (param >> 16) & 0xff;
  wr[2] = (param >> 8) & 0xff;
  wr[3] = param & 0xff;
  wr[4] = (val >> 24) & 0xff;
  wr[5] = (val >> 16) & 0xff;
  wr[6] = (val >> 8) & 0xff;
  wr[7] = val & 0xff;
  mpsse_chip_select(true);
  mpsse_write_data(wr, sizeof(wr));
  mpsse_chip_select(false);
  RETURN_IF_ERROR(ftdiutil_flush_writes(name));
  return OK;
}

#define ECP5_OPCODE_READ_ID 0xE0
#define ECP5_OPCODE_USERCODE 0xC0
#define ECP5_OPCODE_PROGRAM_USERCODE 0xC2

status ecp5_read_id(uint32_t* id) {
  return class_a_op(ECP5_OPCODE_READ_ID, 0, id, "ecp5_read_id");
}

status ecp5_usercode(uint32_t* usercode) {
  return class_a_op(ECP5_OPCODE_USERCODE, 0, usercode, "ecp5_usercode");
}

status ecp5_program_usercode(uint32_t usercode) {
  return class_b_op(ECP5_OPCODE_PROGRAM_USERCODE, 0, usercode,
                    "ecp5_program_usercode");
}
