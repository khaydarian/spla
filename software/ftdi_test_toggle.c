// vi: ts=2:sw=2:sts=2:noet

#include "command.h"
#include "ftdi_util.h"
#include "ftdi.h"

#include <unistd.h>
#include <stdio.h>

#define FTDI_VENDOR_ID 0x0403
#define FTDI_PRODUCT_ID 0x6014

int ftdi_test_toggle(int argc, char** argv) {
	// TODO handle per-command arguments
	(void) argc;
	(void) argv;

	int ret = ftdi_usb_open_desc(ftdi, FTDI_VENDOR_ID, FTDI_PRODUCT_ID,
			"C232HM-DDHSL-0", "FT0J7C2U");
	if (ret) {
		ftdiutil_error("ftdi_usb_open_desc", ftdi, ret);
		return 1;
	}

	ret = ftdi_set_bitmode(ftdi, 0xFF, BITMODE_BITBANG);
	if (ret) {
		ftdiutil_error("ftdi_set_bitmode", ftdi, ret);
	} else {
		unsigned char buf[1];

		for (int i = 0; i < 10; i++) {
			printf("On\n");
			buf[0] = 0xFF;
			ret = ftdi_write_data(ftdi, buf, 1);
			if (ret < 0) {
				ftdiutil_error("ftdi_write_data", ftdi, ret);
			}
			usleep(1000000);
			printf("Off\n");
			buf[0] = 0x0;
			ret = ftdi_write_data(ftdi, buf, 1);
			if (ret < 0) {
				ftdiutil_error("ftdi_write_data", ftdi, ret);
			}
			usleep(1000000);
		}
	}

	// Reset all pins to inputs / hi-z.
	ret = ftdi_set_bitmode(ftdi, 0x00, BITMODE_BITBANG);
	if (ret) {
		ftdiutil_error("ftdi_set_bitmode", ftdi, ret);
	}

	ret = ftdi_usb_close(ftdi);
	if (ret) {
		ftdiutil_error("ftdi_usb_close", ftdi, ret);
	}

	return 0;
}
