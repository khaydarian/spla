// vi: ts=2:sw=2:sts=2:noet

#include "command.h"
#include "ftdi_util.h"
#include "ftdi.h"
#include "mpsse.h"

#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>

static int single_command(int argc, char** argv) {
	int ret;
	assert(argc > 0);
	char* command = argv[0];
	printf("--- %s\n", command);
	if (!strcmp(command, "usbreset")) {
		ret = ftdi_usb_reset(ftdi);
		if (ret) {
			status_ignore(ftdiutil_error("ftdi_usb_reset", ret));
		}
		usleep(25000);
		return 1;
	} else if (!strcmp(command, "mpsse")) {
		status_ignore(mpsse_init());
		usleep(25000);
		return 1;
	} else if (!strcmp(command, "bitbang")) {
		ret = ftdi_set_bitmode(ftdi, 0x00, BITMODE_BITBANG);
		if (ret) {
			status_ignore(ftdiutil_error("ftdi_set_bitmode(BITBANG)", ret));
		}
		return 1;
	} else if (!strcmp(command, "bbout") && argc >= 2) {
		int outputs = strtol(argv[1], 0, 0) & 0xFF;
		printf("outputs = 0x%02x\n", outputs);
		ret = ftdi_set_bitmode(ftdi, outputs, BITMODE_BITBANG);
		if (ret) {
			status_ignore(ftdiutil_error("ftdi_set_bitmode(BITBANG)", ret));
		}
		return 2;
	} else if (!strcmp(command, "bbval") && argc >= 2) {
		int values = strtol(argv[1], 0, 0) & 0xFF;
		printf("values = 0x%02x\n", values);
		unsigned char buf[1] = {values};
		ret = ftdi_write_data(ftdi, buf, sizeof(buf));
		if (ret < 0) {
			status_ignore(ftdiutil_error("ftdi_write_data", ret));
		}
		return 2;
	} else if (!strcmp(command, "lo") && argc >= 2) {
		int bits = strtol(argv[1], 0, 0) & 0xFF;
		printf("bits = 0x%02x\n", bits);
		mpsse_set_data_bits_low(bits);
		return 2;
	} else if (!strcmp(command, "cs+")) {
		mpsse_chip_select(true);
		return 1;
	} else if (!strcmp(command, "cs-")) {
		mpsse_chip_select(false);
		return 1;
	} else if (!strcmp(command, "freq") && argc >= 2) {
		status_ignore(mpsse_set_frequency(argv[1]));
		return 2;
	} else if (!strcmp(command, "sleep")) {
		ret = ftdiutil_flush_data();
		if (ret) {
			status_ignore(ftdiutil_error("ftdiutil_flush_data", ret));
		}
		usleep(500000);
		return 1;
	} else if (!strcmp(command, "clock") && argc >= 2) {
		int bytes = strtol(argv[1], 0, 0);
		mpsse_clock_only(bytes);
		return 2;
	} else if (!strcmp(command, "read")) {
		ret = ftdiutil_flush_data();
		if (ret) {
			status_ignore(ftdiutil_error("ftdiutil_flush_data", ret));
		}
		unsigned char buf[255];
		int ret = ftdi_read_data(ftdi, buf, sizeof(buf));
		if (ret < 0) {
			status_ignore(ftdiutil_error("ftdi_read_data", ret));
		}
		printf("Read[%d]\n", ret);
		for (int i = 0; i < ret; i++) {
			if (i % 32 == 0) printf(" ");
			if (i % 4 == 0) printf(" ");
			printf("%02X", buf[i]);
			if (i % 32 == 31) printf("\n");
		}
		if (ret % 32 != 0) printf("\n");
		return 1;
	}
	printf("ERROR: Unknown command \"%s\"\n", command);
	return 1;
}

// [Command]
// Description: Test FTDI interface with individual commands.
// Option: open_usb = true
// Option: default_usb_device = cable
status ftdi_test_raw(int argc, char** argv) {
	// TODO handle per-command arguments
	(void) argc;
	(void) argv;

	while (argc > 0) {
		int absorbed = single_command(argc, argv);
		argc -= absorbed;
		argv += absorbed;
	}

	int ret = ftdiutil_flush_data();
	if (ret) {
		status_ignore(ftdiutil_error("ftdiutil_flush_data", ret));
	}

	return OK;
}
