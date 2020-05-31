// vi: ts=2:sw=2:sts=2:et

#include "command.h"
#include "ecp5.h"

// [Command]
// Description: Reset the FPGA, leaving bitstream unconfigured.
// Option: open_usb = true
// Option: default_usb_device = board
status fpga_reset(int argc, char** argv) {
  RETURN_IF_ERROR(no_arguments(argc, argv));

  RETURN_IF_ERROR(ecp5_init());
  RETURN_IF_ERROR(ecp5_reset());
  RETURN_IF_ERROR(ecp5_release_reset());
  return OK;
}
