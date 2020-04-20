// vi: ts=2:sw=2:sts=2:noet

#include "ftdi_util.h"

#include "ftdi.h"
#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <libusb.h>

struct ftdi_context* ftdi;

void ftdiutil_init() {
	ftdi = ftdi_new();
	if (!ftdi) {
		fprintf(stderr, "ftdi_new: error creating FTDI context.\n");
		return;
	}

	libusb_set_debug(ftdi->usb_ctx, LIBUSB_LOG_LEVEL_ERROR);
}

void ftdiutil_deinit() {
	if (ftdi) {
		ftdi_free(ftdi);
	}
}

void ftdiutil_error(const char* fn, struct ftdi_context* ftdi, int ret) {
	fprintf(stderr, "%s: error %d: %s\n",
			fn, ret, ftdi_get_error_string(ftdi));
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
