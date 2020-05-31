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
  status (*nop)(unsigned, uint8_t);
  status (*reset_crc)(unsigned, uint8_t);
  status (*verify_id)(unsigned, uint8_t, uint32_t);
  status (*prog_cntrl0)(unsigned, uint8_t, uint32_t);
  status (*init_address)(unsigned, uint8_t);
  status (*write_comp_dic)(unsigned, uint8_t, uint8_t*, int);
  status (*prog_incr_rti)(unsigned, uint8_t, uint8_t, uint8_t*, int, int);
  status (*program_usercode)(unsigned, uint8_t, uint32_t);
  status (*program_done)(unsigned, uint8_t);
  status (*error)(unsigned, uint8_t*, int);
};

status bitstream_parse(struct bitstream* bits,
                       struct bitstream_parse_callbacks* cb);

#endif
