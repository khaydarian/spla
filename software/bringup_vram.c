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

static status reset() {
  queue_op_zero(OPCODE_RESET, 0);
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

static uint16_t address_tests[] = {0x1234, 0, 0x7fff};

static status check_vaa() {
  unsigned fail = 0;
  for (unsigned i = 0; i < sizeof(address_tests) / sizeof(address_tests[0]);
       i++) {
    uint16_t expect = address_tests[i];
    set_vaa(expect);
    uint16_t actual = 42;
    uint8_t high;
    uint8_t low;
    queue_op_one(OPCODE_GET_VAA_HIGH, 0, &high);
    queue_op_one(OPCODE_GET_VAA_LOW, 0, &low);
    RETURN_IF_ERROR(ftdiutil_flush_reads("check_vaa"));
    actual = (high << 8) | low;
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

static status check_vab() {
  for (unsigned i = 0; i < sizeof(address_tests) / sizeof(address_tests[0]);
       i++) {
    uint16_t expect = address_tests[i];
    set_vab(expect);
    uint16_t actual = 42;
    uint8_t high;
    uint8_t low;
    queue_op_one(OPCODE_GET_VAB_HIGH, 0, &high);
    queue_op_one(OPCODE_GET_VAB_LOW, 0, &low);
    RETURN_IF_ERROR(ftdiutil_flush_reads("check_vab"));
    actual = (high << 8) | low;
    if (expect != actual) {
      return errorf("[#%d] bad vab address: expect 0x%04x, actual 0x%04x", i,
                    expect, actual);
    }
  }
  return OK;
}

static void set_vda(uint8_t vda) { queue_op_zero(OPCODE_SET_VDA, vda); }

static void set_vdb(uint8_t vdb) { queue_op_zero(OPCODE_SET_VDB, vdb); }

static void set_duration(uint8_t duration) {
  queue_op_zero(OPCODE_SET_DURATION, duration);
}

static void vram_read() { queue_op_zero(OPCODE_CYCLE_READ, 0); }

static void vram_write() { queue_op_zero(OPCODE_CYCLE_WRITE, 0); }

static void get_vda(uint8_t* vda) { queue_op_one(OPCODE_GET_VDA, 0, vda); }

static void get_vdb(uint8_t* vdb) { queue_op_one(OPCODE_GET_VDB, 0, vdb); }

static status check_vd() {
  static const uint8_t vda_tests[] = {0x0, 0xa1, 0x12, 0x34, 0xff};
  static const uint8_t vdb_tests[] = {0x0, 0xb2, 0x56, 0x78, 0xff};
  for (unsigned i = 0; i < sizeof(vda_tests) / sizeof(vda_tests[0]); i++) {
    uint8_t expect_vda = vda_tests[i];
    uint8_t expect_vdb = vdb_tests[i];
    set_vda(expect_vda);
    set_vdb(expect_vdb);
    RETURN_IF_ERROR(ftdiutil_flush_reads("check_vd:set_vd"));
    uint8_t actual_vda;
    uint8_t actual_vdb;
    get_vda(&actual_vda);
    RETURN_IF_ERROR(ftdiutil_flush_reads("check_vd:get_vda"));
    if (expect_vda != actual_vda) {
      return errorf("[#%d] bad vda: expect 0x%02x, actual 0x%02x", i,
                    expect_vda, actual_vda);
    }
    get_vdb(&actual_vdb);
    RETURN_IF_ERROR(ftdiutil_flush_reads("check_vd:get_vdb"));
    if (expect_vdb != actual_vdb) {
      return errorf("[#%d] bad vdb: expect 0x%02x, actual 0x%02x", i,
                    expect_vdb, actual_vdb);
    }
  }
  return OK;
}

static status selftest() {
  printf("--- selftest\n");

  // ECHO
  printf("echo\n");
  RETURN_IF_ERROR(check_echo());

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

static status spot_check() {
  printf("--- spot_check:\n");
  set_vaa(0x1234);
  set_vab(0x1234);
  uint8_t expect_vda = 0x1a;
  uint8_t expect_vdb = 0x2b;
  printf("will write:\n");
  printf("  vda = 0x%02x, vdb = 0x%02x\n", expect_vda, expect_vdb);
  set_vda(expect_vda);
  set_vdb(expect_vdb);
  printf("vram_write\n");
  vram_write();
  set_vda(0);
  set_vdb(0);
  RETURN_IF_ERROR(ftdiutil_flush_reads("spot_check"));

  uint8_t vda;
  uint8_t vdb;
  get_vda(&vda);
  get_vdb(&vdb);
  RETURN_IF_ERROR(ftdiutil_flush_reads("spot_check"));
  printf("clear: vda = 0x%02x, vdb = 0x%02x\n", vda, vdb);

  printf("vram_read\n");
  vram_read();
  RETURN_IF_ERROR(ftdiutil_flush_reads("spot_check"));

  for (int i = 0; i < 3; i++) {
    get_vda(&vda);
    get_vdb(&vdb);
    RETURN_IF_ERROR(ftdiutil_flush_reads("spot_check"));
    printf("  vda = %s0x%02x%s, vdb = %s0x%02x%s\n",
           (vda == expect_vda ? GREEN : RED), vda, RESET,
           (vdb == expect_vdb ? GREEN : RED), vdb, RESET);
  }

  (void)set_duration;

  return OK;
}

static uint8_t scan_data_at(uint8_t side, uint16_t address) {
  return side | ((address * 91) % 0xf);
}

static status memory_scan() {
  printf("--- memory_scan:\n");
  uint16_t minaddr = 0;
  uint16_t maxaddr = MAX_ADDRESS;
  uint16_t incr = 0x40;  // Arbitrary; should be 1 for better sampling.

  printf("write:\n");
  int buffered = 0;
  for (uint16_t address = minaddr; address < maxaddr; address += incr) {
    uint8_t vda = scan_data_at(0xa0, address);
    uint8_t vdb = scan_data_at(0xb0, address);
    set_vaa(address);
    set_vab(address);
    set_vda(vda);
    set_vdb(vdb);
    vram_write();
    buffered++;
    if (buffered >= 16) {
      buffered = 0;
      RETURN_IF_ERROR(ftdiutil_flush_writes("memory_scan.write"));
    }
  }

  printf("read:\n");
  for (uint16_t address = minaddr; address < maxaddr; address += incr) {
    set_vaa(address);
    set_vab(address);
    uint8_t expect_vda = scan_data_at(0xa0, address);
    uint8_t expect_vdb = scan_data_at(0xb0, address);
    uint8_t vda, vdb;
    vram_read();
    get_vda(&vda);
    get_vdb(&vdb);
    RETURN_IF_ERROR(ftdiutil_flush_reads("memory_scan.vdb"));
    printf("read 0x%04x vda %s0x%02x%s (0x%02x) vdb %s0x%02x%s (0x%02x)\n",
           address, (vda == expect_vda ? GREEN : RED), vda, RESET, expect_vda,
           (vdb == expect_vdb ? GREEN : RED), vdb, RESET, expect_vdb);
  }

  return OK;
}

static void set_lvl_vd_dir(int value) {
  queue_op_zero(OPCODE_SET_LVL_VD_DIR, value & 1);
}

static void set_vrd_n(int value) { queue_op_zero(OPCODE_SET_VRD_N, value & 1); }

static void set_vawr_n(int value) {
  queue_op_zero(OPCODE_SET_VAWR_N, value & 1);
}

static void set_vbwr_n(int value) {
  queue_op_zero(OPCODE_SET_VBWR_N, value & 1);
}

static void set_vwr_n(int value) { queue_op_zero(OPCODE_SET_VWR_N, value & 1); }

static void vram_sample() { queue_op_zero(OPCODE_SAMPLE, 0); }

static status noncycle_test() {
  uint8_t vda, vdb;

  uint8_t expect_vda = 0xa1;
  uint8_t expect_vdb = 0xb2;

  for (uint16_t address = 0; address < MAX_ADDRESS; address += 0x707) {
    set_vaa(address);
    set_vab(address);
    RETURN_IF_ERROR(ftdiutil_flush_writes("noncycle_test:addr"));

    int lvl_vd_dir = 1;

    printf("lvl_vd_dir = %d\n", lvl_vd_dir);

    set_vda(expect_vda);
    RETURN_IF_ERROR(ftdiutil_flush_reads("noncycle_test:..."));
    set_vdb(expect_vda);
    RETURN_IF_ERROR(ftdiutil_flush_reads("noncycle_test:..."));

    set_lvl_vd_dir(lvl_vd_dir);
    RETURN_IF_ERROR(ftdiutil_flush_reads("noncycle_test:..."));
    set_vwr_n(0);
    RETURN_IF_ERROR(ftdiutil_flush_reads("noncycle_test:..."));
    set_vwr_n(1);
    RETURN_IF_ERROR(ftdiutil_flush_reads("noncycle_test:..."));

    vda = 0;
    vdb = 0;
    set_vda(vda);
    set_vda(vdb);
    RETURN_IF_ERROR(ftdiutil_flush_reads("noncycle_test:clear"));

    vram_sample();
    RETURN_IF_ERROR(ftdiutil_flush_reads("noncycle_test:clear"));

    set_lvl_vd_dir(1 - lvl_vd_dir);
    set_vrd_n(0);
    set_vrd_n(1);
    RETURN_IF_ERROR(ftdiutil_flush_reads("noncycle_test:read"));

    for (int i = 0; i < 3; i++) {
      get_vda(&vda);
      get_vdb(&vdb);
      RETURN_IF_ERROR(ftdiutil_flush_reads("noncycle_test:get_vd"));
      printf("  vda %s0x%02x%s (0x%02x) vdb %s0x%02x%s (0x%02x)\n",
             (vda == expect_vda ? GREEN : RED), vda, RESET, expect_vda,
             (vdb == expect_vdb ? GREEN : RED), vdb, RESET, expect_vdb);
    }

    expect_vda += 2;
    expect_vdb += 2;
  }

  (void)set_vawr_n;
  (void)set_vbwr_n;

  return OK;
}

// [Command]
// Description: Test VRAM chips in isolation for manufacturing faults.
// Option: open_usb = true
// Option: default_usb_device = board
status bringup_vram(int argc, char** argv) {
  bool flag_skip_program = false;
  bool flag_debug = false;
  bool flag_reset = false;

  while (argc) {
    if (!strcmp(argv[0], "--skip-program")) {
      flag_skip_program = true;
      argc--;
      argv++;
    } else if (!strcmp(argv[0], "--debug")) {
      flag_debug = true;
      argc--;
      argv++;
    } else if (!strcmp(argv[0], "--reset")) {
      flag_reset = true;
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

  if (flag_reset) {
    return reset();
  }

  RETURN_IF_ERROR(selftest());

  RETURN_IF_ERROR(spot_check());

  RETURN_IF_ERROR(memory_scan());

  // RETURN_IF_ERROR(noncycle_test());
  (void)noncycle_test;

  RETURN_IF_ERROR(reset());

  return OK;
}
