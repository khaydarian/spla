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

  while (true) {
    mpsse_get_data_bits_low(&low);
    mpsse_get_data_bits_high(&high);
    RETURN_IF_ERROR(ftdiutil_flush_reads("mpsse_get_data_bits_low/high"));

    if (low != last_low || high != last_high) {
      printf("high ");
      print_bits(high, 0xef);
      printf(" low ");
      print_bits(low, 0xff);
      printf("\n");
      last_low = low;
      last_high = high;
    }

    usleep(10000);
  }

  return OK;
}
