// vi: ts=2:sw=2:sts=2:noet

#include "ftdiutil.h"

#include "ftdi.h"
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <libusb.h>

struct ftdi_context* ftdi;

static unsigned char* write_buf;
static int write_buf_len;
static int write_buf_cap;

struct readent {
	unsigned char* data;
	int size;
};

static struct readent* read_buf;
static int read_buf_len;
static int read_buf_cap;
static int read_buf_total_size;

status ftdiutil_init() {
	ftdi = ftdi_new();
	if (!ftdi) {
		return errorf("ftdi_new: error creating FTDDI context.");
	}
	libusb_set_debug(ftdi->usb_ctx, LIBUSB_LOG_LEVEL_ERROR);
	return OK;
}

void ftdiutil_deinit() {
	if (write_buf) {
		free(write_buf);
		write_buf = NULL;
	}
	if (read_buf) {
		free(read_buf);
		read_buf = NULL;
	}
	if (ftdi) {
		ftdi_free(ftdi);
		ftdi = NULL;
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
	if (write_buf_len) {
		fprintf(stderr, "Warning: Dropping %d bytes of buffered FTDI writes.\n",
				write_buf_len);
	}
	int ret = ftdi_usb_close(ftdi);
	if (ret) {
		return ftdiutil_error("ftdi_usb_close", ret);
	}
	return OK;
}

void ftdiutil_write_data(unsigned char* data, int size) {
	if (write_buf == NULL) {
		write_buf_len = 0;
		write_buf_cap = 1024;
		write_buf = (unsigned char*)malloc(write_buf_cap);
	}
	if (write_buf_len + size > write_buf_cap) {
		while (write_buf_len + size > write_buf_cap) {
			write_buf_cap *= 2;
		}
		write_buf = (unsigned char*)realloc(write_buf, write_buf_cap);
	}
	memcpy(write_buf + write_buf_len, data, size);
	write_buf_len += size;
}

status ftdiutil_flush_writes(const char* caller) {
	if (!caller) {
		caller = "ftdiutil_flush_writes";
	}
	unsigned char* data = write_buf;
	int size = write_buf_len;
	while (size > 0) {
		int ret = ftdi_write_data(ftdi, data, size);
		if (ret < 0) {
			write_buf_len = 0;
			return ftdiutil_error(caller, ret);
		}
		data += ret;
		size -= ret;
	}
	write_buf_len = 0;
	return OK;
}

void ftdiutil_read_data(unsigned char* data, int size) {
	if (read_buf == NULL) {
		read_buf_len = 0;
		read_buf_cap = 256;
		read_buf = (struct readent*)malloc(read_buf_cap * sizeof(struct readent));
	}
	if (read_buf_len == read_buf_cap) {
		read_buf_cap *= 2;
		read_buf = (struct readent*)realloc(read_buf,
				read_buf_cap * sizeof(struct readent));
	}
	read_buf[read_buf_len].data = data;
	read_buf[read_buf_len].size = size;
	read_buf_len++;
	read_buf_total_size += size;
}

#define min(a,b) ((a) < (b) ? (a) : (b));

status ftdiutil_flush_reads(const char* caller) {
	RETURN_IF_ERROR(ftdiutil_flush_writes(caller));
	if (!caller) {
		caller = "ftdiutil_flush_reads";
	}
	unsigned char buf[4096];
	int index = 0;
	int offset = 0;
	while (read_buf_total_size > 0) {
		int remain = min(read_buf_total_size, (int)sizeof(buf));
		int bytes_remain = ftdi_read_data(ftdi, buf, remain);
		if (bytes_remain < 0) {
			read_buf_len = 0;
			read_buf_total_size = 0;
			return ftdiutil_error(caller, bytes_remain);
		}
		unsigned char* src = buf;
		while (bytes_remain > 0) {
			assert(index < read_buf_len);
			assert(offset < read_buf[index].size);
			unsigned char* dest = &read_buf[index].data[offset];
			int dest_remain = read_buf[index].size - offset;
			int bytes_copied = min(dest_remain, bytes_remain);
			memcpy(dest, src, bytes_copied);
			src += bytes_copied;
			offset += bytes_copied;
			bytes_remain -= bytes_copied;
			read_buf_total_size -= bytes_copied;
			if (offset == read_buf[index].size) {
				index++;
				offset = 0;
			}
		}
	}
	read_buf_len = 0;
	return OK;
}
