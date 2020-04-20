// vi: ts=2:sw=2:sts=2:noet

#include "command.h"
#include "ftdi_util.h"
#include "ftdi.h"
#include "mpsse.h"

#include <unistd.h>
#include <stdio.h>

#define FTDI_VENDOR_ID 0x0403
#define FTDI_PRODUCT_ID 0x6014

int ftdi_test_spi(int argc, char** argv) {
	// TODO handle per-command arguments
	(void) argc;
	(void) argv;

	int ret = ftdi_usb_open_desc(ftdi, FTDI_VENDOR_ID, FTDI_PRODUCT_ID,
			"C232HM-DDHSL-0", "FT0J7C2U");
	if (ret) {
		ftdiutil_error("ftdi_usb_open_desc", ftdi, ret);
		return 1;
	}

	ret = mpsse_init();
	if (ret) {
		ftdiutil_error("mpsse_init", ftdi, ret);
		goto bad;
	}

	ret = mpsse_set_frequency("1MHz");
	if (ret) {
		ftdiutil_error("mpsse_set_frequency", ftdi, ret);
		goto bad;
	}

	mpsse_chip_select(true);

	unsigned char data[255];
	for (unsigned i = 0; i < sizeof(data); i++) {
		data[i] = i;
	}

	mpsse_write_data(data, sizeof(data));

	mpsse_chip_select(false);

	ret = ftdiutil_flush_data(ftdi);
	if (ret) {
		ftdiutil_error("ftdiutil_flush_data", ftdi, ret);
	}

bad:
	ret = mpsse_deinit();
	(void) ret;

	ret = ftdi_usb_close(ftdi);
	if (ret) {
		ftdiutil_error("ftdi_usb_close", ftdi, ret);
	}

	return 0;
}
