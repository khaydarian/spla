// vi: ts=2:sw=2:sts=2:et

#include "command.h"
#include "ftdi.h"
#include "ftdiutil.h"
#include "status.h"

#include <stdio.h>
#include <unistd.h>

// [Command]
// Description: Test FTDI interface by toggling GPIOs.
// Option: open_usb = true
// Option: default_usb_device = cable
status ftdi_test_toggle(int argc, char** argv) {
  RETURN_IF_ERROR(no_arguments(argc, argv));

  status err = OK;

  int ret = ftdi_set_bitmode(ftdi, 0xFF, BITMODE_BITBANG);
  if (ret) {
    err = ftdiutil_error("ftdi_set_bitmode", ret);
  } else {
    unsigned char buf[1];

    for (int i = 0; i < 100; i++) {
      printf("On\n");
      buf[0] = 0xFF;
      ret = ftdi_write_data(ftdi, buf, 1);
      if (ret < 0) {
        err = ftdiutil_error("ftdi_write_data", ret);
        break;
      }
      usleep(1000000);
      printf("Off\n");
      buf[0] = 0x0;
      ret = ftdi_write_data(ftdi, buf, 1);
      if (ret < 0) {
        err = ftdiutil_error("ftdi_write_data", ret);
        break;
      }
      usleep(1000000);
    }
  }

  // Reset all pins to inputs / hi-z.
  // ret = ftdi_set_bitmode(ftdi, 0x00, BITMODE_BITBANG);
  // if (ret) {
  //	err = ftdiutil_error("ftdi_set_bitmode", ret);
  //}

  return err;
}
