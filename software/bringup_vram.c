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
  printf("=== selftest\n");

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
  printf("=== spot_check:\n");
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

  int errors = 0;
  for (int i = 0; i < 3; i++) {
    get_vda(&vda);
    get_vdb(&vdb);
    RETURN_IF_ERROR(ftdiutil_flush_reads("spot_check"));
    printf("  vda = %s0x%02x%s, vdb = %s0x%02x%s\n",
           (vda == expect_vda ? GREEN : RED), vda, RESET,
           (vdb == expect_vdb ? GREEN : RED), vdb, RESET);
    errors += (vda == expect_vda ? 0 : 1);
    errors += (vdb == expect_vdb ? 0 : 1);
  }

  if (errors) {
    printf("--- FAIL (%d errors)\n", errors);
  } else {
    printf("--- PASS\n");
  }

  return OK;
}

static status bit_scan() {
  printf("=== bit_scan:\n");
  reset();

  uint16_t base_tests[] = {0, 0x7fff};
  int num_base_tests = sizeof(base_tests) / sizeof(base_tests[0]);

  int errors = 0;
  for (uint16_t baseidx = 0; baseidx < num_base_tests; baseidx++) {
    uint16_t base = base_tests[baseidx];
    for (uint16_t bit = 1; bit < MAX_ADDRESS; bit <<= 1) {
      uint16_t address = base ^ bit;
      uint8_t expect_vda_at_zero = 0xa1;
      uint8_t expect_vda_at_one = 0x1a;
      uint8_t expect_vdb_at_zero = 0xb2;
      uint8_t expect_vdb_at_one = 0x2b;

      for (unsigned order = 0; order < 2; order++) {
        for (unsigned which = 0; which < 2; which++) {
          if (order == which) {
            set_vaa(base);
            set_vab(base);
            set_vda(expect_vda_at_zero);
            set_vdb(expect_vdb_at_zero);
            vram_write();
          } else {
            set_vaa(address);
            set_vab(address);
            set_vda(expect_vda_at_one);
            set_vdb(expect_vdb_at_one);
            vram_write();
          }
        }
        RETURN_IF_ERROR(ftdiutil_flush_writes("bit_scan.write"));

        uint8_t actual_vda_at_zero;
        uint8_t actual_vdb_at_zero;
        uint8_t actual_vda_at_one;
        uint8_t actual_vdb_at_one;
        set_vaa(address);
        set_vab(address);
        vram_read();
        get_vda(&actual_vda_at_one);
        get_vdb(&actual_vdb_at_one);
        set_vaa(base);
        set_vab(base);
        vram_read();
        get_vda(&actual_vda_at_zero);
        get_vdb(&actual_vdb_at_zero);
        RETURN_IF_ERROR(ftdiutil_flush_reads("bit_scan.read"));

        int line_errors = ((actual_vda_at_zero == expect_vda_at_zero ? 0 : 1) +
                           (actual_vdb_at_zero == expect_vdb_at_zero ? 0 : 1) +
                           (actual_vda_at_one == expect_vda_at_one ? 0 : 1) +
                           (actual_vdb_at_one == expect_vdb_at_one ? 0 : 1));
        if (line_errors) {
          printf(
              "<0x%04x->0x%04x> vda %s0x%02x%s (0x%02x) %s0x%02x%s (0x%02x)"
              " vdb %s0x%02x%s (0x%02x) %s0x%02x%s (0x%02x)\n",
              order ? base : address, order ? address : base,
              (actual_vda_at_zero == expect_vda_at_zero ? GREEN : RED),
              actual_vda_at_zero, RESET, expect_vda_at_zero,
              (actual_vda_at_one == expect_vda_at_one ? GREEN : RED),
              actual_vda_at_one, RESET, expect_vda_at_one,
              (actual_vdb_at_zero == expect_vdb_at_zero ? GREEN : RED),
              actual_vdb_at_zero, RESET, expect_vdb_at_zero,
              (actual_vdb_at_one == expect_vdb_at_one ? GREEN : RED),
              actual_vdb_at_one, RESET, expect_vdb_at_one);
        }
        errors += line_errors;
      }
    }
  }

  if (errors) {
    printf("--- FAIL (%d errors)\n", errors);
  } else {
    printf("--- PASS\n");
  }
  return OK;
}

static uint8_t scan_data_at(uint8_t side, uint16_t address) {
  return side | ((address * 91) % 0xf);
}

static status memory_scan() {
  printf("=== memory_scan:\n");
  uint16_t minaddr = 0;
  uint16_t maxaddr = MAX_ADDRESS;
  uint16_t incr = 0x41;  // Arbitrary; should be 1 for better sampling.

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
  int errors = 0;
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
    if (vda != expect_vda || vdb != expect_vdb) {
      printf("read 0x%04x vda %s0x%02x%s (0x%02x) vdb %s0x%02x%s (0x%02x)\n",
             address, (vda == expect_vda ? GREEN : RED), vda, RESET, expect_vda,
             (vdb == expect_vdb ? GREEN : RED), vdb, RESET, expect_vdb);
      errors += (vda == expect_vda ? 0 : 1);
      errors += (vdb == expect_vdb ? 0 : 1);
    }
  }

  if (errors) {
    printf("--- FAIL (%d errors)\n", errors);
  } else {
    printf("--- PASS\n");
  }
  return OK;
}

static uint32_t xorshift32(uint32_t* state) {
  uint32_t x = *state;
  x ^= x << 13;
  x ^= x >> 17;
  x ^= x << 5;
  return *state = x;
}

static status memory_random() {
  printf("=== memory_random()\n");

  uint32_t rand = 42;

  uint8_t chip_a[32768];
  uint8_t chip_b[32768];
  uint8_t addr_used[32768];

  const int min_flight = 128;
  const int max_flight = 2048;
  const int mid_flight = (max_flight + min_flight) / 2;

  uint16_t addresses[max_flight];
  int addresses_valid;

  int errors = 0;
  const int max_attempts = 5000;

  for (int attempts = 0; attempts < max_attempts; attempts++) {
    if (attempts % 100 == 0) {
      printf("[%d / %d] flight %4d / %04d\n", attempts, max_attempts,
             addresses_valid, max_flight);
    }
    if (addresses_valid >= min_flight) {
      int reads = xorshift32(&rand) & 1;
      if (addresses_valid >= mid_flight) {
        reads = xorshift32(&rand) % 4;  // 0, 1, 2, 3: expected 1.5
      } else {
        reads = xorshift32(&rand) % 2;  // 0, 1: expect 0.5
      }
      for (int i = 0; i < reads; i++) {
        int addrindex = xorshift32(&rand) % addresses_valid;
        uint16_t address = addresses[addrindex];
        set_vaa(address);
        set_vab(address);
        uint8_t expect_vda = chip_a[address];
        uint8_t expect_vdb = chip_b[address];
        uint8_t vda, vdb;
        vram_read();
        get_vda(&vda);
        get_vdb(&vdb);
        RETURN_IF_ERROR(ftdiutil_flush_reads("memory_random.read"));
        if (vda != expect_vda || vdb != expect_vdb) {
          printf(
              "read 0x%04x vda %s0x%02x%s (0x%02x) vdb %s0x%02x%s (0x%02x)\n",
              address, (vda == expect_vda ? GREEN : RED), vda, RESET,
              expect_vda, (vdb == expect_vdb ? GREEN : RED), vdb, RESET,
              expect_vdb);
          errors += (vda == expect_vda ? 0 : 1);
          errors += (vdb == expect_vdb ? 0 : 1);
        }
        for (int i = addrindex; i < addresses_valid - 1; i++) {
          addresses[addrindex] = addresses[addrindex + 1];
        }
        addresses_valid--;
      }
    }
    if (addresses_valid <= max_flight) {
      uint16_t address;
      do {
        address = xorshift32(&rand) % MAX_ADDRESS;
      } while (!addr_used[address]);
      addr_used[address] = 1;
      addresses[addresses_valid] = address;
      addresses_valid++;
      set_vaa(address);
      set_vab(address);
      uint8_t vda = xorshift32(&rand) & 0xff;
      uint8_t vdb = xorshift32(&rand) & 0xff;
      ;
      set_vda(vda);
      set_vdb(vdb);
      chip_a[address] = vda;
      chip_b[address] = vdb;
      vram_write();
      RETURN_IF_ERROR(ftdiutil_flush_reads("memory_random.write"));
    }
  }

  if (errors) {
    printf("--- FAIL (%d errors)\n", errors);
  } else {
    printf("--- PASS\n");
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
  bool flag_reset = false;
  bool flag_random = false;

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
    } else if (!strcmp(argv[0], "--random")) {
      flag_random = true;
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
  RETURN_IF_ERROR(uart_init());

  if (flag_debug) {
    ftdiutil_debug_logging(true);
  }

  if (flag_reset) {
    return reset();
  }

  RETURN_IF_ERROR(selftest());

  RETURN_IF_ERROR(spot_check());

  RETURN_IF_ERROR(bit_scan());

  RETURN_IF_ERROR(memory_scan());

  if (flag_random) {
    RETURN_IF_ERROR(memory_random());
  }

  RETURN_IF_ERROR(reset());

  return OK;
}
