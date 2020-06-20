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

static status load_bitstream_file(const char* filename, uint8_t** data, unsigned int* size) {
  FILE* f = fopen(filename, "r");
  if (!f) {
    return errorf("%s: %s", filename, strerror(errno));
  }
  fseek(f, 0, SEEK_END);
  *size = ftell(f);
  fseek(f, 0, SEEK_SET);
  *data = malloc(*size);
  fread(*data, *size, 1, f);
  fclose(f);
  return OK;
}

static void progress(unsigned int size, unsigned int total_size) {
  printf("\r%07d / %07d bytes = %5.1f%%", size, total_size,
         100. * size / total_size);
  fflush(stdout);
  if (size == total_size) {
    printf("\n");
  }
}

static status program_bitstream(uint8_t* bitstream, unsigned int size) {
  // [e0000000] READ_ID
  uint32_t id;
  RETURN_IF_ERROR(ecp5_read_id(&id));
  if (id != ECP5_CHIP_ID_LFE5U_45) {
    status_ignore(ecp5_release_reset());
    return errorf("Wrong Chip ID 0x%08x: broken board?", id);
  }
  printf("Read ID: 0x%08x OK\n", id);

  // [c6000000] ISC_ENABLE
  // Wait 1ms.
  RETURN_IF_ERROR(ecp5_isc_enable());

  // [3c000000] READ_STATUS
  uint32_t statusval;
  RETURN_IF_ERROR(ecp5_read_status(&statusval));
  ecp5_debug_status_dump(statusval);
  if (!ecp5_status_is_offline(statusval)) {
    return errorf("expected to be in offline mode");
  }

  // [0e010000] ERASE, with unknown argument
  // Wait 200ms.
  RETURN_IF_ERROR(ecp5_erase());

  // [46000000] LSC_INIT_ADDRESS
  RETURN_IF_ERROR(ecp5_init_address());

  // [7a000000] LSC_BITSTREAM_BURST
  RETURN_IF_ERROR(ecp5_bitstream_burst(bitstream, size, progress));

  // Wait 10ms.
  usleep(10000);

  // [3c000000] READ_STATUS
  RETURN_IF_ERROR(ecp5_read_status(&statusval));
  ecp5_debug_status_dump(statusval);
  if (!ecp5_status_is_done(statusval)) {
    return errorf("expected done bit to be set");
  }

  // [26000000] ISC_DISABLE
  // Wait 1ms.
  RETURN_IF_ERROR(ecp5_isc_disable());

  // Wait 200ms.
  usleep(200000);

  // [ffffffff] NOP
  RETURN_IF_ERROR(ecp5_write_idle_bytes(4));

  return OK;
}

static status program_bitstream_with_reset(uint8_t* bitstream, unsigned int size) {
  RETURN_IF_ERROR(ecp5_init());
  RETURN_IF_ERROR(ecp5_reset());
  status err = program_bitstream(bitstream, size);
  status_ignore(ecp5_release_reset());
  return err;
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

  uint8_t* data;
  unsigned int size;
  RETURN_IF_ERROR(load_bitstream_file(filename, &data, &size));

  status err = program_bitstream_with_reset(data, size);

  free(data);

  return err;
}
