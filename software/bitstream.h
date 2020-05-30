// vi: ts=2:sw=2:sts=2:et

#ifndef BITSTREAM_H
#define BITSTREAM_H

#include "status.h"

struct bitstream {
  unsigned char* data;
  int size;
};

void bitstream_free(struct bitstream* bits);

status read_bitstream_file(struct bitstream* bits, const char* filename);

#endif
