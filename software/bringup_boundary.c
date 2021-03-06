// vi: ts=2:sw=2:sts=2:et

#include <stdio.h>
#include <string.h>
#include "bitstream.h"
#include "color.h"
#include "command.h"
#include "ftdi.h"
#include "ftdiutil.h"
#include "pindef.h"
#include "uart.h"

#define MODE_BOUNDARY 0
#define MODE_LEVELSHIFTER1 1
#define MODE_LEVELSHIFTER2 2

struct frame {
  unsigned int frameno;
  uint8_t current[23];
  const char* current_color;
  uint8_t good[23];
  const char* error;
};

static const char* frame_bit(struct frame* f, uint8_t bit) {
  int byte = bit / 8 + 1;
  int mask = 1 << (bit % 8);
  bool is_current = (bool)(f->current[byte] & mask);
  bool is_good = (bool)(f->good[byte] & mask);
  if (is_current) {
    return f->current_color;
  }
  if (is_good) {
    return BLUE;
  }
  return RESET;
}

static int nibblebits[] = {0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4};
static int bits_set(uint8_t x) {
  return nibblebits[x & 0xf] + nibblebits[x >> 4];
}

static const char* GOODNESS_FILE = "./build/bringup_boundary.goodness.bin";

static void frame_load_goodness(struct frame* f) {
  FILE* file = fopen(GOODNESS_FILE, "r");
  if (!file) {
    // Ok if there's no goodness file yet.
    return;
  }
  fread(f->good, sizeof(f->good), 1, file);
  fclose(file);
}

static void frame_save_goodness(struct frame* f) {
  FILE* file = fopen(GOODNESS_FILE, "w");
  if (!file) {
    // Can't save goodness? Er, ok.
    return;
  }
  fwrite(f->good, sizeof(f->good), 1, file);
  fclose(file);
}

static void frame_check_goodness(struct frame* f) {
  int n = 0;
  for (unsigned i = 1; i < sizeof(f->current); i++) {
    n += bits_set(f->current[i]);
  }
  if (n == 1) {
    f->current_color = BOLD GREEN;
    for (unsigned i = 1; i < sizeof(f->current); i++) {
      f->good[i] |= f->current[i];
    }
    frame_save_goodness(f);
  }
  if (n > 1) {
    f->current_color = RED;
  }
}

static void draw_frame(struct frame* f, int mode) {
  printf(ORIGIN "[FPGA Bringup - Boundary Scan Tool - ");
  switch (mode) {
    case MODE_BOUNDARY:
      printf("Basic");
      break;
    case MODE_LEVELSHIFTER1:
      printf("Level Shifted Inputs");
      break;
  }
  printf("]" RESET "\n");
  printf("Frame: %d\n", f->frameno);
  if (f->error) {
    printf(RED "Error: %s" RESET CLEARLINE "\n", f->error);
  } else {
    printf("Status: Ok." CLEARLINE "\n");
  }
  printf("[%02x", f->current[1]);
  for (unsigned i = 2; i < sizeof(f->current); i++) {
    printf(" %s%02x" RESET, f->current[i] ? GREEN : RESET, f->current[i]);
  }
  printf("]\n");
  // clk_12mhz has to work by this point.
  // fifo already tested by bringup_fifo.
  if (mode == MODE_BOUNDARY) {
    printf("%sled_a%s ", frame_bit(f, PINDEF_LED_A), RESET);
    printf("%sled_b%s ", frame_bit(f, PINDEF_LED_B), RESET);
    printf("%sled_c%s ", frame_bit(f, PINDEF_LED_C), RESET);
    printf("%sled_d%s\n", frame_bit(f, PINDEF_LED_D), RESET);
    printf("%susb_pwren_n%s ", frame_bit(f, PINDEF_USB_PWREN_N), RESET);
    printf("%susb_suspend_n%s ", frame_bit(f, PINDEF_USB_SUSPEND_N), RESET);
    printf("%sxin%s\n", frame_bit(f, PINDEF_XIN), RESET);
    printf("%sppu1_reset_n%s ", frame_bit(f, PINDEF_PPU1_RESET_N), RESET);
    printf("%sppu2_reset_n%s ", frame_bit(f, PINDEF_PPU2_RESET_N), RESET);
  }
  printf("%sppu2_resout0_n%s ", frame_bit(f, PINDEF_PPU2_RESOUT0_N), RESET);
  printf("%sppu2_resout1_n%s\n", frame_bit(f, PINDEF_PPU2_RESOUT1_N), RESET);
  printf("%sburst_n%s ", frame_bit(f, PINDEF_BURST_N), RESET);
  printf("%scsync_n%s ", frame_bit(f, PINDEF_CSYNC_N), RESET);
  printf("%shblank%s ", frame_bit(f, PINDEF_HBLANK), RESET);
  printf("%svblank%s\n", frame_bit(f, PINDEF_VBLANK), RESET);
  if (mode == MODE_BOUNDARY) {
    printf("%spard_n%s ", frame_bit(f, PINDEF_PARD_N), RESET);
    printf("%spawr_n%s ", frame_bit(f, PINDEF_PAWR_N), RESET);
    printf("%slvl_pa_dir%s ", frame_bit(f, PINDEF_LVL_PA_DIR), RESET);
  }
  printf("pa[");
  for (int i = 0; i < 8; i++) {
    printf("%s%d%s", frame_bit(f, PINDEF_PA_0 + i), i, RESET);
  }
  printf("] ");
  if (mode == MODE_BOUNDARY) {
    printf("%slvl_pd_dir%s ", frame_bit(f, PINDEF_LVL_PD_DIR), RESET);
  }
  printf("pd[");
  for (int i = 0; i < 8; i++) {
    printf("%s%d%s", frame_bit(f, PINDEF_PD_0 + i), i, RESET);
  }
  printf("]\n");
  if (mode == MODE_BOUNDARY) {
    printf("%slvl_va_dir%s ", frame_bit(f, PINDEF_LVL_VA_DIR), RESET);
  }
  printf("%svrd_n%s ", frame_bit(f, PINDEF_VRD_N), RESET);
  printf("%svawr_n%s ", frame_bit(f, PINDEF_VAWR_N), RESET);
  printf("%svbwr_n%s\n", frame_bit(f, PINDEF_VBWR_N), RESET);
  printf("%sva14%s ", frame_bit(f, PINDEF_VA14), RESET);
  printf("vaa[%s0%s", frame_bit(f, PINDEF_VAA_0), RESET);
  for (int i = 1; i < 14; i++) {
    printf(" %s%d%s", frame_bit(f, PINDEF_VAA_0 + i), i, RESET);
  }
  printf("] ");
  printf("vab[%s0%s", frame_bit(f, PINDEF_VAB_0), RESET);
  for (int i = 1; i < 14; i++) {
    printf(" %s%d%s", frame_bit(f, PINDEF_VAB_0 + i), i, RESET);
  }
  printf("]\n");
  if (mode == MODE_BOUNDARY) {
    printf("%slvl_vd_dir%s ", frame_bit(f, PINDEF_LVL_VD_DIR), RESET);
  }
  printf("vda[");
  for (int i = 0; i < 8; i++) {
    printf("%s%d%s", frame_bit(f, PINDEF_VDA_0 + i), i, RESET);
  }
  printf("] ");
  printf("vdb[");
  for (int i = 0; i < 8; i++) {
    printf("%s%d%s", frame_bit(f, PINDEF_VDB_0 + i), i, RESET);
  }
  printf("]\n");
  printf("%sfield%s ", frame_bit(f, PINDEF_FIELD), RESET);
  printf("%sover_n%s ", frame_bit(f, PINDEF_OVER_N), RESET);
  printf("%sppu_5m%s ", frame_bit(f, PINDEF_PPU_5M), RESET);
  printf("%shcld_n%s ", frame_bit(f, PINDEF_HCLD_N), RESET);
  printf("%svcld_n%s ", frame_bit(f, PINDEF_VCLD_N), RESET);
  printf("color[%s0%s%s1%s%s2%s] ", frame_bit(f, PINDEF_COLOR_0), RESET,
         frame_bit(f, PINDEF_COLOR_1), RESET, frame_bit(f, PINDEF_COLOR_2),
         RESET);
  printf("prio[%s0%s%s1%s] ", frame_bit(f, PINDEF_PRIO_0), RESET,
         frame_bit(f, PINDEF_PRIO_1), RESET);
  printf("chr[%s0%s%s1%s%s2%s%s3%s]\n", frame_bit(f, PINDEF_CHR_0), RESET,
         frame_bit(f, PINDEF_CHR_1), RESET, frame_bit(f, PINDEF_CHR_2), RESET,
         frame_bit(f, PINDEF_CHR_3), RESET);
  if (mode != MODE_LEVELSHIFTER1) {
    printf("%sppu2_tst15%s ", frame_bit(f, PINDEF_PPU2_TST15), RESET);
  }
  if (mode == MODE_BOUNDARY) {
    printf("%slvl_tst_dir%s ", frame_bit(f, PINDEF_LVL_TST_DIR), RESET);
    printf("%slvl_tst_oe%s ", frame_bit(f, PINDEF_LVL_TST_OE), RESET);
  }
  printf("ppu2_tst[%s0%s", frame_bit(f, PINDEF_PPU2_TST_0), RESET);
  for (int i = 1; i < 15; i++) {
    printf(" %s%d%s", frame_bit(f, PINDEF_PPU2_TST_0 + i), i, RESET);
  }
  printf("]\n");
  if (mode != MODE_LEVELSHIFTER1) {
    printf("ppu1: ");
    printf("%sextsync_n%s ", frame_bit(f, PINDEF_PPU1_EXTSYNC_N), RESET);
    printf("%shvcmode%s ", frame_bit(f, PINDEF_PPU1_HVCMODE), RESET);
    printf("%smaster_n%s ", frame_bit(f, PINDEF_PPU1_MASTER_N), RESET);
    printf("%spalmode%s\n", frame_bit(f, PINDEF_PPU1_PALMODE), RESET);
  }
  printf("ppu2: ");
  printf("%s3p58m%s ", frame_bit(f, PINDEF_PPU2_3P58M), RESET);
  printf("%sped_n%s ", frame_bit(f, PINDEF_PPU2_PED_N), RESET);
  printf("%s5mout_n%s ", frame_bit(f, PINDEF_PPU2_5MOUT_N), RESET);
  printf("%stoumei_n%s ", frame_bit(f, PINDEF_PPU2_TOUMEI_N), RESET);
  if (mode != MODE_LEVELSHIFTER1) {
    printf("%sextlatch%s ", frame_bit(f, PINDEF_PPU2_EXTLATCH), RESET);
    printf("%shvcmode%s ", frame_bit(f, PINDEF_PPU2_HVCMODE), RESET);
    printf("%spalmode%s", frame_bit(f, PINDEF_PPU2_PALMODE), RESET);
  }
  printf("\n");
  if (mode == MODE_BOUNDARY) {
    printf("%sextra1%s ", frame_bit(f, PINDEF_EXTRA1), RESET);
    printf("%sextra2%s ", frame_bit(f, PINDEF_EXTRA2), RESET);
    // extra3 is the driving signal.
  }
  if (mode != MODE_LEVELSHIFTER1) {
    printf("%sbodge1%s ", frame_bit(f, PINDEF_BODGE1), RESET);
    printf("%sbodge2%s ", frame_bit(f, PINDEF_BODGE2), RESET);
    printf("%sbodge3%s\n", frame_bit(f, PINDEF_BODGE3), RESET);
  }
  if (mode == MODE_BOUNDARY) {
    printf("analog %sclock%s %soe_n%s ", frame_bit(f, PINDEF_ANALOG_CLOCK),
           RESET, frame_bit(f, PINDEF_ANALOG_OE_N), RESET);
    printf("r[");
    for (int i = 0; i < 8; i++) {
      printf("%s%d%s", frame_bit(f, PINDEF_ANALOG_R_0 + i), i, RESET);
    }
    printf("] ");
    printf("g[");
    for (int i = 0; i < 8; i++) {
      printf("%s%d%s", frame_bit(f, PINDEF_ANALOG_G_0 + i), i, RESET);
    }
    printf("] ");
    printf("b[");
    for (int i = 0; i < 8; i++) {
      printf("%s%d%s", frame_bit(f, PINDEF_ANALOG_B_0 + i), i, RESET);
    }
    printf("]\n");
  }
}

// [Command]
// Description: Run boundary testing.
// Option: open_usb = true
// Option: default_usb_device = board
status bringup_boundary(int argc, char** argv) {
  int mode = MODE_BOUNDARY;

  while (argc) {
    if (!strcmp(argv[0], "--levelshifter1")) {
      mode = MODE_LEVELSHIFTER1;
      argc--;
      argv++;
    } else if (!strcmp(argv[0], "--levelshifter2")) {
      mode = MODE_LEVELSHIFTER2;
      argc--;
      argv++;
    } else {
      return errorf("Unknown flag: %s", argv[0]);
    }
  }

  const char* bitstream_filename;
  switch (mode) {
    case MODE_BOUNDARY:
      bitstream_filename = "../rtl/build/bringup_boundary.bit";
      break;
    case MODE_LEVELSHIFTER1:
      bitstream_filename = "../rtl/build/bringup_levelshifter1.bit";
      break;
    case MODE_LEVELSHIFTER2:
      bitstream_filename = "../rtl/build/bringup_levelshifter2.bit";
      break;
    default:
      return errorf("bad mode %d", mode);
  }

  struct bitstream bits = {0};
  RETURN_IF_ERROR(load_bitstream_file(&bits, bitstream_filename));
  RETURN_IF_ERROR(program_bitstream(&bits));
  free_bitstream(&bits);

  if (mode == MODE_LEVELSHIFTER2) {
    // This is for testing output-only pins, so we can't get any useful data
    // from the host.  Resort to scope probing.
    return OK;
  }

  ftdiutil_set_interface(INTERFACE_A);
  RETURN_IF_ERROR(uart_init());

  struct frame f;
  memset(&f, 0, sizeof(f));

  frame_load_goodness(&f);

  printf(ORIGIN CLEARSCREEN);
  draw_frame(&f, mode);

  uint8_t buf[1024];
  while (true) {
    int ret = ftdi_read_data(ftdi, buf, sizeof(buf));
    if (ret < 0) {
      return ftdiutil_error("ftdi_read_data", ret);
    }
    f.frameno++;
    if (ret == 0) {
      draw_frame(&f, mode);
      fflush(stdout);
    } else if (ret != 23) {
      f.error = "not 23 bytes";
      memset(f.current, 0, 23);
    } else if (buf[0] != 0xf0) {
      f.error = "desync (missing 0xf0)";
      memset(f.current, 0, 23);
    } else {
      f.error = 0;
      memcpy(f.current, buf, 23);
    }
    frame_check_goodness(&f);
  }

  return OK;
}
