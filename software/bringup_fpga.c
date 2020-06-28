// vi: ts=2:sw=2:sts=2:et

#include <stdio.h>
#include <string.h>
#include "bitstream.h"
#include "command.h"

// [Command]
// Description: Program the led-flasher bringup image.
// Option: open_usb = true
// Option: default_usb_device = board
status bringup_fpga(int argc, char** argv) {
  RETURN_IF_ERROR(no_arguments(argc, argv));

  const char* bringup_boundary_filename = "../rtl/build/bringup.bit";
  struct bitstream bits = {0};
  RETURN_IF_ERROR(load_bitstream_file(&bits, bringup_boundary_filename));
  RETURN_IF_ERROR(program_bitstream(&bits));
  free_bitstream(&bits);

  return OK;
}
