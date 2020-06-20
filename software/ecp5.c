// vi: ts=2:sw=2:sts=2:et

#include "ecp5.h"

#include <assert.h>
#include <stdio.h>
#include <string.h>
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
  const char* frequency = "6MHz";

  // Interface A is not used yet; tristate all pins.
  ftdiutil_set_interface(INTERFACE_A);
  RETURN_IF_ERROR(mpsse_init());
  RETURN_IF_ERROR(mpsse_set_frequency(frequency));
  mpsse_set_data_bits_low_dir(0xff, 0, 0);
  mpsse_set_data_bits_high_dir(0xff, 0, 0);

  // Set interface B appropriately.
  ftdiutil_set_interface(INTERFACE_B);
  RETURN_IF_ERROR(mpsse_init());
  RETURN_IF_ERROR(mpsse_set_frequency(frequency));
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

status ecp5_reset() {
  // Drive PROGRAMN high for 5ms to make sure we're in a known state.
  ecp5_set_program(false);
  ecp5_set_led3(false);
  mpsse_chip_select(false);
  RETURN_IF_ERROR(ftdiutil_flush_writes("ecp5_set_program"));
  usleep(5000);
  // usleep(1000000);

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

#define ECP5_OPCODE_NOP 0xff
#define ECP5_OPCODE_READ_STATUS 0x3c
#define ECP5_OPCODE_READ_ID 0xe0
#define ECP5_OPCODE_VERIFY_ID 0xe2
#define ECP5_OPCODE_USERCODE 0xc0
#define ECP5_OPCODE_PROGRAM_USERCODE 0xc2
#define ECP5_OPCODE_RESET_CRC 0x3b
#define ECP5_OPCODE_INIT_ADDRESS 0x46
#define ECP5_OPCODE_PROGRAM_DONE 0x5e
#define ECP5_OPCODE_ISC_DISABLE 0x26
#define ECP5_OPCODE_ISC_ENABLE 0xc6
#define ECP5_OPCODE_ERASE 0x0e
#define ECP5_OPCODE_BITSTREAM_BURST 0x7a

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

static status class_c_op(uint8_t opcode, uint32_t param, const char* name) {
  uint8_t wr[4];
  wr[0] = opcode;
  wr[1] = (param >> 16) & 0xff;
  wr[2] = (param >> 8) & 0xff;
  wr[3] = param & 0xff;
  mpsse_chip_select(true);
  mpsse_write_data(wr, sizeof(wr));
  mpsse_chip_select(false);
  RETURN_IF_ERROR(ftdiutil_flush_writes(name));
  return OK;
}

static status class_d_op(uint8_t opcode, uint32_t param, const char* name) {
  RETURN_IF_ERROR(class_c_op(opcode, param, name));
  // TODO: Poll BUSY bit instead of just waiting.
  usleep(200000);
  return OK;
}

status ecp5_read_status(uint32_t* id) {
  return class_a_op(ECP5_OPCODE_READ_STATUS, 0, id, "ecp5_read_status");
}

#define ECP5_STATUS_TRANSPARENT (1 << 0)
#define ECP5_STATUS_JTAG_ACTIVE (1 << 4)
#define ECP5_STATUS_PWD_PROTECTION (1 << 5)
#define ECP5_STATUS_DECRYPT_ENABLE (1 << 7)
#define ECP5_STATUS_DONE (1 << 8)
#define ECP5_STATUS_ISC_ENABLE (1 << 9)
#define ECP5_STATUS_WRITE_ENABLE (1 << 10)
#define ECP5_STATUS_READ_ENABLE (1 << 11)
#define ECP5_STATUS_BUSY (1 << 12)
#define ECP5_STATUS_FAIL (1 << 13)
#define ECP5_STATUS_FEA_OTP (1 << 14)
#define ECP5_STATUS_DECRYPT_ONLY (1 << 15)
#define ECP5_STATUS_PWD_ENABLE (1 << 16)
#define ECP5_STATUS_ENCRYPTED_PREAMBLE (1 << 20)
#define ECP5_STATUS_STANDARD_PREAMBLE (1 << 21)
#define ECP5_STATUS_SPIM_FAIL1 (1 << 22)
#define ECP5_STATUS_BSE_ERROR(x) ((x >> 23) & 7)
#define ECP5_STATUS_EXECUTION_ERROR (1 << 26)
#define ECP5_STATUS_ID_ERROR (1 << 27)
#define ECP5_STATUS_INVALID_COMMAND (1 << 28)
#define ECP5_STATUS_SED_ERROR (1 << 29)
#define ECP5_STATUS_BYPASS_MODE (1 << 30)
#define ECP5_STATUS_FLOW_THROUGH_MODE (1 << 31)

status ecp5_error_status(uint32_t statusval) {
  char buf[1024] = {0};
  char* b = buf;
  if (statusval & ECP5_STATUS_BUSY) {
    b += sprintf(b, " Busy");
  }
  if (statusval & ECP5_STATUS_FAIL) {
    b += sprintf(b, " Fail");
  }
  if (statusval & ECP5_STATUS_SPIM_FAIL1) {
    b += sprintf(b, " SPIm-Fail1");
  }
  switch (ECP5_STATUS_BSE_ERROR(statusval)) {
    case 0:
      // No error
      break;
    case 1:
      b += sprintf(b, " BSE:Id-Error");
      break;
    case 2:
      b += sprintf(b, " BSE:Invalid-Command");
      break;
    case 3:
      b += sprintf(b, " BSE:CRC-Error");
      break;
    case 4:
      b += sprintf(b, " BSE:Preamble-Error");
      break;
    case 5:
      b += sprintf(b, " BSE:Aborted-by-User");
      break;
    case 6:
      b += sprintf(b, " BSE:Overflow");
      break;
    case 7:
      b += sprintf(b, " BSE:SDM-Error");
      break;
  }
  if (statusval & ECP5_STATUS_EXECUTION_ERROR) {
    b += sprintf(b, " Execution-Error");
  }
  if (statusval & ECP5_STATUS_ID_ERROR) {
    b += sprintf(b, " Id-Error");
  }
  if (statusval & ECP5_STATUS_INVALID_COMMAND) {
    b += sprintf(b, " Invalid-Command");
  }
  if (statusval & ECP5_STATUS_SED_ERROR) {
    b += sprintf(b, " SED-Error");
  }
  if (!buf[0]) {
    return OK;
  }
  return errorf("ECP5 Error: %s", &buf[1]);
}

status ecp5_check_status() {
  uint32_t statusval;
  RETURN_IF_ERROR(ecp5_read_status(&statusval));
  return ecp5_error_status(statusval);
}

bool ecp5_status_is_done(uint32_t statusval) {
  return (bool)(statusval & ECP5_STATUS_DONE);
}

bool ecp5_status_is_offline(uint32_t statusval) {
  return !(bool)(statusval & ECP5_STATUS_TRANSPARENT);
}

status ecp5_check_done() {
  uint32_t statusval;
  RETURN_IF_ERROR(ecp5_read_status(&statusval));
  RETURN_IF_ERROR(ecp5_error_status(statusval));
  if (!ecp5_status_is_done(statusval)) {
    ecp5_debug_status_dump(statusval);
    return errorf("ecp5 DONE bit not set");
  }
  return OK;
}

void ecp5_debug_status_dump(uint32_t statusval) {
  printf("Status 0x%08x:", statusval);
  if (statusval & ECP5_STATUS_TRANSPARENT) {
    printf(" Transparent");
  }
  if (statusval & ECP5_STATUS_JTAG_ACTIVE) {
    printf(" JTAG-Active");
  }
  if (statusval & ECP5_STATUS_PWD_PROTECTION) {
    printf(" PWD-Protection");
  }
  if (statusval & ECP5_STATUS_DECRYPT_ENABLE) {
    printf(" Decrypt-Enable");
  }
  if (statusval & ECP5_STATUS_DONE) {
    printf(" DONE");
  }
  if (statusval & ECP5_STATUS_ISC_ENABLE) {
    printf(" ISC-Enable");
  }
  if (statusval & ECP5_STATUS_WRITE_ENABLE) {
    printf(" Write");
  }
  if (statusval & ECP5_STATUS_READ_ENABLE) {
    printf(" Read");
  }
  if (statusval & ECP5_STATUS_BUSY) {
    printf(" Busy");
  }
  if (statusval & ECP5_STATUS_FAIL) {
    printf(" Fail");
  }
  if (statusval & ECP5_STATUS_FEA_OTP) {
    printf(" FEA-OTP");
  }
  if (statusval & ECP5_STATUS_DECRYPT_ONLY) {
    printf(" Decrypt-Only");
  }
  if (statusval & ECP5_STATUS_PWD_ENABLE) {
    printf(" PWD-Enable");
  }
  if (statusval & ECP5_STATUS_ENCRYPTED_PREAMBLE) {
    printf(" Encrypted-Preamble");
  }
  if (statusval & ECP5_STATUS_STANDARD_PREAMBLE) {
    printf(" Standard-Preamble");
  }
  if (statusval & ECP5_STATUS_SPIM_FAIL1) {
    printf(" SPIm-Fail1");
  }
  switch (ECP5_STATUS_BSE_ERROR(statusval)) {
    case 0:
      // No error
      break;
    case 1:
      printf(" BSE:Id-Error");
      break;
    case 2:
      printf(" BSE:Invalid-Command");
      break;
    case 3:
      printf(" BSE:CRC-Error");
      break;
    case 4:
      printf(" BSE:Preamble-Error");
      break;
    case 5:
      printf(" BSE:Aborted-by-User");
      break;
    case 6:
      printf(" BSE:Overflow");
      break;
    case 7:
      printf(" BSE:SDM-Error");
      break;
  }
  if (statusval & ECP5_STATUS_EXECUTION_ERROR) {
    printf(" Execution-Error");
  }
  if (statusval & ECP5_STATUS_ID_ERROR) {
    printf(" Id-Error");
  }
  if (statusval & ECP5_STATUS_INVALID_COMMAND) {
    printf(" Invalid-Command");
  }
  if (statusval & ECP5_STATUS_SED_ERROR) {
    printf(" SED-Error");
  }
  if (statusval & ECP5_STATUS_BYPASS_MODE) {
    printf(" Bypass-Mode");
  }
  if (statusval & ECP5_STATUS_FLOW_THROUGH_MODE) {
    printf(" Flow-Through-Mode");
  }
  printf("\n");
}

status ecp5_read_id(uint32_t* id) {
  return class_a_op(ECP5_OPCODE_READ_ID, 0, id, "ecp5_read_id");
}

status ecp5_verify_id(uint32_t id) {
  return class_b_op(ECP5_OPCODE_VERIFY_ID, 0, id, "ecp5_verify_id");
}

status ecp5_usercode(uint32_t* usercode) {
  return class_a_op(ECP5_OPCODE_USERCODE, 0, usercode, "ecp5_usercode");
}

status ecp5_program_usercode(uint32_t usercode) {
  return class_b_op(ECP5_OPCODE_PROGRAM_USERCODE, 0, usercode,
                    "ecp5_program_usercode");
}

status ecp5_reset_crc() {
  return class_c_op(ECP5_OPCODE_RESET_CRC, 0, "ecp5_reset_crc");
}

status ecp5_init_address() {
  return class_c_op(ECP5_OPCODE_INIT_ADDRESS, 0, "ecp5_init_address");
}

status ecp5_program_done() {
  return class_c_op(ECP5_OPCODE_PROGRAM_DONE, 0, "ecp5_program_done");
}

status ecp5_isc_enable() {
  RETURN_IF_ERROR(class_c_op(ECP5_OPCODE_ISC_ENABLE, 0, "ecp5_isc_enable"));
  // Sleep for 1ms is required for some unknown reason.
  usleep(1000);
  return OK;
}

status ecp5_isc_disable() {
  RETURN_IF_ERROR(class_c_op(ECP5_OPCODE_ISC_DISABLE, 0, "ecp5_isc_disable"));
  // Sleep for 1ms is required for some unknown reason.
  usleep(1000);
  return OK;
}

status ecp5_erase() {
  // Not sure what this argument is for.
  uint32_t arg = 0x010000;
  return class_d_op(ECP5_OPCODE_ERASE, arg, "ecp5_erase");
}

status ecp5_write_idle_bytes(int count) {
  assert(count < 256);
  uint8_t idle[256];
  memset(idle, 0xFF, sizeof(idle));
  mpsse_write_data(idle, count);
  return ftdiutil_flush_writes("ecp5_write_idle_bytes");
}

status ecp5_bitstream_burst(uint8_t* data, unsigned int size,
    void (*progress_fn)(unsigned int,unsigned int)) {
  // Scan for start mark.
  while (size > 2 && (data[0] != 0xbd || data[1] != 0xb3)) {
    data++;
    size--;
  }
  if (size <= 2) {
    return errorf("missing start mark 0xbdb3");
  }

  unsigned int total_size = size;

  uint8_t wr[4] = {ECP5_OPCODE_BITSTREAM_BURST, 0, 0, 0};
  mpsse_chip_select(true);
  mpsse_write_data(wr, sizeof(wr));
  uint8_t idle[128];
  memset(idle, 0xff, sizeof(idle));
  mpsse_write_data(idle, sizeof(idle));
  RETURN_IF_ERROR(ftdiutil_flush_writes("ecp5_bitstream_burst"));
  const unsigned int block_size = 1024;
  progress_fn(0, total_size);
  while (size > 0) {
    unsigned int wrsize = (size > block_size ? block_size : size);
    mpsse_write_data(data, wrsize);
    RETURN_IF_ERROR(ftdiutil_flush_writes("ecp5_bitstream_burst"));
    data += wrsize;
    size -= wrsize;
    progress_fn(total_size - size, total_size);
  }
  mpsse_chip_select(true);
  RETURN_IF_ERROR(ftdiutil_flush_writes("ecp5_bitstream_burst"));
  return OK;
}
