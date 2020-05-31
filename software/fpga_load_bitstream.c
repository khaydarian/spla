// vi: ts=2:sw=2:sts=2:et

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "command.h"
#include "ecp5.h"
#include "ftdi.h"
#include "ftdiutil.h"
#include "load_bitstream.h"

static status program_bitstream(struct bitstream* bits) {
  RETURN_IF_ERROR(ecp5_init());

  RETURN_IF_ERROR(ecp5_reset());

  uint32_t id;
  RETURN_IF_ERROR(ecp5_read_id(&id));
  printf("Read ID: 0x%08x\n", id);

  if (id != ECP5_CHIP_ID_LFE5U_45) {
    status_ignore(ecp5_release_reset());
    return errorf("Wrong Chip ID 0x%08x: broken board?", id);
  }

  RETURN_IF_ERROR(load_bitstream(bits));

  RETURN_IF_ERROR(ecp5_release_reset());
  return OK;
}

// [Command]
// Description: Load a bitstream file into the FPGA.
// Option: open_usb = true
// Option: default_usb_device = board
status fpga_load_bitstream(int argc, char** argv) {
  if (argc != 1) {
    return errorf("Expected 1 file argument.");
  }
  char* filename = argv[0];

  struct bitstream bits = {0};
  status err = read_bitstream_file(&bits, filename);
  if (is_error(err)) {
    bitstream_free(&bits);
    return err;
  }

  err = program_bitstream(&bits);
  bitstream_free(&bits);
  return err;
}
