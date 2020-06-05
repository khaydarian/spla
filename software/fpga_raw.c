
// vi: ts=2:sw=2:sts=2:et

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "command.h"
#include "ecp5.h"
#include "ftdi.h"
#include "ftdiutil.h"
#include "mpsse.h"
#include "load_bitstream.h"

static status read_and_load_bitstream(char* filename) {
  struct bitstream bits = {0};
  status err = read_bitstream_file(&bits, filename);
  if (is_error(err)) {
    bitstream_free(&bits);
    return err;
  }
  err = load_bitstream_raw(&bits);
  bitstream_free(&bits);
  return err;
}

static int single_command(int argc, char** argv) {
  assert(argc > 0);
  char* command = argv[0];
  printf("--- %s\n", command);
  if (!strcmp(command, "s") || !strcmp(command, "status")) {
    uint32_t statusval;
    status_ignore(ecp5_read_status(&statusval));
    ecp5_debug_status_dump(statusval);
    return 1;
  }
  if (!strcmp(command, "init")) {
    status_ignore(ecp5_init());
    return 1;
  }
  if (!strcmp(command, "reset")) {
    status_ignore(ecp5_reset());
    return 1;
  }
  if (!strcmp(command, "release_reset")) {
    status_ignore(ecp5_release_reset());
    return 1;
  }
  if (!strcmp(command, "read_id")) {
    uint32_t id;
    status err = ecp5_read_id(&id);
    if (is_error(err)) {
      status_ignore(err);
    } else {
      printf("ID: 0x%08x\n", id);
    }
    return 1;
  }
  if (!strcmp(command, "usercode")) {
    uint32_t usercode;
    status err = ecp5_usercode(&usercode);
    if (is_error(err)) {
      status_ignore(err);
    } else {
      printf("Usercode: 0x%08x\n", usercode);
    }
    return 1;
  }
  if (!strcmp(command, "isc_enable")) {
    status_ignore(ecp5_isc_enable());
    return 1;
  }
  if (!strcmp(command, "isc_enablex")) {
    status_ignore(ecp5_isc_enablex());
    return 1;
  }
  if (!strcmp(command, "isc_disable")) {
    status_ignore(ecp5_isc_disable());
    return 1;
  }
  if (!strcmp(command, "load_bitstream") && argc >= 2) {
    status_ignore(read_and_load_bitstream(argv[1]));
    return 2;
  }
  if (!strcmp(command, "check_done")) {
    status_ignore(ecp5_check_done());
    return 1;
  }
  if (!strcmp(command, "idle_bytes")) {
    status_ignore(ecp5_write_idle_bytes(64));
    return 1;
  }
  if (!strcmp(command, "init+")) {
    ecp5_set_init(true);
    status_ignore(ftdiutil_flush_writes("ecp5_set_init"));
    return 1;
  }
  if (!strcmp(command, "init-")) {
    ecp5_set_init(false);
    status_ignore(ftdiutil_flush_writes("ecp5_set_init"));
    return 1;
  }
  if (!strcmp(command, "done+")) {
    ecp5_set_done(true);
    status_ignore(ftdiutil_flush_writes("ecp5_set_done"));
    return 1;
  }
  if (!strcmp(command, "done-")) {
    ecp5_set_done(false);
    status_ignore(ftdiutil_flush_writes("ecp5_set_done"));
    return 1;
  }
  if (!strcmp(command, "sleep")) {
    usleep(250000);
    return 1;
  }
  printf("ERROR: Unknown command \"%s\"\n", command);
  return 1;
}

// [Command]
// Description: Test FPGA SSPI interface with individual commands.
// Option: open_usb = true
// Option: default_usb_device = board
status fpga_raw(int argc, char** argv) {
  while (argc > 0) {
    int absorbed = single_command(argc, argv);
    argc -= absorbed;
    argv += absorbed;
  }
  return OK;
}
