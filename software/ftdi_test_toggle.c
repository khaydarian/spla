// vi: ts=2:sw=2:sts=2:noet

#include "command.h"
#include "ftdi_util.h"
#include "ftdi.h"
#include "status.h"

#include <unistd.h>
#include <stdio.h>

#define FTDI_VENDOR_ID 0x0403
#define FTDI_PRODUCT_ID 0x6014

status ftdi_test_toggle(int argc, char** argv) {
	// TODO handle per-command arguments
	(void) argc;
	(void) argv;

	int ret = ftdi_usb_open_desc(ftdi, FTDI_VENDOR_ID, FTDI_PRODUCT_ID,
			"C232HM-DDHSL-0", "FT0J7C2U");
	if (ret) {
		return ftdiutil_error("ftdi_usb_open_desc", ret);
	}

	status err = OK;
	ret = ftdi_set_bitmode(ftdi, 0xFF, BITMODE_BITBANG);
	if (ret) {
		err = ftdiutil_error("ftdi_set_bitmode", ret);
	} else {
		unsigned char buf[1];

		for (int i = 0; i < 100; i++) {
			printf("On\n");
			buf[0] = 0xFF;
			ret = ftdi_write_data(ftdi, buf, 1);
			if (ret < 0) {
				err = ftdiutil_error("ftdi_write_data", ret);
				break;
			}
			usleep(1000000);
			printf("Off\n");
			buf[0] = 0x0;
			ret = ftdi_write_data(ftdi, buf, 1);
			if (ret < 0) {
				err = ftdiutil_error("ftdi_write_data", ret);
				break;
			}
			usleep(1000000);
		}
	}

	// Reset all pins to inputs / hi-z.
	//ret = ftdi_set_bitmode(ftdi, 0x00, BITMODE_BITBANG);
	//if (ret) {
	//	err = ftdiutil_error("ftdi_set_bitmode", ret);
	//}

	ret = ftdi_usb_close(ftdi);
	if (ret) {
		status_ignore(ftdiutil_error("ftdi_usb_close", ret));
	}

	return err;
}
