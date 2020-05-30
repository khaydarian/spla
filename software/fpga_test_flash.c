// vi: ts=2:sw=2:sts=2:et

#include <stdio.h>
#include <unistd.h>
#include "command.h"
#include "ecp5.h"
#include "ftdi.h"
#include "ftdiutil.h"

// [Command]
// Description: Test flashing D3 and D4 (PROGRAM)
// Option: open_usb = true
// Option: default_usb_device = board
status fpga_test_flash(int argc, char** argv) {
  RETURN_IF_ERROR(no_arguments(argc, argv));

  RETURN_IF_ERROR(ecp5_init());

  for (int i = 0; i < 20; i++) {
    printf("---\n");
    ecp5_set_program(false);
    RETURN_IF_ERROR(ftdiutil_flush_writes("ecp5_set_program"));
    usleep(500000);
    ecp5_set_led3(false);
    RETURN_IF_ERROR(ftdiutil_flush_writes("ecp5_set_led3"));
    usleep(500000);
    ecp5_set_program(true);
    RETURN_IF_ERROR(ftdiutil_flush_writes("ecp5_set_program"));
    usleep(500000);
    ecp5_set_led3(true);
    RETURN_IF_ERROR(ftdiutil_flush_writes("ecp5_set_led3"));
    usleep(500000);
  }
  return OK;
}
