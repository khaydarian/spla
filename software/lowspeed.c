// vi: ts=2:sw=2:sts=2:et

#include <assert.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#include "bitstream.h"
#include "color.h"
#include "command.h"
#include "ftdi.h"
#include "ftdiutil.h"
#include "lowspeed_core.h"
#include "uart.h"

static void queue_op_zero(uint8_t opcode, uint8_t arg) {
  uint8_t wbuf[2];
  wbuf[0] = opcode;
  wbuf[1] = arg;
  ftdiutil_write_data(wbuf, sizeof(wbuf));
}

static void queue_op_one(uint8_t opcode, uint8_t arg, uint8_t* response) {
  queue_op_zero(opcode, arg);
  ftdiutil_read_data(response, 1);
}

static status op_echo(uint8_t request, uint8_t* response) {
  queue_op_one(OPCODE_ECHO, request, response);
  RETURN_IF_ERROR(ftdiutil_flush_reads("op_echo"));
  return OK;
}

static status selftest_echo() {
  uint8_t request = 0x41;
  uint8_t response;
  RETURN_IF_ERROR(op_echo(request, &response));
  if (request != response) {
    return errorf("selftest_echo: request 0x%02x, bad response 0x%02x", request,
                  response);
  }
  return OK;
}

static status op_set_leds(uint8_t state) {
  assert(state <= 0xf);
  queue_op_zero(OPCODE_SET_LEDS, state);
  RETURN_IF_ERROR(ftdiutil_flush_reads("op_set_leds"));
  return OK;
}

static status selftest_leds() {
  for (uint8_t i = 0; i < 16; i++) {
    RETURN_IF_ERROR(op_set_leds(i));
    usleep(100000);
  }
  usleep(900000);
  RETURN_IF_ERROR(op_set_leds(0));
  return OK;
}

static status selftest() {
  printf("=== selftest\n");
  printf("echo\n");
  RETURN_IF_ERROR(selftest_echo());

  printf("set_leds\n");
  RETURN_IF_ERROR(selftest_leds());

  printf("--- " GREEN "PASS" RESET "\n");
  return OK;
}

// [Command]
// Description: Test VRAM chips in isolation for manufacturing faults.
// Option: open_usb = true
// Option: default_usb_device = board
status lowspeed(int argc, char** argv) {
  bool flag_skip_program = false;
  bool flag_debug = false;
  bool flag_selftest = false;

  while (argc) {
    if (!strcmp(argv[0], "--skip-program")) {
      flag_skip_program = true;
      argc--;
      argv++;
    } else if (!strcmp(argv[0], "--debug")) {
      flag_debug = true;
      argc--;
      argv++;
    } else if (!strcmp(argv[0], "--selftest")) {
      flag_selftest = true;
      argc--;
      argv++;
    } else {
      return errorf("Unknown flag: %s", argv[0]);
    }
  }

  if (!flag_skip_program) {
    const char* bitstream_filename = "../rtl/build/lowspeed.bit";
    struct bitstream bits = {0};
    RETURN_IF_ERROR(load_bitstream_file(&bits, bitstream_filename));
    RETURN_IF_ERROR(program_bitstream(&bits));
    free_bitstream(&bits);
  }

  ftdiutil_set_interface(INTERFACE_A);
  RETURN_IF_ERROR(uart_init());

  if (flag_debug) {
    ftdiutil_debug_logging(true);
  }

  if (flag_selftest) {
    RETURN_IF_ERROR(selftest());
  }

  return OK;
}
