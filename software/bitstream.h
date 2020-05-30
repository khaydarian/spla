// vi: ts=2:sw=2:sts=2:et

#ifndef BITSTREAM_H
#define BITSTREAM_H

#include <stdint.h>
#include "status.h"

struct bitstream {
  unsigned char* data;
  int size;
};

void bitstream_free(struct bitstream* bits);

status read_bitstream_file(struct bitstream* bits, const char* filename);

struct bitstream_parse_callbacks {
  status (*op_0xFF_nop)(unsigned, uint8_t);
  status (*op_0x3B_reset_crc)(unsigned, uint8_t);
  status (*op_0xE2_verify_id)(unsigned, uint8_t, uint32_t);
  status (*op_0x22_prog_cntrl0)(unsigned, uint8_t, uint32_t);
  status (*op_0x46_init_address)(unsigned, uint8_t);
  status (*op_0x02_write_comp_dic)(unsigned, uint8_t, uint8_t*, int);
  status (*op_0x82_prog_incr_rti)(unsigned, uint8_t, uint8_t, uint8_t*, int,
                                  int);
  status (*op_0xc2_program_usercode)(unsigned, uint8_t, uint32_t);
  status (*op_0x5e_program_done)(unsigned, uint8_t);
  status (*error)(unsigned, uint8_t*, int);
};

status bitstream_parse(struct bitstream* bits,
                       struct bitstream_parse_callbacks* cb);

#endif
