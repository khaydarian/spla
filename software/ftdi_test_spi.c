// vi: ts=2:sw=2:sts=2:noet

#include "command.h"
#include "ftdi_util.h"
#include "ftdi.h"
#include "mpsse.h"
#include "status.h"

#include <unistd.h>
#include <stdio.h>

// [Command]
// Description: Test FTDI SPI interface.
// Option: open_usb = true
// Option: default_usb_device = cable
status ftdi_test_spi(int argc, char** argv) {
	// TODO handle per-command arguments
	(void) argc;
	(void) argv;

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

	int ret = ftdiutil_flush_data(ftdi);
	if (ret) {
		err = ftdiutil_error("ftdiutil_flush_data", ret);
	}

bad:
	status_ignore(mpsse_deinit());

	return err;
}
