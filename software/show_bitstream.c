// vi: ts=2:sw=2:sts=2:et

#include <stdio.h>
#include "bitstream.h"
#include "command.h"

static void show_nop(unsigned at, uint8_t op) {
  printf("%06x [%02x] nop\n", at, op);
}

static void show_reset_crc(unsigned at, uint8_t op) {
  printf("%06x [%02x] Reset CRC\n", at, op);
}

static void show_verify_id(unsigned at, uint8_t op, uint32_t expected_id) {
  printf("%06x [%02x] Verify ID == 0x%08x\n", at, op, expected_id);
}

static void show_prog_cntrl0(unsigned at, uint8_t op, uint32_t value) {
  printf("%06x [%02x] Prog CNTRL0 with value 0x%08x\n", at, op, value);
}

static void show_init_address(unsigned at, uint8_t op) {
  printf("%06x [%02x] Init Address (to 0)\n", at, op);
}

static void show_write_comp_dic(unsigned at, uint8_t op, uint8_t* dic,
                                int size) {
  printf("%06x [%02x] Write Compression Dictionary: [", at, op);
  printf("%02x", dic[0]);
  for (int i = 1; i < size; i++) {
    printf(" %02x", dic[i]);
  }
  printf("]\n");
}

static void show_prog_incr_rti(unsigned at, uint8_t op, uint8_t opts,
                               uint8_t* frames, int bytes_per_frame,
                               int num_frames) {
  (void)opts;
  (void)frames;
  printf(
      "%06x [%02x] Program Incremental (Uncompressed): opts 0x%02x, %d bytes "
      "per frame, %d frames\n",
      at, op, opts, bytes_per_frame, num_frames);
}

static void show_program_usercode(unsigned at, uint8_t op, uint32_t usercode) {
  printf("%06x [%02x] Program Usercode 0x%08x\n", at, op, usercode);
}

static void show_program_done(unsigned at, uint8_t op) {
  printf("%06x [%02x] Program Done\n", at, op);
}

static void show_remaining(unsigned at, uint8_t* rest, int size) {
  printf("%06x [", at);
  for (int i = 0; i < 16 && i < size; i++) {
    printf("%02x", rest[i]);
    if (i && i % 4 == 3) {
      printf(" ");
    }
  }
  if (size > 16) {
    printf("...");
  }
  printf("] %d bytes remaining\n", size);
}

static struct bitstream_parse_callbacks print_callbacks = {
    .op_0xFF_nop = show_nop,
    .op_0x3B_reset_crc = show_reset_crc,
    .op_0xE2_verify_id = show_verify_id,
    .op_0x22_prog_cntrl0 = show_prog_cntrl0,
    .op_0x46_init_address = show_init_address,
    .op_0x02_write_comp_dic = show_write_comp_dic,
    .op_0x82_prog_incr_rti = show_prog_incr_rti,
    .op_0xc2_program_usercode = show_program_usercode,
    .op_0x5e_program_done = show_program_done,
    .error = show_remaining,
};

// [Command]
// Description: Print a text rendering of a given bitstream.
// Option: open_usb = false
status show_bitstream(int argc, char** argv) {
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

  err = bitstream_parse(&bits, &print_callbacks);
  bitstream_free(&bits);
  return err;
}
