// vi: ts=2:sw=2:sts=2:noet

#include "ftdi_util.h"

#include "ftdi.h"
#include <stdio.h>
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
