// vi: ts=2:sw=2:sts=2:et

#include "command.h"
#include "constants.h"
#include "ftdi.h"
#include "ftdi_i.h"
#include "ftdiutil.h"

#include <assert.h>
#include <ctype.h>
#include <stdio.h>
#include <string.h>

static bool FLAG_read = true;
static bool FLAG_erase = false;
static bool FLAG_write = false;
static char* FLAG_manufacturer = DEFAULT_MANUFACTURER;
static char* FLAG_description = DEFAULT_DESCRIPTION;
static char* FLAG_serial = NULL;  // ie, "SPLA_r009_b001"
static bool FLAG_asyncff = false;

static status parse_flag(int argc, char** argv, int* absorbed) {
  (void)argc;
  char* arg = argv[0];
  if (!strcmp(arg, "-r") || !strcmp(arg, "--read")) {
    FLAG_read = true;
    *absorbed = 1;
    return OK;
  }
  if (!strcmp(arg, "--noread")) {
    FLAG_read = false;
    *absorbed = 1;
    return OK;
  }
  if (!strcmp(arg, "--write")) {
    FLAG_write = true;
    *absorbed = 1;
    return OK;
  }
  if (!strcmp(arg, "--erase")) {
    FLAG_erase = true;
    *absorbed = 1;
    return OK;
  }
  if (!strcmp(arg, "--serial")) {
    FLAG_serial = argv[1];
    *absorbed = 2;
    return OK;
  }
  if (!strcmp(arg, "--asyncff")) {
    FLAG_asyncff = true;
    *absorbed = 1;
    return OK;
  }
  return errorf("Unknown flag: %s", arg);
}

static char chr(unsigned char ch) { return isprint(ch) ? ch : '.'; }

static void show_eeprom_buf(unsigned char* buf, int size) {
  assert(size % 16 == 0);
  for (int i = 0; i < size; i += 16) {
    printf("0x%04x:", i);
    for (int j = 0; j < 16; j += 2) {
      printf(" %02x%02x", buf[i + j], buf[i + j + 1]);
    }
    printf("  ");
    for (int j = 0; j < 16; j += 2) {
      printf("%c%c", chr(buf[i + j]), chr(buf[i + j + 1]));
    }
    printf("\n");
  }
}

// [Command]
// Description: Initialize FTDI EEPROM with given serial number.
// Option: open_usb = true
// Option: default_usb_device = new
status ftdi_new_device(int argc, char** argv) {
  while (argc) {
    int absorbed;
    RETURN_IF_ERROR(parse_flag(argc, argv, &absorbed));
    argc -= absorbed;
    argv += absorbed;
  }

  if (FLAG_write && !FLAG_serial) {
    return errorf("Must specify --serial when writing eeprom.");
  }

  int ret;

  if (FLAG_erase || FLAG_write) {
    ret = ftdi_erase_eeprom(ftdi);
    if (ret) {
      return ftdiutil_error("ftdi_erase_eeprom", ret);
    }
  }

  if (FLAG_write) {
    ret = ftdi_eeprom_initdefaults(ftdi, FLAG_manufacturer, FLAG_description,
                                   FLAG_serial);
    if (ret) {
      return ftdiutil_error("ftdi_init_defaults", ret);
    }

    ret = ftdi_set_eeprom_value(ftdi, VENDOR_ID, DEFAULT_VENDOR_ID);
    assert(ret == 0);
    ret = ftdi_set_eeprom_value(ftdi, PRODUCT_ID, DEFAULT_PRODUCT_ID);
    assert(ret == 0);
    ret = ftdi_set_eeprom_value(ftdi, SELF_POWERED, 1);
    assert(ret == 0);
    ret = ftdi_set_eeprom_value(ftdi, MAX_POWER, 0);
    assert(ret == 0);
    if (FLAG_asyncff) {
      ret = ftdi_set_eeprom_value(ftdi, CHANNEL_A_TYPE, CHANNEL_IS_FIFO);
      assert(ret == 0);
      ret = ftdi_set_eeprom_value(ftdi, CHANNEL_B_TYPE, CHANNEL_IS_FIFO);
      assert(ret == 0);
    }

    // We always use a Microchip 93LC66B.  If this isn't set, the resulting
    // eeprom buffer is corrupt, because ftdi_eeprom_build assumes we have a
    // 128-byte EEPROM (ie, a 93LC46B).  There's some dodgy auto-detection
    // logic in ftdi_erase_eeprom that doesn't seem to work as I expect.
    ftdi->eeprom->chip = 0x66;

    ret = ftdi_eeprom_build(ftdi);
    if (ret < 0) {
      return ftdiutil_error("ftdi_build_eeprom", ret);
    }

    ret = ftdi_write_eeprom(ftdi);
    if (ret) {
      return ftdiutil_error("ftdi_write_eeprom", ret);
    }
  }

  if (FLAG_read) {
    ret = ftdi_read_eeprom(ftdi);
    if (ret) {
      return ftdiutil_error("ftdi_read_eeprom", ret);
    }

    unsigned char buf[256];
    ret = ftdi_get_eeprom_buf(ftdi, buf, sizeof(buf));
    if (ret) {
      return ftdiutil_error("ftdi_get_eeprom_buf", ret);
    }

    show_eeprom_buf(buf, sizeof(buf));
  }

  return OK;
}

// [Command]
// Description: Change persistent default bitmode setting.
// Option: open_usb = true
// Option: default_usb_device = board
status ftdi_default_mode(int argc, char** argv) {
  bool flag_uart = false;
  bool flag_fifo = false;
  while (argc) {
    if (!strcmp(argv[0], "--uart")) {
      flag_uart = true;
      argc--;
      argv++;
    } else if (!strcmp(argv[0], "--fifo")) {
      flag_fifo = true;
      argc--;
      argv++;
    } else {
      return errorf("Unknown flag: %s", argv[0]);
    }
  }

  if (flag_uart && flag_fifo) {
    return errorf("Must provide exactly one of --uart or --fifo.");
  }
  int type;
  if (flag_uart) {
    type = CHANNEL_IS_UART;
  }
  if (flag_fifo) {
    type = CHANNEL_IS_FIFO;
  }

  int ret = ftdi_read_eeprom(ftdi);
  if (ret) {
    return ftdiutil_error("ftdi_read_eeprom", ret);
  }

  unsigned char pre[256];
  ret = ftdi_get_eeprom_buf(ftdi, pre, sizeof(pre));
  if (ret) {
    return ftdiutil_error("ftdi_get_eeprom_buf", ret);
  }

  ret = ftdi_eeprom_decode(ftdi, 0);
  if (ret) {
    return ftdiutil_error("ftdi_eeprom_decode", ret);
  }

  int atype;
  int btype;
  ret = ftdi_get_eeprom_value(ftdi, CHANNEL_A_TYPE, &atype);
  assert(ret == 0);
  ret = ftdi_get_eeprom_value(ftdi, CHANNEL_B_TYPE, &btype);
  assert(ret == 0);

  if (!flag_uart && !flag_fifo) {
    printf("Default mode:\n");
    printf("  A = %s\n", ftdiutil_channel_type_name(atype));
    printf("  B = %s\n", ftdiutil_channel_type_name(btype));
    return OK;
  }

  if (atype == type && btype == type) {
    printf("No changes.\n");
    return OK;
  }

  printf("Pre:\n");
  show_eeprom_buf(pre, sizeof(pre));

  // Set the channels, and rewrite the eeprom
  ftdi_set_eeprom_value(ftdi, CHANNEL_A_TYPE, type);
  assert(ret == 0);
  ftdi_set_eeprom_value(ftdi, CHANNEL_B_TYPE, type);
  assert(ret == 0);

  // See comment above for why we need this value.
  ftdi->eeprom->chip = 0x66;

  ret = ftdi_eeprom_build(ftdi);
  if (ret < 0) {
    return ftdiutil_error("ftdi_build_eeprom", ret);
  }

  // Erase the eeprom so we can rewrite it.  This is dodgy; if we're
  // interrupted after this point, we'll lose data.
  ret = ftdi_erase_eeprom(ftdi);
  if (ret) {
    return ftdiutil_error("ftdi_erase_eeprom", ret);
  }

  ret = ftdi_write_eeprom(ftdi);
  if (ret) {
    return ftdiutil_error("ftdi_write_eeprom", ret);
  }

  // Read back the EEPROM, so we can verify that the right things changed.
  ret = ftdi_read_eeprom(ftdi);
  if (ret) {
    return ftdiutil_error("ftdi_read_eeprom", ret);
  }

  unsigned char post[256];
  ret = ftdi_get_eeprom_buf(ftdi, post, sizeof(post));
  if (ret) {
    return ftdiutil_error("ftdi_get_eeprom_buf", ret);
  }
  printf("Post:\n");
  show_eeprom_buf(post, sizeof(post));

  for (unsigned i = 0; i < sizeof(post); i++) {
    if (pre[i] != post[i]) {
      printf("Changed: [%02x] 0x%02x -> 0x%02x\n", i, pre[i], post[i]);
    }
  }

  printf("Done.  Power-cycle the board to complete.\n");

  return OK;
}
