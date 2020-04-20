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
			ftdiutil_error("ftdi_usb_reset", ftdi, ret);
		}
		usleep(25000);
		return 1;
	} else if (!strcmp(command, "mpsse")) {
		mpsse_init();
		usleep(25000);
		return 1;
	} else if (!strcmp(command, "bitbang")) {
		ret = ftdi_set_bitmode(ftdi, 0x00, BITMODE_BITBANG);
		if (ret) {
			ftdiutil_error("ftdi_set_bitmode(BITBANG)", ftdi, ret);
		}
		return 1;
	} else if (!strcmp(command, "bbout") && argc >= 2) {
		int outputs = strtol(argv[1], 0, 0) & 0xFF;
		printf("outputs = 0x%02x\n", outputs);
		ret = ftdi_set_bitmode(ftdi, outputs, BITMODE_BITBANG);
		if (ret) {
			ftdiutil_error("ftdi_set_bitmode(BITBANG)", ftdi, ret);
		}
		return 2;
	} else if (!strcmp(command, "bbval") && argc >= 2) {
		int values = strtol(argv[1], 0, 0) & 0xFF;
		printf("values = 0x%02x\n", values);
		unsigned char buf[1] = {values};
		ret = ftdi_write_data(ftdi, buf, sizeof(buf));
		if (ret < 0) {
			ftdiutil_error("ftdi_write_data", ftdi, ret);
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
		ret = mpsse_set_frequency(argv[1]);
		if (ret) {
			ftdiutil_error("mpsse_set_frequency", ftdi, ret);
		}
		return 2;
	} else if (!strcmp(command, "sleep")) {
		ret = ftdiutil_flush_data();
		if (ret) {
			ftdiutil_error("ftdiutil_flush_data", ftdi, ret);
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
			ftdiutil_error("ftdiutil_flush_data", ftdi, ret);
		}
		unsigned char buf[255];
		int ret = ftdi_read_data(ftdi, buf, sizeof(buf));
		if (ret < 0) {
			ftdiutil_error("ftdi_read_data", ftdi, ret);
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

#define FTDI_VENDOR_ID 0x0403
#define FTDI_PRODUCT_ID 0x6014

int ftdi_test_raw(int argc, char** argv) {
	// TODO handle per-command arguments
	(void) argc;
	(void) argv;

	int ret = ftdi_usb_open_desc(ftdi, FTDI_VENDOR_ID, FTDI_PRODUCT_ID,
			"C232HM-DDHSL-0", "FT0J7C2U");
	if (ret) {
		ftdiutil_error("ftdi_usb_open_desc", ftdi, ret);
		return 1;
	}

	while (argc > 0) {
		int absorbed = single_command(argc, argv);
		argc -= absorbed;
		argv += absorbed;
	}

	ret = ftdiutil_flush_data();
	if (ret) {
		ftdiutil_error("ftdiutil_flush_data", ftdi, ret);
	}

	ret = ftdi_usb_close(ftdi);
	if (ret) {
		ftdiutil_error("ftdi_usb_close", ftdi, ret);
		return ret;
	}
	return 0;
}
