// vi: ts=2:sw=2:sts=2:et

#include <assert.h>
#include <stdio.h>
#include <unistd.h>
#include "command.h"
#include "ftdi.h"
#include "ftdiutil.h"
#include "mpsse.h"

// [Command]
// Description: Bringup check for basic FTDI functionality.
// Option: open_usb = true
// Option: default_usb_device = new
status bringup_first(int argc, char** argv) {
  RETURN_IF_ERROR(no_arguments(argc, argv));

  ftdiutil_set_interface(INTERFACE_A);
  RETURN_IF_ERROR(mpsse_init());
  ftdiutil_set_interface(INTERFACE_B);
  RETURN_IF_ERROR(mpsse_init());

  unsigned char val = 0x01;

  for (int i = 0; i < 40; i++) {
    mpsse_set_data_bits_high_dir(0xff, 0x01, val);
    RETURN_IF_ERROR(ftdiutil_flush_writes(NULL));
    printf("Value: 0x%02x\n", val);
    usleep(500000);
    val = val ^ 0x01;
  }

  return OK;
}
