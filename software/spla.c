#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <ftdi.h>
#include <libusb.h>

static inline bool streq(const char* a, const char* b) {
	return strcmp(a, b) == 0;
}

static int help(const char* program) {
	fprintf(stderr, "usage: %s [subcommand] <options...>\n", program);
	return 1;
}

static int show(int argc, char** argv) {
	(void) argc;
	(void) argv;
	struct ftdi_context* ftdi = ftdi_new();
	if (!ftdi) {
		fprintf(stderr, "Error opening FTDI context.\n");
		return 1;
	}

	libusb_set_debug(ftdi->usb_ctx, LIBUSB_LOG_LEVEL_ERROR);

	struct ftdi_device_list* devlist;
	int ret = ftdi_usb_find_all(ftdi, &devlist, 0, 0);
	if (ret < 0) {
		fprintf(stderr, "ftdi_usb_find_all: error %d: %s\n",
			ret, ftdi_get_error_string(ftdi));
		ftdi_free(ftdi);
		return 1;
	}

	printf("Found %d FTDI devices:\n", ret);

	char manufacturer[256];
	char description[256];
	char serial[256];

	int i = 0;
	for (struct ftdi_device_list* cur = devlist; cur; cur = cur->next, i++) {
		printf("Device #%d:\n", i);
		ret = ftdi_usb_get_strings(ftdi, cur->dev,
				manufacturer, sizeof(manufacturer),
				description, sizeof(description),
				serial, sizeof(serial));
		if (ret < 0) {
			fprintf(stderr, "ftdi_usb_get_strings: error %d: %s\n",
					ret, ftdi_get_error_string(ftdi));
			ftdi_list_free(&devlist);
			ftdi_free(ftdi);
			return 1;
		}
		printf("  Manufacturer: %s\n", manufacturer);
		printf("  Description: %s\n", description);
		printf("  Serial: %s\n", serial);
	}

	ftdi_list_free(&devlist);
	ftdi_free(ftdi);
	return 0;
}

int main(int argc, char** argv) {
	if (argc < 2) {
		return help(argv[0]);
	}
	const char* subcommand = argv[1];
	if (streq(subcommand, "help")) {
		return help(argv[0]);
	} else if (streq(subcommand, "show")) {
		return show(argc - 2, argv + 2);
	} else {
		fprintf(stderr, "Unknown subcommand \"%s\". Try \"%s help\".\n", subcommand, argv[0]);
		return 1;
	}
}
