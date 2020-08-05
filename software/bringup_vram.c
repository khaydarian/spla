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

#include "vram_control.h"

#define MAX_ADDRESS ((1 << 15) - 1)

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

static void queue_op_two(uint8_t opcode, uint8_t arg, uint8_t* response1,
                         uint8_t* response2) {
  queue_op_one(opcode, arg, response1);
  ftdiutil_read_data(response2, 1);
}

static void queue_op_uint16(uint8_t opcode, uint8_t arg, uint16_t* response) {
  queue_op_zero(opcode, arg);
  // Note: Blatantly assuming host is little-endian.
  uint8_t* high = ((uint8_t*)response) + 1;
  uint8_t* low = ((uint8_t*)response);
  ftdiutil_read_data(high, 1);
  ftdiutil_read_data(low, 1);
}

static status op_echo(uint8_t request, uint8_t* response) {
  queue_op_one(OPCODE_ECHO, request, response);
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
  queue_op_two(OPCODE_ECHO2, request, response, response_inv);
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

static status reset() {
  queue_op_zero(OPCODE_ECHO, 0);
  RETURN_IF_ERROR(ftdiutil_flush_reads("reset"));
  return OK;
}

static status set_vaa(uint16_t address) {
  if (address > MAX_ADDRESS) {
    return errorf("address out of range: 0x%x > 0x%x", address, MAX_ADDRESS);
  }
  queue_op_zero(OPCODE_SET_VAA_HIGH, address >> 8);
  queue_op_zero(OPCODE_SET_VAA_LOW, address & 0xff);
  return OK;
}

static void get_vaa(uint16_t* address) {
  queue_op_uint16(OPCODE_GET_VAA, 0, address);
}

static uint16_t address_tests[] = {0x1234, 0, 0x7fff};

static status check_vaa() {
  unsigned fail = 0;
  for (unsigned i = 0; i < sizeof(address_tests) / sizeof(address_tests[0]);
       i++) {
    uint16_t expect = address_tests[i];
    set_vaa(expect);
    uint16_t actual = 42;
    get_vaa(&actual);
    RETURN_IF_ERROR(ftdiutil_flush_reads("check_vaa"));
    if (expect != actual) {
      fail++;
      fprintf(stderr, "[#%d] bad vaa address: expect 0x%04x, actual 0x%04x\n",
              i, expect, actual);
    }
  }
  if (fail) {
    return errorf("check_vaa: %d / %d tests failed", fail,
                  sizeof(address_tests) / sizeof(address_tests[0]));
  }
  return OK;
}

static status set_vab(uint16_t address) {
  if (address > MAX_ADDRESS) {
    return errorf("address out of range: 0x%x > 0x%x", address, MAX_ADDRESS);
  }
  queue_op_zero(OPCODE_SET_VAB_HIGH, address >> 8);
  queue_op_zero(OPCODE_SET_VAB_LOW, address & 0xff);
  return OK;
}

static void get_vab(uint16_t* address) {
  queue_op_uint16(OPCODE_GET_VAB, 0, address);
}

static status check_vab() {
  for (unsigned i = 0; i < sizeof(address_tests) / sizeof(address_tests[0]);
       i++) {
    uint16_t expect = address_tests[i];
    set_vab(expect);
    uint16_t actual = 42;
    get_vab(&actual);
    RETURN_IF_ERROR(ftdiutil_flush_reads("check_vab"));
    if (expect != actual) {
      return errorf("[#%d] bad vab address: expect 0x%04x, actual 0x%04x", i,
                    expect, actual);
    }
  }
  return OK;
}

static void set_vda(uint8_t vda) { queue_op_zero(OPCODE_SET_VDA, vda); }

static void set_vdb(uint8_t vdb) { queue_op_zero(OPCODE_SET_VDB, vdb); }

static void get_vdab(uint8_t* vda, uint8_t* vdb) {
  queue_op_two(OPCODE_GET_VDAB, 0, vda, vdb);
}

static status check_vd() {
  static const uint8_t vda_tests[] = {0x0, 0x12, 0x34, 0xff};
  static const uint8_t vdb_tests[] = {0x0, 0x56, 0x78, 0xff};
  for (unsigned i = 0; i < sizeof(vda_tests) / sizeof(vda_tests[0]); i++) {
    uint8_t expect_vda = vda_tests[i];
    uint8_t expect_vdb = vdb_tests[i];
    set_vda(expect_vda);
    set_vdb(expect_vdb);
    uint8_t actual_vda;
    uint8_t actual_vdb;
    get_vdab(&actual_vda, &actual_vdb);
    RETURN_IF_ERROR(ftdiutil_flush_reads("check_vd"));
    if ((expect_vda != actual_vda) || (expect_vdb != actual_vdb)) {
      return errorf(
          "[#%d] bad vda/vdb: expect vda 0x%02x vdb 0x%02x, "
          "actual vda 0x%02x vdb 0x%02x",
          expect_vda, expect_vdb, actual_vda, actual_vdb);
    }
  }
  return OK;
}

static status selftest() {
  printf("--- selftest\n");

  // ECHO
  printf("echo\n");
  RETURN_IF_ERROR(check_echo());

  // ECHO2
  printf("echo2\n");
  RETURN_IF_ERROR(check_echo2());

  // VAA
  printf("set vaa / get vaa\n");
  RETURN_IF_ERROR(check_vaa());

  // VAB
  printf("set vab / get vab\n");
  RETURN_IF_ERROR(check_vab());

  // VDA/VDB
  printf("set vda / set vdb / get vda+vdb\n");
  RETURN_IF_ERROR(check_vd());

  // Reset
  printf("reset\n");
  RETURN_IF_ERROR(reset());

  printf("--- PASS\n");
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

  RETURN_IF_ERROR(selftest());

  return OK;
}
