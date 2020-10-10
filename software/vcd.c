// vi: ts=2:sw=2:sts=2:et

#include "vcd.h"
#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

const char signal_chars[] =
    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

struct vcd_signal {
  const char* name;
  unsigned int bits;
  uint32_t value;
  uint32_t last_value;
  bool valid;
};

struct vcd {
  FILE* fd;
  bool header_done;
  struct vcd_signal** signals;
  unsigned int signals_len;
  uint32_t last_timestamp;
};

status vcd_open(struct vcd** v, const char* filename) {
  FILE* f = fopen(filename, "w");
  if (!f) {
    return errorf("couldn't open vcd file \"%s\"", filename);
  }

  struct vcd* ret;
  ret = (struct vcd*)malloc(sizeof(struct vcd));
  ret->fd = f;
  ret->header_done = false;
  ret->signals = NULL;
  ret->signals_len = 0;
  ret->last_timestamp = (uint32_t)-1;

  *v = ret;
  return OK;
}

void vcd_close(struct vcd** vp) {
  struct vcd* v = *vp;
  assert(v);
  assert(v->fd);
  fclose(v->fd);
  v->fd = NULL;
  for (unsigned int i = 0; i < v->signals_len; i++) {
    free(v->signals[i]);
  }
  free(v->signals);
  v->signals = NULL;
  free(v);
  *vp = NULL;
}

struct vcd_signal* vcd_add_signal(struct vcd* v, const char* name,
                                  unsigned int bits) {
  assert(!v->header_done);
  assert(bits >= 1);
  assert(bits < 32);
  unsigned int i = v->signals_len;
  assert(i < sizeof(signal_chars));
  v->signals_len++;
  v->signals = realloc(v->signals, sizeof(v->signals[0]) * v->signals_len);
  struct vcd_signal* vs = (struct vcd_signal*)malloc(sizeof(struct vcd_signal));
  v->signals[i] = vs;
  vs->name = name;
  vs->bits = bits;
  vs->valid = false;
  return vs;
}

status vcd_value(struct vcd_signal* vs, uint32_t value) {
  if ((((1 << vs->bits) - 1) & value) != value) {
    return errorf("Bad value for %d-bit signal \"%s\": 0x%x\n", vs->bits,
                  vs->name, value);
  }
  if (vs->valid) {
    vs->value = value;
  } else {
    vs->value = value;
    vs->last_value = value;
    vs->valid = true;
  }
  return OK;
}

static void fputx(FILE* f, int bits) {
  fputc('b', f);
  for (int i = 0; i < bits; i++) {
    fputc('x', f);
  }
}

static void fputbin(FILE* f, int bits, int value) {
  fputc('b', f);
  int mask = 1 << (bits - 1);
  while (mask) {
    fputc((mask & value) ? '1' : '0', f);
    mask >>= 1;
  }
}

static void vcd_signal_print(FILE* f, struct vcd_signal* vs, char ch) {
  if (vs->bits == 1) {
    if (vs->valid) {
      fprintf(f, "%d%c\n", vs->value, ch);
    } else {
      fprintf(f, "x%c\n", ch);
    }
  } else {
    if (vs->valid) {
      fputbin(f, vs->bits, vs->value);
    } else {
      fputx(f, vs->bits);
    }
    fprintf(f, " %c\n", ch);
  }
}

static void vcd_flush_header(struct vcd* v) {
  fprintf(v->fd, "$timescale 1ns $end\n");
  fprintf(v->fd, "$scope module snes $end\n");
  for (unsigned int i = 0; i < v->signals_len; i++) {
    struct vcd_signal* vs = v->signals[i];
    fprintf(v->fd, "$var wire %d %c %s $end\n", vs->bits, signal_chars[i],
            vs->name);
  }
  fprintf(v->fd, "$upscope $end\n");
  fprintf(v->fd, "$enddefinitions $end\n");
  fprintf(v->fd, "$dumpvars\n");
  for (unsigned int i = 0; i < v->signals_len; i++) {
    struct vcd_signal* vs = v->signals[i];
    vcd_signal_print(v->fd, vs, signal_chars[i]);
  }
  fprintf(v->fd, "$end\n");
  v->header_done = true;
}

status vcd_timestamp(struct vcd* v, uint32_t timestamp) {
  if (!v->header_done) {
    vcd_flush_header(v);
  }
  if (v->last_timestamp != (uint32_t)-1) {
    if (timestamp <= v->last_timestamp) {
      return errorf("vcd timestamp went backwards (%d -> %d)",
                    v->last_timestamp, timestamp);
    }
  }
  v->last_timestamp = timestamp;
  fprintf(v->fd, "#%d\n", timestamp);

  for (unsigned int i = 0; i < v->signals_len; i++) {
    struct vcd_signal* vs = v->signals[i];
    if (vs->value == vs->last_value) {
      continue;
    }
    vs->last_value = vs->value;
    vcd_signal_print(v->fd, vs, signal_chars[i]);
  }
  return OK;
}
