// vi: ts=2:sw=2:sts=2:noet

#include "command.h"
#include "ftdiutil.h"
#include "ftdi.h"
#include "ftdi_i.h"
#include "mpsse.h"
#include "constants.h"

#include <assert.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>

static bool FLAG_read = true;
static bool FLAG_erase = false;
static bool FLAG_write = false;
static char* FLAG_manufacturer = DEFAULT_MANUFACTURER;
static char* FLAG_description = DEFAULT_DESCRIPTION;
static char* FLAG_serial = NULL; // ie, "SPLA_r009_b001"

static status parse_flag(int argc, char** argv, int* absorbed) {
	(void) argc;
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
	return errorf("Unknown flag: %s", arg);
}

static char chr(unsigned char ch) {
	return isprint(ch) ? ch : '.';
}

static void show_eeprom_buf(unsigned char* buf, int size) {
	assert(size % 16 == 0);
	for (int i = 0; i < size; i += 16) {
		printf("0x%04x:", i);
		for (int j = 0; j < 16; j += 2) {
			printf(" %02x%02x", buf[i+j], buf[i+j+1]);
		}
		printf("  ");
		for (int j = 0; j < 16; j += 2) {
			printf("%c%c", chr(buf[i+j]), chr(buf[i+j+1]));
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
		ret = ftdi_eeprom_initdefaults(ftdi,
				FLAG_manufacturer, FLAG_description, FLAG_serial);
		if (ret) {
			return ftdiutil_error("ftdi_init_defaults", ret);
		}

		ret = ftdi_set_eeprom_value(ftdi, SELF_POWERED, 1);
		assert(ret == 0);
		ret = ftdi_set_eeprom_value(ftdi, MAX_POWER, 0);
		assert(ret == 0);

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
