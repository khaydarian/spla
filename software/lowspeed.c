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

static void queue_op(uint8_t opcode, int argc, uint8_t* argv, int respc,
                     uint8_t* resp) {
  assert(argc >= 0 && argc <= 3);
  assert(((opcode >> 6) & 3) == argc);
  ftdiutil_write_data(&opcode, 1);
  ftdiutil_write_data(argv, argc);
  if (respc) {
    ftdiutil_read_data(resp, respc);
  }
}

static status op_echo1(uint8_t request, uint8_t* response) {
  queue_op(OPCODE_ECHO1, 1, &request, 1, response);
  RETURN_IF_ERROR(ftdiutil_flush_reads("op_echo1"));
  return OK;
}

static status op_echo2(uint8_t* request, uint8_t* response) {
  queue_op(OPCODE_ECHO2, 2, request, 2, response);
  RETURN_IF_ERROR(ftdiutil_flush_reads("op_echo2"));
  return OK;
}

static status op_echo3(uint8_t* request, uint8_t* response) {
  queue_op(OPCODE_ECHO3, 3, request, 3, response);
  RETURN_IF_ERROR(ftdiutil_flush_reads("op_echo3"));
  return OK;
}

static status selftest_echo() {
  {
    uint8_t request = 0x12;
    uint8_t response = 0xad;
    RETURN_IF_ERROR(op_echo1(request, &response));
    if (request != response) {
      return errorf("selftest_echo: request 0x%02x, bad response 0x%02x",
                    request, response);
    }
  }

  {
    uint8_t request[2] = {0x12, 0x34};
    uint8_t response[2] = {0xad, 0xad};
    RETURN_IF_ERROR(op_echo2(request, response));
    if (request[0] != response[0] || request[1] != response[1]) {
      return errorf(
          "selftest_echo: request 0x%02x 0x%02x, "
          "bad response 0x%02x 0x%02x",
          request[0], request[1], response[0], response[1]);
    }
  }

  {
    uint8_t request[3] = {0x12, 0x34, 0x56};
    uint8_t response[3] = {0xad, 0xad, 0xad};
    RETURN_IF_ERROR(op_echo3(request, response));
    if (request[0] != response[0] || request[1] != response[1] ||
        request[2] != response[2]) {
      return errorf(
          "selftest_echo: request 0x%02x 0x%02x 0x%02x, "
          "bad response 0x%02x 0x%02x 0x%02x",
          request[0], request[1], request[2], response[0], response[1],
          response[2]);
    }
  }
  return OK;
}

static status op_set_leds(uint8_t state) {
  assert(state <= 0xf);
  queue_op(OPCODE_SET_LEDS, 1, &state, 0, NULL);
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
