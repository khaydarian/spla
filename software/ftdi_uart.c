// vi: ts=2:sw=2:sts=2:et

#include <stdio.h>
#include <string.h>
#include <poll.h>
#include <unistd.h>
#include "command.h"
#include "ftdi.h"
#include "ftdiutil.h"
#include "uart.h"

// [Command]
// Description: Test FTDI UART mode.  Requires matching FPGA image.
// Option: open_usb = true
// Option: default_usb_device = board
status ftdi_uart(int argc, char** argv) {
  bool hex = false;
  if (argc == 1 && !strcmp(argv[0], "--hex")) {
    hex = true;
    argc--;
    argv++;
  }
  RETURN_IF_ERROR(no_arguments(argc, argv));

  ftdiutil_set_interface(INTERFACE_A);
  uart_init();

  const char* c_green = "[32m";
  const char* c_reset = "[0m";

  printf("%sFPGA Serial Console%s\n", c_green, c_reset);
  printf("%sCtrl-C to exit.%s\n", c_green, c_reset);
  uint8_t buf[1024];

  struct pollfd pollfds[] = {
    {
      .fd = 0,  // stdin
      .events = POLLIN,
    },
  };

  while (true) {
    int ret = ftdi_read_data(ftdi, buf, sizeof(buf));
    if (ret < 0) {
      return ftdiutil_error("ftdi_read_data", ret);
    }
    if (ret) {
      if (hex) {
        printf("[");
        for (int i = 0; i < ret; i++) {
          printf("%02x", buf[i]);
        }
        printf("]\n");
      } else {
        fwrite(buf, ret, 1, stdout);
      }
      fflush(stdout);
    }
    ret = poll(pollfds, sizeof(pollfds) / sizeof(pollfds[0]), 0);
    if (pollfds[0].revents | POLLIN) {
      int n = read(pollfds[0].fd, buf, sizeof(buf));
      if (n > 0) {
        printf("read %d\n", n);
        ret = ftdi_write_data(ftdi, buf, n);
        if (ret < 0) {
          return ftdiutil_error("ftdi_write_data", ret);
        }
      }
    }
  }

  return OK;
}
