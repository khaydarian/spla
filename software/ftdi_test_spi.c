// vi: ts=2:sw=2:sts=2:noet

#include "command.h"
#include "ftdiutil.h"
#include "ftdi.h"
#include "mpsse.h"
#include "status.h"

#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <signal.h>

bool flag_repeat = false;
char* flag_freq = "1MHz";
bool flag_read = false;

static status flag(int argc, char** argv, int* absorbed) {
	if (!strcmp(argv[0], "--freq")) {
		if (argc == 1) {
			return errorf("Missing required argument for flag --freq.");
		}
		flag_freq = argv[1];
		*absorbed = 2;
		return OK;
	}
	if (!strcmp(argv[0], "--repeat")) {
		flag_repeat = true;
		*absorbed = 1;
		return OK;
	}
	if (!strcmp(argv[0], "--read")) {
		flag_read = true;
		*absorbed = 1;
		return OK;
	}
	return errorf("Unexpected argument: %s", argv[0]);
}

static void sigint_handler(int signum) {
	(void) signum;
	flag_repeat = false;
}

// [Command]
// Description: Test FTDI SPI interface.
// Option: open_usb = true
// Option: default_usb_device = cable
status ftdi_test_spi(int argc, char** argv) {
	while (argc) {
		int absorbed;
		RETURN_IF_ERROR(flag(argc, argv, &absorbed));
		argc -= absorbed;
		argv += absorbed;
	}

	status err = OK;

	err = mpsse_init();
	if (is_error(err)) {
		goto bad;
	}

	err = mpsse_set_frequency(flag_freq);
	if (is_error(err)) {
		goto bad;
	}

	unsigned char data[255];
	for (unsigned i = 0; i < sizeof(data); i++) {
		data[i] = i;
	}
	unsigned char wbuf[] = "A";
	unsigned char rbuf[2];

	if (flag_repeat) {
		signal(SIGINT, sigint_handler);
	}

	if (flag_read) {
		do {
			mpsse_chip_select(true);
			mpsse_write_data(wbuf, sizeof(wbuf));
			mpsse_read_data(rbuf, sizeof(rbuf));
			mpsse_chip_select(false);
			RETURN_IF_ERROR(ftdiutil_flush_reads(0));
			printf("Read: ");
			for (unsigned i = 0; i < sizeof(rbuf); i++) {
				printf("%02x", rbuf[i]);
			}
			printf("\n");
		} while (flag_repeat);
	} else {
		do {
			mpsse_chip_select(true);
			mpsse_write_data(data, sizeof(data));
			mpsse_chip_select(false);
			RETURN_IF_ERROR(ftdiutil_flush_writes(0));
		} while (flag_repeat);
	}

bad:
	status_ignore(mpsse_deinit());

	return err;
}
