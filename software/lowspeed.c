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
  int expected_argc = ((opcode >> 6) & 3);
  if (expected_argc != argc) {
    fprintf(stderr, "opcode 0x%02x: expected %d args, got %d\n", opcode,
            expected_argc, argc);
  }
  assert(expected_argc == argc);
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

static status selftest() {
  printf("=== selftest\n");
  printf("echo\n");
  RETURN_IF_ERROR(selftest_echo());

  printf("--- " GREEN "PASS" RESET "\n");
  return OK;
}

static status op_reset() {
  queue_op(OPCODE_RESET, 0, NULL, 0, NULL);
  return ftdiutil_flush_reads("op_ppu_reset");
}

static status op_xin_enable() {
  queue_op(OPCODE_XIN_ENABLE, 0, NULL, 0, NULL);
  return ftdiutil_flush_reads("op_xin_enable");
}

static status op_xin_disable() {
  queue_op(OPCODE_XIN_DISABLE, 0, NULL, 0, NULL);
  return ftdiutil_flush_reads("op_xin_disable");
}

static status op_xin_read_counter(uint32_t* xin_counter) {
  uint8_t response[3];
  queue_op(OPCODE_XIN_READ_COUNTER, 0, NULL, sizeof(response), response);
  RETURN_IF_ERROR(ftdiutil_flush_reads("op_xin_read_counter"));
  *xin_counter = ((response[2] << 16) | (response[1] << 8) | response[0]);
  return OK;
}

static status op_int_wait() {
  uint8_t response;
  queue_op(OPCODE_INT_WAIT, 0, NULL, 1, &response);
  return ftdiutil_flush_reads("op_int_wait");
}

static status op_int_enabled(uint8_t* enabled) {
  queue_op(OPCODE_INT_ENABLED, 0, NULL, 1, enabled);
  return ftdiutil_flush_reads("op_int_enabled");
}

static status op_int_set_enabled(uint8_t enabled) {
  queue_op(OPCODE_INT_SET_ENABLED, 1, &enabled, 0, NULL);
  return ftdiutil_flush_reads("op_int_set_enabled");
}

static status op_int_triggered(uint8_t* triggered) {
  queue_op(OPCODE_INT_TRIGGERED, 0, NULL, 1, triggered);
  return ftdiutil_flush_reads("op_int_triggered");
}

static status op_int_clear() {
  queue_op(OPCODE_INT_CLEAR, 0, NULL, 0, NULL);
  return ftdiutil_flush_reads("op_int_clear");
}

static status op_ppu_reset() {
  queue_op(OPCODE_PPU_RESET, 0, NULL, 0, NULL);
  return ftdiutil_flush_reads("op_ppu_reset");
}

static status op_ppu_unreset() {
  queue_op(OPCODE_PPU_UNRESET, 0, NULL, 0, NULL);
  return ftdiutil_flush_reads("op_ppu_reset");
}

static status op_read_control(uint8_t* control) {
  queue_op(OPCODE_READ_CONTROL, 0, NULL, 1, control);
  return ftdiutil_flush_reads("op_read_control");
}

static bool control_vblank(uint8_t control) { return !!(control & 0x1); }

static bool control_hblank(uint8_t control) { return !!(control & 0x2); }

static bool control_csync_n(uint8_t control) { return !!(control & 0x4); }

static bool control_burst_n(uint8_t control) { return !!(control & 0x8); }

static void showcontrol(uint32_t cycle, uint8_t control, uint32_t* last_cycle) {
  int vblank = control_vblank(control);
  int hblank = control_hblank(control);
  int csync_n = control_csync_n(control);
  int burst_n = control_burst_n(control);
  int ppu2_resout0_n = ((control & 0x10) ? 1 : 0);
  int ppu2_resout1_n = ((control & 0x20) ? 1 : 0);
  int ppu1_reset_n = ((control & 0x40) ? 1 : 0);
  int ppu2_reset_n = ((control & 0x80) ? 1 : 0);
  printf(
      "%08d V %d H %d C %d B %d "
      "Rout0 %d Rout1 %d ppu1R %d ppu2R %d",
      cycle, vblank, hblank, csync_n, burst_n, ppu2_resout0_n, ppu2_resout1_n,
      ppu1_reset_n, ppu2_reset_n);
  if (last_cycle) {
    printf(" (+%4d)", cycle - *last_cycle);
  }
  printf("\n");
  fflush(stdout);
}

FILE* vcd_file = NULL;

static status vcd_open(const char* filename) {
  vcd_file = fopen(filename, "w");
  if (!vcd_file) {
    return errorf("couldn't open vcd file");
  }
  fprintf(vcd_file, "$timescale 1ps $end\n");
  fprintf(vcd_file, "$scope module snes $end\n");
  fprintf(vcd_file, "$var wire 1 H hblank $end\n");
  fprintf(vcd_file, "$var wire 1 V vblank $end\n");
  fprintf(vcd_file, "$var wire 1 C csync_n $end\n");
  fprintf(vcd_file, "$var wire 1 B burst_n $end\n");
  fprintf(vcd_file, "$var wire 9 L scanline $end\n");
  fprintf(vcd_file, "$var wire 11 P hblank_period $end\n");
  fprintf(vcd_file, "$upscope $end\n");
  fprintf(vcd_file, "$enddefinitions $end\n");
  fprintf(vcd_file, "$dumpvars\n");
  fprintf(vcd_file, "xH\n");
  fprintf(vcd_file, "xV\n");
  fprintf(vcd_file, "xC\n");
  fprintf(vcd_file, "xB\n");
  fprintf(vcd_file, "d0 L\n");
  fprintf(vcd_file, "$end\n");
  return OK;
}

static void vcd_log(uint32_t cycle, uint8_t control, int scanline,
                    int hblank_period) {
  fprintf(vcd_file, "#%d\n", cycle);
  fprintf(vcd_file, "%dH\n", control_hblank(control));
  fprintf(vcd_file, "%dV\n", control_vblank(control));
  fprintf(vcd_file, "%dC\n", control_csync_n(control));
  fprintf(vcd_file, "%dB\n", control_burst_n(control));
  fprintf(vcd_file, "b");
  for (int bit = 8; bit >= 0; bit--) {
    fprintf(vcd_file, "%c", scanline & (1 << bit) ? '1' : '0');
  }
  fprintf(vcd_file, " L\n");
  fprintf(vcd_file, "b");
  for (int bit = 10; bit >= 0; bit--) {
    fprintf(vcd_file, "%c", hblank_period & (1 << bit) ? '1' : '0');
  }
  fprintf(vcd_file, " P\n");
}

static void vcd_close() {
  fclose(vcd_file);
  vcd_file = NULL;
}

struct signal_analysis {
  const char* name;

  bool currently_high;
  uint32_t cycle_last_rise;
  uint32_t cycle_last_fall;

  uint32_t period;
};

void siganalysis_init(struct signal_analysis* sa, const char* name,
                      bool is_high) {
  sa->name = name;
  sa->currently_high = is_high;
  sa->cycle_last_rise = (uint32_t)-1;
  sa->cycle_last_fall = (uint32_t)-1;

  sa->period = 0;
}

static float MASTER_CLOCK_FREQUENCY = 21.477e6;

void siganalysis_inc(struct signal_analysis* sa, uint32_t cycle, bool is_high) {
  if ((is_high && sa->currently_high) || (!is_high && !sa->currently_high)) {
    // If there's no transition, return;
    return;
  }

  if (is_high) {
    if (sa->cycle_last_rise != (uint32_t)-1) {
      uint32_t period = cycle - sa->cycle_last_rise;
      if (sa->period != period) {
        sa->period = period;
        printf("Sig %s: period %d (approx %f Hz)\n", sa->name, period,
               MASTER_CLOCK_FREQUENCY / period);
      }
    }
  } else {
    if (sa->cycle_last_fall != (uint32_t)-1) {
      uint32_t period = cycle - sa->cycle_last_fall;
      if (sa->period != period) {
        sa->period = period;
        printf("Sig %s: period %d (approx %f Hz)\n", sa->name, period,
               MASTER_CLOCK_FREQUENCY / period);
      }
    }
  }

  sa->currently_high = is_high;
  if (is_high) {
    sa->cycle_last_rise = cycle;
  } else {
    sa->cycle_last_fall = cycle;
  }
}

static status measuretiming() {
  printf("=== measuretiming\n");
  uint8_t control;

  printf("op_reset\n");
  RETURN_IF_ERROR(op_reset());

  printf("ppu_reset\n");
  RETURN_IF_ERROR(op_ppu_reset());

  uint32_t cycle = 0;
  RETURN_IF_ERROR(op_read_control(&control));
  showcontrol(cycle, control, NULL);

  RETURN_IF_ERROR(op_xin_read_counter(&cycle));
  printf("xin_counter = %d\n", cycle);
  if (cycle != 0) {
    printf("Warning: xin_counter is nonzero on reset\n");
  }

  RETURN_IF_ERROR(op_read_control(&control));
  showcontrol(cycle, control, NULL);

  printf("ppu_unreset\n");
  RETURN_IF_ERROR(op_ppu_unreset());

  RETURN_IF_ERROR(op_read_control(&control));
  showcontrol(cycle, control, NULL);

  printf("int_set_enabled\n");
  uint8_t int_enabled = 0xff;
  RETURN_IF_ERROR(op_int_set_enabled(int_enabled));
  printf("xin_enable\n");
  RETURN_IF_ERROR(op_xin_enable());

  struct signal_analysis sa_vblank;
  struct signal_analysis sa_hblank;
  struct signal_analysis sa_csync_n;
  struct signal_analysis sa_burst_n;
  siganalysis_init(&sa_vblank, "vblank", control_vblank(control));
  siganalysis_init(&sa_hblank, "hblank", control_hblank(control));
  siganalysis_init(&sa_csync_n, "csync_n", control_csync_n(control));
  siganalysis_init(&sa_burst_n, "burst_n", control_burst_n(control));

  RETURN_IF_ERROR(vcd_open("timing.vcd"));

  int scanline = 0;
  int last_vblank = 1;
  int last_hblank = 1;

  printf("cycle\n");
  uint32_t last_cycle = 0;
  const uint32_t max_cycles = 2000000;
  while (cycle < max_cycles) {
    RETURN_IF_ERROR(op_xin_read_counter(&cycle));
    RETURN_IF_ERROR(op_read_control(&control));

    showcontrol(cycle, control, &last_cycle);
    if (int_enabled & 0x3) {
      siganalysis_inc(&sa_vblank, cycle, control_vblank(control));
    }
    if (int_enabled & 0xc) {
      siganalysis_inc(&sa_hblank, cycle, control_hblank(control));
    }
    if (int_enabled & 0x30) {
      siganalysis_inc(&sa_csync_n, cycle, control_csync_n(control));
    }
    if (int_enabled & 0xc0) {
      siganalysis_inc(&sa_burst_n, cycle, control_burst_n(control));
    }

    if (last_hblank && !control_hblank(control)) {
      scanline++;
      if (last_vblank && !control_vblank(control)) {
        scanline = 0;
      }
      last_vblank = control_vblank(control);
    }
    last_hblank = control_hblank(control);

    vcd_log(cycle, control, scanline, sa_hblank.period);

    last_cycle = cycle;

    RETURN_IF_ERROR(op_int_clear());
    RETURN_IF_ERROR(op_int_wait());
  }

  (void)op_int_wait;
  (void)op_int_triggered;
  (void)op_int_enabled;
  (void)op_int_clear;

  vcd_close();

  printf("xin_disable\n");
  RETURN_IF_ERROR(op_xin_disable());

  printf("ppu_reset\n");
  op_ppu_reset();

  RETURN_IF_ERROR(op_read_control(&control));
  showcontrol(cycle, control, NULL);

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
  bool flag_measuretiming = false;

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
    } else if (!strcmp(argv[0], "--measuretiming")) {
      flag_measuretiming = true;
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

  if (flag_measuretiming) {
    RETURN_IF_ERROR(measuretiming());
  }

  return OK;
}
