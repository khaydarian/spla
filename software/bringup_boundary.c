// vi: ts=2:sw=2:sts=2:et

#include <stdio.h>
#include <string.h>
#include "bitstream.h"
#include "command.h"
#include "ftdi.h"
#include "ftdiutil.h"
#include "pindef.h"
#include "uart.h"

#define CLEARSCREEN "[2J"
#define ORIGIN "[H"
#define CLEARLINE "[K"
#define BOLD "[1m"
#define GREEN "[92m"
#define RED "[91m"
#define BLUE "[94m"
#define RESET "[0m"

struct frame {
  unsigned int frameno;
  uint8_t current[23];
  const char* current_color;
  uint8_t good[23];
  const char* error;
};

const char* frame_bit(struct frame* f, uint8_t bit) {
  bit -= PINDEFMIN;
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

void frame_check_goodness(struct frame* f) {
  int n = 0;
  for (unsigned i = 1; i < sizeof(f->current); i++) {
    n += bits_set(f->current[i]);
  }
  if (n == 1) {
    f->current_color = BOLD GREEN;
    for (unsigned i = 1; i < sizeof(f->current); i++) {
      f->good[i] |= f->current[i];
    }
  }
  if (n > 1) {
    f->current_color = RED;
  }
}

void draw_frame(struct frame* f) {
  printf(ORIGIN "[FPGA Bringup - Boundary Scan Tool]" RESET "\n");
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
  printf("%sclk_12mhz%s ", frame_bit(f, PINDEF_CLK_12MHZ), RESET);
  printf("%sled7%s ", frame_bit(f, PINDEF_LED7), RESET);
  printf("%sled8%s\n", frame_bit(f, PINDEF_LED8), RESET);
  printf("fifo: d[");
  for (int i = 0; i < 8; i++) {
    printf("%s%d%s", frame_bit(f, PINDEF_FIFO_D_0 + i), i, RESET);
  }
  printf("] ");
  printf("%srxf_n%s ", frame_bit(f, PINDEF_FIFO_RXF_N), RESET);
  printf("%stxe_n%s ", frame_bit(f, PINDEF_FIFO_TXE_N), RESET);
  printf("%srd_n%s ", frame_bit(f, PINDEF_FIFO_RD_N), RESET);
  printf("%swr_n%s ", frame_bit(f, PINDEF_FIFO_WR_N), RESET);
  printf("%ssiwu%s ", frame_bit(f, PINDEF_FIFO_SIWU), RESET);
  printf("%sclkout%s ", frame_bit(f, PINDEF_FIFO_CLKOUT), RESET);
  printf("%soe_n%s\n", frame_bit(f, PINDEF_FIFO_OE_N), RESET);
  printf("%susb_pwren_n%s ", frame_bit(f, PINDEF_USB_PWREN_N), RESET);
  printf("%susb_suspend_n%s ", frame_bit(f, PINDEF_USB_SUSPEND_N), RESET);
  printf("%sxin%s\n", frame_bit(f, PINDEF_XIN), RESET);
  printf("%sppu1_reset_n%s ", frame_bit(f, PINDEF_PPU1_RESET_N), RESET);
  printf("%sppu2_reset_n%s ", frame_bit(f, PINDEF_PPU2_RESET_N), RESET);
  printf("%sppu2_resout0_n%s ", frame_bit(f, PINDEF_PPU2_RESOUT0_N), RESET);
  printf("%sppu2_resout1_n%s\n", frame_bit(f, PINDEF_PPU2_RESOUT1_N), RESET);
  printf("%sburst_n%s ", frame_bit(f, PINDEF_BURST_N), RESET);
  printf("%scsync_n%s ", frame_bit(f, PINDEF_CSYNC_N), RESET);
  printf("%sppu2_hblank%s ", frame_bit(f, PINDEF_PPU2_HBLANK), RESET);
  printf("%sppu2_vblank%s\n", frame_bit(f, PINDEF_PPU2_VBLANK), RESET);
  printf("%spard_n%s ", frame_bit(f, PINDEF_PARD_N), RESET);
  printf("%spawr_n%s ", frame_bit(f, PINDEF_PAWR_N), RESET);
  printf("%slvl_pa_dir%s ", frame_bit(f, PINDEF_LVL_PA_DIR), RESET);
  printf("pa[");
  for (int i = 0; i < 8; i++) {
    printf("%s%d%s", frame_bit(f, PINDEF_PA_0 + i), i, RESET);
  }
  printf("] ");
  printf("%slvl_pd_dir%s ", frame_bit(f, PINDEF_LVL_PD_DIR), RESET);
  printf("pd[");
  for (int i = 0; i < 8; i++) {
    printf("%s%d%s", frame_bit(f, PINDEF_PD_0 + i), i, RESET);
  }
  printf("]\n");
  printf("%slvl_va_dir%s ", frame_bit(f, PINDEF_LVL_VA_DIR), RESET);
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
  printf("%slvl_vd_dir%s ", frame_bit(f, PINDEF_LVL_VD_DIR), RESET);
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
  printf("%sppu2_tst15%s ", frame_bit(f, PINDEF_PPU2_TST15), RESET);
  printf("%slvl_tst_dir%s ", frame_bit(f, PINDEF_LVL_TST_DIR), RESET);
  printf("%slvl_tst_oe%s ", frame_bit(f, PINDEF_LVL_TST_OE), RESET);
  printf("vdb[");
  for (int i = 0; i < 8; i++) {
    printf("%s%d%s", frame_bit(f, PINDEF_VDB_0 + i), i, RESET);
  }
  printf("]\n");
  printf("ppu2_tst[%s0%s", frame_bit(f, PINDEF_PPU2_TST_0), RESET);
  for (int i = 1; i < 15; i++) {
    printf(" %s%d%s", frame_bit(f, PINDEF_PPU2_TST_0 + i), i, RESET);
  }
  printf("]\n");
  printf("ppu1: ");
  printf("%sextsync_n%s ", frame_bit(f, PINDEF_PPU1_EXTSYNC_N), RESET);
  printf("%shvcmode%s ", frame_bit(f, PINDEF_PPU1_HVCMODE), RESET);
  printf("%smaster_n%s ", frame_bit(f, PINDEF_PPU1_MASTER_N), RESET);
  printf("%spalmode%s\n", frame_bit(f, PINDEF_PPU1_PALMODE), RESET);
  printf("ppu2: ");
  printf("%s3p58m%s ", frame_bit(f, PINDEF_PPU2_3P58M), RESET);
  printf("%sped_n%s ", frame_bit(f, PINDEF_PPU2_PED_N), RESET);
  printf("%s5mout_n%s ", frame_bit(f, PINDEF_PPU2_5MOUT_N), RESET);
  printf("%stoumei_n%s ", frame_bit(f, PINDEF_PPU2_TOUMEI_N), RESET);
  printf("%sextlatch%s ", frame_bit(f, PINDEF_PPU2_EXTLATCH), RESET);
  printf("%shvcmode%s ", frame_bit(f, PINDEF_PPU2_HVCMODE), RESET);
  printf("%spalmode%s\n", frame_bit(f, PINDEF_PPU2_PALMODE), RESET);
  printf("%sextra1%s ", frame_bit(f, PINDEF_EXTRA1), RESET);
  printf("%sextra2%s ", frame_bit(f, PINDEF_EXTRA2), RESET);
  printf("%sextra3%s ", frame_bit(f, PINDEF_EXTRA3), RESET);
  printf("%sbodge1%s ", frame_bit(f, PINDEF_BODGE1), RESET);
  printf("%sbodge2%s ", frame_bit(f, PINDEF_BODGE2), RESET);
  printf("%sbodge3%s\n", frame_bit(f, PINDEF_BODGE3), RESET);
  printf("analog %sclock%s ", frame_bit(f, PINDEF_ANALOG_CLOCK), RESET);
  printf("r[%soe%s ", frame_bit(f, PINDEF_ANALOG_R_OE), RESET);
  for (int i = 0; i < 8; i++) {
    printf("%s%d%s", frame_bit(f, PINDEF_ANALOG_R_0 + i), i, RESET);
  }
  printf("] ");
  printf("g[%soe%s ", frame_bit(f, PINDEF_ANALOG_G_OE), RESET);
  for (int i = 0; i < 8; i++) {
    printf("%s%d%s", frame_bit(f, PINDEF_ANALOG_G_0 + i), i, RESET);
  }
  printf("] ");
  printf("b[%soe%s ", frame_bit(f, PINDEF_ANALOG_B_OE), RESET);
  for (int i = 0; i < 8; i++) {
    printf("%s%d%s", frame_bit(f, PINDEF_ANALOG_B_0 + i), i, RESET);
  }
  printf("]\n");
}

// [Command]
// Description: Run boundary testing.
// Option: open_usb = true
// Option: default_usb_device = board
status bringup_boundary(int argc, char** argv) {
  RETURN_IF_ERROR(no_arguments(argc, argv));

  const char* bringup_boundary_filename = "../rtl/build/bringup_boundary.bit";
  struct bitstream bits = {0};
  RETURN_IF_ERROR(load_bitstream_file(&bits, bringup_boundary_filename));
  RETURN_IF_ERROR(program_bitstream(&bits));
  free_bitstream(&bits);

  ftdiutil_set_interface(INTERFACE_A);
  uart_init();

  struct frame f;
  memset(&f, 0, sizeof(f));

  printf(ORIGIN CLEARSCREEN);
  draw_frame(&f);

  uint8_t buf[1024];
  while (true) {
    int ret = ftdi_read_data(ftdi, buf, sizeof(buf));
    if (ret < 0) {
      return ftdiutil_error("ftdi_read_data", ret);
    }
    f.frameno++;
    if (ret == 0) {
      draw_frame(&f);
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
