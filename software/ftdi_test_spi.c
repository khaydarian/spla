// vi: ts=2:sw=2:sts=2:noet

#include "command.h"
#include "ftdi_util.h"
#include "ftdi.h"
#include "mpsse.h"
#include "status.h"

#include <unistd.h>
#include <stdio.h>

#define FTDI_VENDOR_ID 0x0403
#define FTDI_PRODUCT_ID 0x6014

status ftdi_test_spi(int argc, char** argv) {
	// TODO handle per-command arguments
	(void) argc;
	(void) argv;

	int ret = ftdi_usb_open_desc(ftdi, FTDI_VENDOR_ID, FTDI_PRODUCT_ID,
			"C232HM-DDHSL-0", "FT0J7C2U");
	if (ret) {
		return ftdiutil_error("ftdi_usb_open_desc", ret);
	}

	status err = OK;

	err = mpsse_init();
	if (is_error(err)) {
		goto bad;
	}

	err = mpsse_set_frequency("1MHz");
	if (is_error(err)) {
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
		err = ftdiutil_error("ftdiutil_flush_data", ret);
	}

bad:
	status_ignore(mpsse_deinit());

	ret = ftdi_usb_close(ftdi);
	if (ret) {
		status_ignore(ftdiutil_error("ftdi_usb_close", ret));
	}

	return err;
}
