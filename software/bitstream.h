// vi: ts=2:sw=2:sts=2:et

#ifndef BITSTREAM_H
#define BITSTREAM_H

#include <stdint.h>
#include "status.h"

struct bitstream {
  uint8_t* data;
  unsigned int size;
};

status load_bitstream_file(struct bitstream* bits, const char* filename);

void free_bitstream(struct bitstream* bits);

status program_bitstream(struct bitstream* bits);

#endif
