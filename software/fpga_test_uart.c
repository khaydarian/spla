// vi: ts=2:sw=2:sts=2:et

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include "bitstream.h"
#include "command.h"
#include "ftdi.h"
#include "ftdiutil.h"
#include "uart.h"

static void chincrement(int* chp) {
  int ch = *chp;
  if (('a' <= ch) && (ch <= 'y')) {
    ch++;
  } else if (ch == 'z') {
    ch = 'A';
  } else if (('A' <= ch) && (ch <= 'Y')) {
    ch++;
  } else if (ch == 'Z') {
    ch = 'a';
  } else {
    ch = 'a';
  }
  *chp = ch;
}

// [Command]
// Description: Test FTDI UART round-trip.
// Option: open_usb = true
// Option: default_usb_device = board
status fpga_test_uart(int argc, char** argv) {
  RETURN_IF_ERROR(no_arguments(argc, argv));

  const char* bitstream_filename = "../rtl/build/test_uart.bit";
  struct bitstream bits = {0};
  RETURN_IF_ERROR(load_bitstream_file(&bits, bitstream_filename));
  RETURN_IF_ERROR(program_bitstream(&bits));
  free_bitstream(&bits);

  ftdiutil_set_interface(INTERFACE_A);
  uart_init();

  usleep(1000000); // 1 s

  uint8_t buf[1024];
  int ch = 0x41;

  while (true) {
    buf[0] = ch;
    int ret = ftdi_write_data(ftdi, buf, 1);
    if (ret < 0) {
      return ftdiutil_error("ftdi_read_data", ret);
    }
    usleep(1000000); // ~1Hz
    ret = ftdi_read_data(ftdi, buf, sizeof(buf));
    if (ret < 0) {
      return ftdiutil_error("ftdi_read_data", ret);
    }
    if (ret) {
      printf("%d", ret);
      //printf("[");
      //for (int i = 0; i < ret; i++) {
      //  printf("%02x", buf[i]);
      //}
      //printf("]");
      //fwrite(buf, ret, 1, stdout);
      fflush(stdout);
    }
    (void)chincrement;
    //chincrement(&ch);
  }

  return OK;
}
