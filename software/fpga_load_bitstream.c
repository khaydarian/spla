// vi: ts=2:sw=2:sts=2:et

#include "bitstream.h"
#include "command.h"

// [Command]
// Description: Load a bitstream file into the FPGA.
// Option: open_usb = true
// Option: default_usb_device = board
status fpga_load_bitstream(int argc, char** argv) {
  if (argc != 1) {
    return errorf("Expected 1 file argument.");
  }
  char* filename = argv[0];

  struct bitstream bits;
  RETURN_IF_ERROR(load_bitstream_file(&bits, filename));

  status err = program_bitstream(&bits);

  free_bitstream(&bits);
  return err;
}
