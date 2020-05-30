// vi: ts=2:sw=2:sts=2:et

#include <stdio.h>
#include "command.h"
#include "ecp5.h"
#include "ftdi.h"
#include "ftdiutil.h"

// [Command]
// Description: Test a few simple operations on ECP5 SSPI.
// Option: open_usb = true
// Option: default_usb_device = board
status fpga_test_ids(int argc, char** argv) {
  RETURN_IF_ERROR(no_arguments(argc, argv));

  RETURN_IF_ERROR(ecp5_init());
  RETURN_IF_ERROR(ecp5_reset());

  printf("--- Preliminaries:\n");

  uint32_t statusval;
  RETURN_IF_ERROR(ecp5_read_status(&statusval));
  ecp5_debug_status_dump(statusval);

  uint32_t id;
  RETURN_IF_ERROR(ecp5_read_id(&id));
  printf("ID: 0x%08x\n", id);

  printf("--- Test Usercode:\n");

  uint32_t usercode;
  RETURN_IF_ERROR(ecp5_usercode(&usercode));
  printf("Usercode: 0x%08x\n", usercode);

  usercode = 0x11223344;
  printf("Program Usercode with: 0x%08x\n", usercode);
  RETURN_IF_ERROR(ecp5_program_usercode(usercode));

  RETURN_IF_ERROR(ecp5_usercode(&usercode));
  printf("Usercode: 0x%08x\n", usercode);

  printf("--- Verify ID:\n");
  RETURN_IF_ERROR(ecp5_read_status(&statusval));
  ecp5_debug_status_dump(statusval);

  printf("(Verify Correct ID 0x%08x)\n", id);
  RETURN_IF_ERROR(ecp5_verify_id(id));
  RETURN_IF_ERROR(ecp5_read_status(&statusval));
  ecp5_debug_status_dump(statusval);

  uint32_t wrong_id = 0x42424242;
  printf("(Verify Wrong ID 0x%08x)\n", wrong_id);
  RETURN_IF_ERROR(ecp5_verify_id(wrong_id));
  RETURN_IF_ERROR(ecp5_read_status(&statusval));
  ecp5_debug_status_dump(statusval);

  printf("--- Done.\n");
  RETURN_IF_ERROR(ecp5_release_reset());
  return OK;
}
