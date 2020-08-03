// vi: ts=2:sw=2:sts=2:et

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include "bitstream.h"
#include "color.h"
#include "command.h"
#include "ftdi.h"
#include "ftdiutil.h"
#include "uart.h"

#define OPCODE_NOOP 0x00
#define OPCODE_ECHO 0x01
#define OPCODE_ECHO2 0x02
#define OPCODE_RESET 0x10
#define OPCODE_SET_VAA_LOW 0x20
#define OPCODE_SET_VAA_HIGH 0x21
#define OPCODE_SET_VAB_LOW 0x30
#define OPCODE_SET_VAB_HIGH 0x31
#define OPCODE_SET_VDA 0x42
#define OPCODE_SET_VDB 0x43
#define OPCODE_WRITE_DURATION 0x50
#define OPCODE_READ_DELAY 0x51
#define OPCODE_WRITE 0x80
#define OPCODE_READ 0x90

static status op_echo(uint8_t request, uint8_t* response) {
  uint8_t wbuf[2];
  wbuf[0] = OPCODE_ECHO;
  wbuf[1] = request;
  ftdiutil_write_data(wbuf, sizeof(wbuf));
  RETURN_IF_ERROR(ftdiutil_flush_writes("op_echo"));
  ftdiutil_read_data(response, 1);
  RETURN_IF_ERROR(ftdiutil_flush_reads("op_echo"));
  return OK;
}

static status check_echo() {
  uint8_t request = 0x41;
  uint8_t response;
  RETURN_IF_ERROR(op_echo(request, &response));
  if (request != response) {
    return errorf("check_echo: request 0x%02x, bad response 0x%02x", request,
                  response);
  }
  return OK;
}

static status op_echo2(uint8_t request, uint8_t* response,
                       uint8_t* response_inv) {
  uint8_t wbuf[2];
  wbuf[0] = OPCODE_ECHO2;
  wbuf[1] = request;
  ftdiutil_write_data(wbuf, sizeof(wbuf));
  RETURN_IF_ERROR(ftdiutil_flush_writes("op_echo2"));
  ftdiutil_read_data(response, 1);
  ftdiutil_read_data(response_inv, 1);
  RETURN_IF_ERROR(ftdiutil_flush_reads("op_echo2"));
  return OK;
}

static status check_echo2() {
  uint8_t request = 0x41;
  uint8_t request_inv = ~request;
  uint8_t response;
  uint8_t response_inv;
  RETURN_IF_ERROR(op_echo2(request, &response, &response_inv));
  if (request != response || request_inv != response_inv) {
    return errorf("check_echo2: request 0x%02x, bad response 0x%02x 0x%02x",
                 request, response, response_inv);
  }
  return OK;
}

// [Command]
// Description: Test VRAM chips in isolation for manufacturing faults.
// Option: open_usb = true
// Option: default_usb_device = board
status bringup_vram(int argc, char** argv) {
  bool flag_skip_program = false;
  bool flag_debug = false;

  while (argc) {
    if (!strcmp(argv[0], "--skip-program")) {
      flag_skip_program = true;
      argc--;
      argv++;
    } else if (!strcmp(argv[0], "--debug")) {
      flag_debug = true;
      argc--;
      argv++;
    } else {
      return errorf("Unknown flag: %s", argv[0]);
    }
  }

  if (!flag_skip_program) {
    const char* bitstream_filename = "../rtl/build/bringup_vram.bit";
    struct bitstream bits = {0};
    RETURN_IF_ERROR(load_bitstream_file(&bits, bitstream_filename));
    RETURN_IF_ERROR(program_bitstream(&bits));
    free_bitstream(&bits);
  }

  ftdiutil_set_interface(INTERFACE_A);
  uart_init();

  if (flag_debug) {
    ftdiutil_debug_logging(true);
  }

  // ECHO
  printf("check_echo()\n");
  RETURN_IF_ERROR(check_echo());
  printf("check_echo() PASS\n");

  // ECHO2
  printf("check_echo2()\n");
  RETURN_IF_ERROR(check_echo2());
  printf("check_echo2() PASS\n");

  return OK;
}
