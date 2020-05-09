// vi: ts=2:sw=2:sts=2:noet

#include "ftdi_util.h"

#include "ftdi.h"
#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <libusb.h>

struct ftdi_context* ftdi;

status ftdiutil_init() {
	ftdi = ftdi_new();
	if (!ftdi) {
		return errorf("ftdi_new: error creating FTDDI context.");
	}
	libusb_set_debug(ftdi->usb_ctx, LIBUSB_LOG_LEVEL_ERROR);
	return OK;
}

void ftdiutil_deinit() {
	if (ftdi) {
		ftdi_free(ftdi);
	}
}

status ftdiutil_error(const char* fn, int ret) {
	return errorf("%s: error %d: %s",
			fn, ret, ftdi_get_error_string(ftdi));
}

static const char* default_usb_device;
static const char* preferred_usb_device;

status ftdiutil_set_usb_device(const char* which) {
	preferred_usb_device = which;
	return OK;
}

status ftdiutil_set_default_usb_device(const char* which) {
	default_usb_device = which;
	return OK;
}

#define FTDI_VENDOR_ID 0x0403
#define FTDI_PRODUCT_ID 0x6014

status ftdiutil_open_usb() {
	const char* device;
	if (preferred_usb_device) {
		device = preferred_usb_device;
	} else if (default_usb_device) {
		device = default_usb_device;
	} else {
		// TODO: search for relevant devices, open if unambiguous
		return errorf("ftdiutil_open_usb: No default device specified; use --device.");
	}

	int device_vendor_id;
	int device_product_id;
	const char* device_description;
	const char* device_serial;

	if (!strcmp(device, "cable")) {
		device_vendor_id = FTDI_VENDOR_ID;
		device_product_id = FTDI_PRODUCT_ID;
		device_description = "C232HM-DDHSL-0";
		device_serial = "FT0J7C2U";
	} else {
		return errorf("Unknown device alias '%s'.", device);
	}

	int ret = ftdi_usb_open_desc(ftdi,
			device_vendor_id, device_product_id, device_description, device_serial);
	if (ret) {
		return ftdiutil_error("ftdi_usb_open_desc", ret);
	}
	return OK;
}

status ftdiutil_close_usb() {
	int ret = ftdi_usb_close(ftdi);
	if (ret) {
		return ftdiutil_error("ftdi_usb_close", ret);
	}
	return OK;
}

static unsigned char* write_buf;
static int write_buf_len;
static int write_buf_cap;

void ftdiutil_write_data(unsigned char* data, int size) {
	if (write_buf == NULL) {
		write_buf_len = 0;
		write_buf_cap = 1024;
		write_buf = (unsigned char*)malloc(write_buf_cap);
	}
	while (write_buf_len + size > write_buf_cap) {
		write_buf_cap *= 2;
		write_buf = (unsigned char*)realloc(write_buf, write_buf_cap);
	}
	memcpy(write_buf + write_buf_len, data, size);
	write_buf_len += size;
}

int ftdiutil_flush_data() {
	unsigned char* data = write_buf;
	int size = write_buf_len;
	while (size > 0) {
		int ret = ftdi_write_data(ftdi, data, size);
		if (ret < 0) {
			write_buf_len = 0;
			return ret;
		}
		data += ret;
		size -= ret;
	}
	write_buf_len = 0;
	return 0;
}

int ftdiutil_read_data(unsigned char* data, int size) {
	while (size > 0) {
		int ret = ftdi_read_data(ftdi, data, size);
		if (ret < 0) {
			return ret;
		}
		data += ret;
		size -= ret;
	}
	return 0;
}
