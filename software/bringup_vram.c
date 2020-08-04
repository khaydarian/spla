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
#define OPCODE_SET_VA_LOW 0x20
#define OPCODE_SET_VA_HIGH 0x21
#define OPCODE_SET_VAA_LOW 0x30
#define OPCODE_SET_VAA_HIGH 0x31
#define OPCODE_SET_VAB_LOW 0x40
#define OPCODE_SET_VAB_HIGH 0x41
#define OPCODE_SET_VDA 0x50
#define OPCODE_SET_VDB 0x51
#define OPCODE_SET_CYCLE_DURATION 0x60
#define OPCODE_WRITE 0x80
#define OPCODE_READ 0x90

#define MAX_ADDRESS ((1 << 14) - 1)

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

static status reset() {
  queue_op_zero(OPCODE_ECHO, 0);
  RETURN_IF_ERROR(ftdiutil_flush_reads("reset"));
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

static status set_va(uint16_t address) {
  if (address > MAX_ADDRESS) {
    return errorf("address out of range: 0x%x > 0x%x", address, MAX_ADDRESS);
  }
  queue_op_zero(OPCODE_SET_VA_HIGH, address >> 8);
  queue_op_zero(OPCODE_SET_VA_LOW, address & 0xff);
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

static status set_vab(uint16_t address) {
  if (address > MAX_ADDRESS) {
    return errorf("address out of range: 0x%x > 0x%x", address, MAX_ADDRESS);
  }
  queue_op_zero(OPCODE_SET_VAB_HIGH, address >> 8);
  queue_op_zero(OPCODE_SET_VAB_LOW, address & 0xff);
  return OK;
}

static void set_vda(uint8_t value) { queue_op_zero(OPCODE_SET_VDA, value); }

static void set_vdb(uint8_t value) { queue_op_zero(OPCODE_SET_VDB, value); }

static void vram_write() {
  uint8_t flags = 0;
  queue_op_zero(OPCODE_WRITE, flags);
}

static status vram_read(uint8_t* vda, uint8_t* vdb) {
  uint8_t flags = 0;
  queue_op_two(OPCODE_READ, flags, vda, vdb);
  RETURN_IF_ERROR(ftdiutil_flush_reads("vram_read"));
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
  printf("PASS\n");

  // ECHO2
  printf("check_echo2()\n");
  RETURN_IF_ERROR(check_echo2());
  printf("PASS\n");

  // Reset
  printf("reset\n");
  RETURN_IF_ERROR(reset());
  printf("PASS\n");

  // Write to some address, and read back
  printf("arbitrary write\n");
  uint16_t address = 0x3edc;
  RETURN_IF_ERROR(set_va(address));
  uint8_t expect_vda = 0xfe;
  uint8_t expect_vdb = 0xef;
  set_vda(expect_vda);
  set_vdb(expect_vdb);
  vram_write();
  uint8_t vda, vdb;
  RETURN_IF_ERROR(vram_read(&vda, &vdb));
  printf(
      "Address 0x%04x vda %s0x%02x%s (expect 0x%02x) "
      "vdb %s0x%02x%s (expect 0x%02x)\n",
      address, (expect_vda == vda ? GREEN : RED), vda, RESET, expect_vda,
      (expect_vdb == vdb ? GREEN : RED), vdb, RESET, expect_vdb);

  (void)set_vaa;
  (void)set_vab;

  // uint16_t base = 0x1234;
  // for (uint16_t offset = 0; 1; offset++) {
  address = 0x0001;
  expect_vda = 0xff;
  expect_vdb = 0xff;
  while (1) {
    usleep(10000);
    address = (address << 1);
    address = (address & 0x3fff) | ((address & 0x4000) >> 14);
    RETURN_IF_ERROR(set_va(address));
    // for (uint16_t offset = 0; offset < 16; offset++) {
    // address = base + offset;
    // RETURN_IF_ERROR(set_va(base + offset));
    // expect_vda = 0x10 + offset;
    // expect_vdb = 0x20 + offset;
    set_vda(expect_vda);
    set_vdb(expect_vdb);
    vram_write();
    uint8_t vda, vdb;
    RETURN_IF_ERROR(vram_read(&vda, &vdb));
    printf(
        "Address 0x%04x vda %s0x%02x%s (expect 0x%02x) "
        "vdb %s0x%02x%s (expect 0x%02x)\n",
        address, (expect_vda == vda ? GREEN : RED), vda, RESET, expect_vda,
        (expect_vdb == vdb ? GREEN : RED), vdb, RESET, expect_vdb);
  }

  return OK;
}
