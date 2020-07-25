// vi: ts=2:sw=2:sts=2:et

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include "bitstream.h"
#include "command.h"
#include "ftdi.h"
#include "ftdiutil.h"
#include "mpsse.h"
#include "uart.h"

static void print_bits(unsigned char b, unsigned char mask) {
  for (int i = 0; i < 8; i++) {
    if (mask & 0x80) {
      printf("%d", (b >> 7) & 1);
    } else {
      printf("-");
    }
    b <<= 1;
    mask <<= 1;
  }
}

static int bits_set(uint16_t x) {
  static int nibble[] = {0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4};
  return (nibble[(x >> 0) & 0xf] + nibble[(x >> 4) & 0xf] +
          nibble[(x >> 8) & 0xf] + nibble[(x >> 12) & 0xf]);
}

static bool pattern_good(uint16_t pattern) {
  pattern &= 0xefff;  // Ignore NC pin.
  return bits_set(pattern) == 1;
}

static uint32_t patterns_found[65536 / 32] = {0};
static int patterns_good = 0;
static int patterns_bad = 0;

static void found_pattern(uint16_t pattern) {
  int word = pattern / 32;
  int bit = 1 << (pattern % 32);
  if (patterns_found[word] & bit) {
    return;
  }
  patterns_found[word] |= bit;
  if (pattern_good(pattern)) {
    patterns_good++;
  } else {
    patterns_bad++;
  }
}

#define PASS_GOOD_PATTERNS 15

#define GREEN "[92m"
#define RED "[91m"
#define RESET "[0m"

// [Command]
// Description: Test FTDI FIFO pins.
// Option: open_usb = true
// Option: default_usb_device = board
status bringup_fifo(int argc, char** argv) {
  RETURN_IF_ERROR(no_arguments(argc, argv));

  const char* bringup_boundary_filename = "../rtl/build/bringup_fifo.bit";
  struct bitstream bits = {0};
  RETURN_IF_ERROR(load_bitstream_file(&bits, bringup_boundary_filename));
  RETURN_IF_ERROR(program_bitstream(&bits));
  free_bitstream(&bits);

  ftdiutil_set_interface(INTERFACE_A);
  mpsse_init();

  unsigned char last_low, last_high;
  unsigned char low, high;

  int i = 0;

  while (true) {
    mpsse_get_data_bits_low(&low);
    mpsse_get_data_bits_high(&high);
    RETURN_IF_ERROR(ftdiutil_flush_reads("mpsse_get_data_bits_low/high"));

    if (low != last_low || high != last_high) {
      printf("high ");
      print_bits(high, 0xef);
      printf(" low ");
      print_bits(low, 0xff);

      uint16_t pattern = (high << 8) | low;
      printf(" = %s%s" RESET,
          pattern_good(pattern) ? GREEN : RED,
          pattern_good(pattern) ? "ok" : "no");
      if (i++ == 100) {
        memset(patterns_found, 0, sizeof(patterns_found));
        patterns_good = 0;
        patterns_bad = 0;
        i = 0;
      }
      found_pattern(pattern);
      printf(" : good %2d / %2d, bad %d ", patterns_good, PASS_GOOD_PATTERNS,
             patterns_bad);
      if (patterns_bad) {
        printf(RED "FAIL" RESET);
      } else if (patterns_good == PASS_GOOD_PATTERNS) {
        printf(GREEN "PASS" RESET);
      } else {
        printf("----");
      }
      printf("\n");
      last_low = low;
      last_high = high;
    }

    usleep(10000);
  }

  return OK;
}
