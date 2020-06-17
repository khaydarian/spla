// vi: ts=2:sw=2:sts=2:et

#include "load_bitstream.h"

#include <stdio.h>
#include <unistd.h>
#include "ecp5.h"
#include "ftdiutil.h"
#include "mpsse.h"

status loadbits_err = OK;

static status loadbits_reset_crc(unsigned at, uint8_t op) {
  (void)at;
  (void)op;
  printf("ecp5_reset_crc()\n");
  return ecp5_reset_crc();
}

static status loadbits_verify_id(unsigned at, uint8_t op, uint32_t id) {
  (void)at;
  (void)op;
  printf("ecp5_verify_id(0x%08x)\n", id);
  RETURN_IF_ERROR(ecp5_verify_id(id));
  return ecp5_check_status();
}

static status loadbits_prog_cntrl0(unsigned at, uint8_t op, uint32_t value) {
  (void)at;
  (void)op;
  (void)value;
  //printf("ecp5_prog_cntrl0(0x%08x)\n", value);
  //RETURN_IF_ERROR(ecp5_prog_cntrl0(value));
  return ecp5_check_status();
}

static status loadbits_init_address(unsigned at, uint8_t op) {
  (void)at;
  (void)op;
  printf("ecp5_init_address()\n");
  RETURN_IF_ERROR(ecp5_init_address());
  return ecp5_check_status();
}

static status loadbits_write_comp_dic(unsigned at, uint8_t op, uint8_t* dic,
                                      int size) {
  (void)at;
  (void)op;
  (void)dic;
  (void)size;
  return errorf("compressed bitstreams not yet supported");
}

static status loadbits_prog_incr_rti(unsigned at, uint8_t op, uint8_t opts,
                                     uint8_t* frames, int bytes_per_frame,
                                     int num_frames) {
  (void)at;
  (void)op;
  (void)opts;
  (void)frames;
  printf("prog_incr_rti(...)\n");
  // Note: we're cheating a bit here by grabbing the actual packet header,
  // instead of parsing the frames accurately.  This does violate layering a
  // bit.
  uint8_t* data = frames - 4;
  unsigned size = 4 + bytes_per_frame * num_frames;
  unsigned total_size = size;
  mpsse_chip_select(true);
  while (size > 0) {
    int n = size > 2048 ? 2048 : size;
    mpsse_write_data(data, n);
    RETURN_IF_ERROR(ftdiutil_flush_writes("loadbits_prog_incr_rti"));
    data += n;
    size -= n;
    printf("\r%07d / %07d bytes = %5.1f%%", total_size - size, total_size,
           100. * (total_size - size) / total_size);
    fflush(stdout);
  }
  mpsse_chip_select(false);
  RETURN_IF_ERROR(ftdiutil_flush_writes("mpsse_chip_select"));
  printf("\r%07d / %07d bytes = %5.1f%%\n", total_size, total_size, 100.);
  return ecp5_check_status();
}

static status loadbits_program_done(unsigned at, uint8_t op) {
  (void)at;
  (void)op;
  printf("program_done()\n");
  RETURN_IF_ERROR(ecp5_program_done());
  return OK;
}

static struct bitstream_parse_callbacks loadbits_callbacks = {
    .reset_crc = loadbits_reset_crc,
    .verify_id = loadbits_verify_id,
    .prog_cntrl0 = loadbits_prog_cntrl0,
    .init_address = loadbits_init_address,
    .write_comp_dic = loadbits_write_comp_dic,
    .prog_incr_rti = loadbits_prog_incr_rti,
    .program_done = loadbits_program_done,
};

status load_bitstream_raw(struct bitstream* bits) {
  return bitstream_parse(bits, &loadbits_callbacks);
}

status load_bitstream(struct bitstream* bits) {
  uint32_t statusval;
  printf("Early status:\n");
  RETURN_IF_ERROR(ecp5_read_status(&statusval));
  ecp5_debug_status_dump(statusval);

  printf("ecp_isc_enable()\n");
  ecp5_isc_enable();
  RETURN_IF_ERROR(ecp5_read_status(&statusval));
  ecp5_debug_status_dump(statusval);

  RETURN_IF_ERROR(bitstream_parse(bits, &loadbits_callbacks));

  // Check final DONE status.
  RETURN_IF_ERROR(ecp5_check_done());

  RETURN_IF_ERROR(ecp5_read_status(&statusval));
  ecp5_debug_status_dump(statusval);

  // printf("<wait...>\n");
  // usleep(3000000);

  printf("ecp_isc_disable()\n");
  ecp5_isc_disable();
  RETURN_IF_ERROR(ecp5_read_status(&statusval));
  ecp5_debug_status_dump(statusval);

  // printf("ecp_write_idle_bytes()\n");
  // ecp5_write_idle_bytes(64);
  // RETURN_IF_ERROR(ecp5_read_status(&statusval));
  // ecp5_debug_status_dump(statusval);

  // printf("ecp_set_init(false)\n");
  // ecp5_set_init(false);
  // ftdiutil_flush_writes("ecp5_set_init");

  // printf("ecp_set_done(true)\n");
  // ecp5_set_done(true);
  // ftdiutil_flush_writes("ecp5_set_done");

  RETURN_IF_ERROR(ecp5_read_status(&statusval));
  ecp5_debug_status_dump(statusval);

  return OK;
}
