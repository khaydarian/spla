// vi: ts=2:sw=2:sts=2:et

#include "bitstream.h"

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

void bitstream_free(struct bitstream* bits) {
  if (bits->data) {
    free(bits->data);
    bits->data = 0;
  }
  bits->size = 0;
}

status read_bitstream_file(struct bitstream* bits, const char* filename) {
  struct stat st;
  if (stat(filename, &st) == -1) {
    return errorf("%s: %s", filename, strerror(errno));
  }
  FILE* f = fopen(filename, "r");
  if (!f) {
    return errorf("%s: %s", filename, strerror(errno));
  }
  bitstream_free(bits);
  bits->data = (unsigned char*)malloc(st.st_size);
  bits->size = st.st_size;
  int bytes_read = fread(bits->data, 1, bits->size, f);
  if (bytes_read != bits->size) {
    bitstream_free(bits);
    fclose(f);
    return errorf("%s: fread: expected %d bytes, read only %d bytes", filename,
                  bits->size, bytes_read);
  }
  fclose(f);
  return OK;
}
