// vi: ts=2:sw=2:sts=2:et

#include "ftdiutil.h"
#include "constants.h"
#include "ftdi.h"

#include <assert.h>
#include <libusb.h>
#include <memory.h>
#include <stdio.h>
#include <stdlib.h>

static bool debug_logging = false;

void ftdiutil_debug_logging(bool enable) { debug_logging = enable; }

struct write_buf {
  unsigned char* buf;
  int len;
  int cap;
};

static void write_buf_release(struct write_buf* wr) {
  if (wr->buf) {
    free(wr->buf);
    wr->buf = NULL;
  }
  if (wr->len) {
    fprintf(stderr, "Warning: Dropping %d bytes of buffered FTDI writes.\n",
            wr->len);
  }
  wr->len = 0;
  wr->cap = 0;
}

static void write_data(struct write_buf* wr, unsigned char* data, int size) {
  if (wr->buf == NULL) {
    wr->len = 0;
    wr->cap = 1024;
    wr->buf = (unsigned char*)malloc(wr->cap);
  }
  if (wr->len + size > wr->cap) {
    while (wr->len + size > wr->cap) {
      wr->cap *= 2;
    }
    wr->buf = (unsigned char*)realloc(wr->buf, wr->cap);
  }
  memcpy(wr->buf + wr->len, data, size);
  wr->len += size;
}

static status flush_writes(struct ftdi_context* ftdi, struct write_buf* wr,
                           const char* caller) {
  unsigned char* data = wr->buf;
  int size = wr->len;
  if (debug_logging && size > 0) {
    printf("[W:");
    for (int i = 0; i < size; i++) {
      printf("%02x", data[i]);
    }
    printf("]\n");
  }
  while (size > 0) {
    int ret = ftdi_write_data(ftdi, data, size);
    if (ret < 0) {
      wr->len = 0;
      return ftdiutil_error(caller, ret);
    }
    data += ret;
    size -= ret;
  }
  wr->len = 0;
  return OK;
}

struct readent {
  unsigned char* data;
  int size;
};

struct read_buf {
  struct readent* buf;
  int len;
  int cap;
  int size_bytes;
};

static void read_buf_release(struct read_buf* rd) {
  if (rd->buf) {
    free(rd->buf);
    rd->buf = NULL;
  }
  rd->len = 0;
  rd->cap = 0;
  rd->size_bytes = 0;
}

static void read_data(struct read_buf* rd, unsigned char* data, int size) {
  if (rd->buf == NULL) {
    rd->len = 0;
    rd->cap = 256;
    rd->buf = (struct readent*)malloc(rd->cap * sizeof(struct readent));
  }
  if (rd->len == rd->cap) {
    rd->cap *= 2;
    rd->buf =
        (struct readent*)realloc(rd->buf, rd->cap * sizeof(struct readent));
  }
  rd->buf[rd->len].data = data;
  rd->buf[rd->len].size = size;
  rd->len++;
  rd->size_bytes += size;
}

#define min(a, b) ((a) < (b) ? (a) : (b));

static status flush_reads(struct ftdi_context* ftdi, struct read_buf* rd,
                          const char* caller) {
  unsigned char buf[4096];
  int index = 0;
  int offset = 0;
  while (rd->size_bytes > 0) {
    int remain = min(rd->size_bytes, (int)sizeof(buf));
    int bytes_remain = ftdi_read_data(ftdi, buf, remain);
    if (bytes_remain < 0) {
      rd->len = 0;
      rd->size_bytes = 0;
      return ftdiutil_error(caller, bytes_remain);
    }
    if (debug_logging && bytes_remain > 0) {
      printf("[R:");
      for (int i = 0; i < bytes_remain; i++) printf("%02x", buf[i]);
      printf("]\n");
    }
    unsigned char* src = buf;
    while (bytes_remain > 0) {
      assert(index < rd->len);
      assert(offset < rd->buf[index].size);
      unsigned char* dest = &rd->buf[index].data[offset];
      int dest_remain = rd->buf[index].size - offset;
      int bytes_copied = min(dest_remain, bytes_remain);
      memcpy(dest, src, bytes_copied);
      src += bytes_copied;
      offset += bytes_copied;
      bytes_remain -= bytes_copied;
      rd->size_bytes -= bytes_copied;
      if (offset == rd->buf[index].size) {
        index++;
        offset = 0;
      }
    }
  }
  rd->len = 0;
  return OK;
}

struct ftdi_iface {
  struct ftdi_context* ftdi;
  struct read_buf rd;
  struct write_buf wr;
};

static status ftdi_iface_init(struct ftdi_iface* f) {
  f->ftdi = ftdi_new();
  if (!f->ftdi) {
    return errorf("ftdi_new: error creating FTDI context.");
  }
  libusb_set_debug(f->ftdi->usb_ctx, LIBUSB_LOG_LEVEL_ERROR);
  return OK;
}

static void ftdi_iface_release(struct ftdi_iface* f) {
  write_buf_release(&f->wr);
  read_buf_release(&f->rd);
  ftdi_free(f->ftdi);
  f->ftdi = NULL;
}

struct ftdi_iface a;
struct ftdi_iface b;
struct ftdi_iface* current;
struct ftdi_context* ftdi;

status ftdiutil_init() {
  RETURN_IF_ERROR(ftdi_iface_init(&a));
  RETURN_IF_ERROR(ftdi_iface_init(&b));
  current = &a;
  ftdi = a.ftdi;
  return OK;
}

void ftdiutil_deinit() {
  ftdi_iface_release(&a);
  ftdi_iface_release(&b);
  current = NULL;
  ftdi = NULL;
}

status ftdiutil_error(const char* fn, int ret) {
  return errorf("%s: error %d: %s", fn, ret, ftdi_get_error_string(ftdi));
}

typedef bool (*matches_predicate)(const char*, const char*, const char*);

static bool matches_cable(const char* manufacturer, const char* description,
                          const char* serial) {
  (void)serial;
  return (!strcmp(manufacturer, "FTDI") &&
          !strcmp(description, "C232HM-DDHSL-0"));
}

static bool matches_new(const char* manufacturer, const char* description,
                        const char* serial) {
  return (!strcmp(manufacturer, "FTDI") &&
          !strcmp(description, "Dual RS232-HS") && !strcmp(serial, ""));
}

static bool matches_dead(const char* manufacturer, const char* description,
                         const char* serial) {
  // Busted by bad EEPROM; all fields empty.
  return (!manufacturer[0] && !description[0] && !serial[0]);
}

static bool matches_board(const char* manufacturer, const char* description,
                          const char* serial) {
  (void)serial;
  return (!strcmp(manufacturer, DEFAULT_MANUFACTURER) &&
          !strcmp(description, DEFAULT_DESCRIPTION));
}

static status find_matches_predicate(const char* which,
                                     matches_predicate* pred) {
  if (!strcmp("cable", which)) {
    *pred = matches_cable;
    return OK;
  }
  if (!strcmp("new", which)) {
    *pred = matches_new;
    return OK;
  }
  if (!strcmp("dead", which)) {
    *pred = matches_dead;
    return OK;
  }
  if (!strcmp("board", which)) {
    *pred = matches_board;
    return OK;
  }
  return errorf("Unknown device '%s'", which);
}

static const char* default_usb_device;
static const char* preferred_usb_device;

void ftdiutil_set_usb_device(const char* which) {
  preferred_usb_device = which;
}

void ftdiutil_set_default_usb_device(const char* which) {
  default_usb_device = which;
}

static status search_for(int vendor_id, int product_id, matches_predicate pred,
                         int* found, struct libusb_device** dev) {
  struct ftdi_device_list* devlist;
  int ret = ftdi_usb_find_all(ftdi, &devlist, vendor_id, product_id);
  if (ret < 0) {
    return ftdiutil_error("ftdi_usb_find_all", ret);
  }

  char manufacturer[256];
  char description[256];
  char serial[256];

  for (struct ftdi_device_list* cur = devlist; cur; cur = cur->next) {
    int ret = ftdiutil_describe(ftdi, cur->dev, manufacturer,
                                sizeof(manufacturer), description,
                                sizeof(description), serial, sizeof(serial));
    if (ret) {
      ftdi_list_free(&devlist);
      return ftdiutil_error("ftdi_usb_find_all", ret);
    }
    if (pred(manufacturer, description, serial)) {
      (*found)++;
      *dev = cur->dev;
    }
  }
  ftdi_list_free(&devlist);
  return OK;
}

status ftdiutil_open_usb() {
  const char* devname = default_usb_device;
  if (preferred_usb_device) {
    devname = preferred_usb_device;
  }
  matches_predicate pred;
  RETURN_IF_ERROR(find_matches_predicate(devname, &pred));

  int found = 0;
  struct libusb_device* dev;

  RETURN_IF_ERROR(search_for(0, 0, pred, &found, &dev));
  RETURN_IF_ERROR(
      search_for(DEFAULT_VENDOR_ID, DEFAULT_PRODUCT_ID, pred, &found, &dev));

  if (found == 0) {
    return errorf("Device '%s' not found.", devname);
  }
  if (found > 1) {
    return errorf("Found %d devices matching '%s'.", found, devname);
  }

  int ret = ftdi_set_interface(a.ftdi, INTERFACE_A);
  if (ret) {
    return ftdiutil_error("ftdi_set_interface", ret);
  }
  ret = ftdi_usb_open_dev(a.ftdi, dev);
  if (ret) {
    return ftdiutil_error("ftdi_usb_open_dev", ret);
  }
  // Note: This clumsily only handles the two FTDI chips I care about.
  if (a.ftdi->type == TYPE_2232H) {
    ret = ftdi_set_interface(b.ftdi, INTERFACE_B);
    if (ret) {
      return ftdiutil_error("ftdi_set_interface", ret);
    }
    ret = ftdi_usb_open_dev(b.ftdi, dev);
    if (ret) {
      return ftdiutil_error("ftdi_usb_open_dev", ret);
    }
  }
  current = &a;
  ftdi = a.ftdi;
  return OK;
}

status ftdiutil_close_usb() {
  int ret = ftdi_usb_close(a.ftdi);
  if (ret) {
    return ftdiutil_error("ftdi_usb_close", ret);
  }
  ftdi_set_usbdev(b.ftdi, NULL);
  return OK;
}

void ftdiutil_set_interface(enum ftdi_interface interface) {
  switch (interface) {
    case INTERFACE_A:
      current = &a;
      ftdi = a.ftdi;
      break;
    case INTERFACE_B:
      current = &b;
      ftdi = b.ftdi;
      break;
    default:
      assert(!"ftdi_set_interface: bad constant");
  }
}

int ftdiutil_describe(struct ftdi_context* ftdi, struct libusb_device* dev,
                      char* manufacturer, int manufacturer_len,
                      char* description, int description_len, char* serial,
                      int serial_len) {
  int ret =
      ftdi_usb_get_strings(ftdi, dev, manufacturer, manufacturer_len,
                           description, description_len, serial, serial_len);
  // With empty fields, ftdi_usb_get_strings fails with various error codes.
  // However, an FTDI chip with a blank EEPROM comes up with empty 'serial',
  // and with a bad-checksum EEPROM image, comes up with all fields empty.
  // Handle these cases more sensibly.
  switch (ret) {
    case -7:
      manufacturer[0] = '\0';
      description[0] = '\0';
      serial[0] = '\0';
      return 0;
    case -8:
      description[0] = '\0';
      serial[0] = '\0';
      return 0;
    case -9:
      serial[0] = '\0';
      return 0;
  }
  return ret;
}

status ftdiutil_usb_reset() {
  int ret = ftdi_usb_reset(ftdi);
  if (ret) {
    return ftdiutil_error("ftdi_usb_reset", ret);
  }
  return OK;
}

void ftdiutil_write_data(unsigned char* data, int size) {
  write_data(&current->wr, data, size);
}

status ftdiutil_flush_writes(const char* caller) {
  if (!caller) {
    caller = "ftdiutil_flush_writes";
  }
  RETURN_IF_ERROR(flush_writes(a.ftdi, &a.wr, caller));
  RETURN_IF_ERROR(flush_writes(b.ftdi, &b.wr, caller));
  return OK;
}

void ftdiutil_read_data(unsigned char* data, int size) {
  read_data(&current->rd, data, size);
}

status ftdiutil_flush_reads(const char* caller) {
  RETURN_IF_ERROR(ftdiutil_flush_writes(caller));
  if (!caller) {
    caller = "ftdiutil_flush_reads";
  }
  RETURN_IF_ERROR(flush_reads(a.ftdi, &a.rd, caller));
  RETURN_IF_ERROR(flush_reads(b.ftdi, &b.rd, caller));
  return OK;
}
