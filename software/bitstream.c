// vi: ts=2:sw=2:sts=2:et

#include "bitstream.h"

#include <errno.h>
#include <stdint.h>
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

struct biparse {
  struct bitstream* bits;
  uint8_t* pos;
  uint8_t* end;
  uint8_t* base;  // from after preamble
};

static status bp_skip_past_preamble(struct biparse* bp) {
  for (uint8_t* p = bp->pos; p < bp->end - 2; p++) {
    if (p[0] == 0xbd && p[1] == 0xb3) {
      bp->pos = p + 2;
      return OK;
    }
  }
  return errorf("no preamble (0xbdb3) found");
}

static bool bp_is_eof(struct biparse* bp) { return bp->pos >= bp->end; }

static uint32_t bp_read32_at(struct biparse* bp, int offset) {
  uint8_t* p = bp->pos + offset;
  return (p[0] << 24) | (p[1] << 16) | (p[2] << 8) | p[3];
}

static status bp_check_space(struct biparse* bp, int bytes) {
  if (bp->pos + bytes >= bp->end) {
    return errorf("unexpected end of bistream (%d bytes short)",
                  (bp->end - bp->pos) - bytes);
  }
  return OK;
}

status bitstream_parse(struct bitstream* bits,
                       struct bitstream_parse_callbacks* cb) {
  struct biparse p = {
      .bits = bits, .pos = bits->data, .end = bits->data + bits->size};

  RETURN_IF_ERROR(bp_skip_past_preamble(&p));
  p.base = p.pos;

  while (!bp_is_eof(&p)) {
    int at = p.pos - p.base;
    uint8_t op = *p.pos;
    switch (op) {
      case 0xff:
        if (cb->op_0xFF_nop) {
          RETURN_IF_ERROR(cb->op_0xFF_nop(at, op));
        }
        p.pos++;
        break;
      case 0x3B:
        RETURN_IF_ERROR(bp_check_space(&p, 4));
        if (cb->op_0x3B_reset_crc) {
          RETURN_IF_ERROR(cb->op_0x3B_reset_crc(at, op));
        }
        p.pos += 4;
        break;
      case 0xe2:
        RETURN_IF_ERROR(bp_check_space(&p, 8));
        if (cb->op_0xE2_verify_id) {
          RETURN_IF_ERROR(cb->op_0xE2_verify_id(at, op, bp_read32_at(&p, 4)));
        }
        p.pos += 8;
        break;
      case 0x22:
        RETURN_IF_ERROR(bp_check_space(&p, 8));
        if (cb->op_0x22_prog_cntrl0) {
          RETURN_IF_ERROR(cb->op_0x22_prog_cntrl0(at, op, bp_read32_at(&p, 4)));
        }
        p.pos += 8;
        break;
      case 0x46:
        RETURN_IF_ERROR(bp_check_space(&p, 4));
        if (cb->op_0x46_init_address) {
          RETURN_IF_ERROR(cb->op_0x46_init_address(at, op));
        }
        p.pos += 4;
        break;
      case 0x02:
        RETURN_IF_ERROR(bp_check_space(&p, 12));
        if (cb->op_0x02_write_comp_dic) {
          RETURN_IF_ERROR(cb->op_0x02_write_comp_dic(at, op, p.pos + 4, 8));
        }
        p.pos += 12;
        break;
      case 0x82:
        RETURN_IF_ERROR(bp_check_space(&p, 4));
        uint8_t opts = p.pos[1];
        uint16_t nframes = (p.pos[2] << 8) | p.pos[3];
        uint32_t bytes_per_frame = 106 + (opts & 0x80 ? 2 : 0) + (opts & 0xf);
        uint32_t size = nframes * bytes_per_frame;
        RETURN_IF_ERROR(bp_check_space(&p, 4 + size));
        if (cb->op_0x82_prog_incr_rti) {
          cb->op_0x82_prog_incr_rti(at, op, opts, p.pos + 4, bytes_per_frame,
                                    nframes);
        }
        p.pos += 4 + size;
        break;
      case 0xc2:
        RETURN_IF_ERROR(bp_check_space(&p, 8));
        if (cb->op_0xc2_program_usercode) {
          RETURN_IF_ERROR(
              cb->op_0xc2_program_usercode(at, op, bp_read32_at(&p, 4)));
        }
        if (p.pos[1] & 0x80) {
          p.pos += 2;
        }
        p.pos += 8;
        break;
      case 0x5e:
        RETURN_IF_ERROR(bp_check_space(&p, 4));
        if (cb->op_0x5e_program_done) {
          RETURN_IF_ERROR(cb->op_0x5e_program_done(at, op));
        }
        p.pos += 4;
        break;
      default:
        if (cb->error) {
          RETURN_IF_ERROR(cb->error(at, p.pos, p.end - p.pos));
        }
        return errorf("unknown opcode [%02x] at 0x%06x", op, at);
    }
  }
  return OK;
}
