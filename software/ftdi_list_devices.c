// vi: ts=2:sw=2:sts=2:noet

#include <stdio.h>
#include <libusb.h>

#include "command.h"
#include "ftdi.h"
#include "ftdi_util.h"

int ftdi_list_devices(int argc, char** argv) {
	// TODO handle per-command arguments
	(void) argc;
	(void) argv;

	struct ftdi_device_list* devlist;
	int ret = ftdi_usb_find_all(ftdi, &devlist, 0, 0);
	if (ret < 0) {
		ftdiutil_error("ftdi_usb_find_all", ftdi, ret);
		return 1;
	}

	printf("Found %d FTDI device%s:\n", ret, (ret == 1 ? "" : "s"));

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
			ftdiutil_error("ftdi_usb_get_strings", ftdi, ret);
			ftdi_list_free(&devlist);
			return 1;
		}
		printf("  Manufacturer: %s\n", manufacturer);
		printf("  Description:  %s\n", description);
		printf("  Serial:       %s\n", serial);
	}

	ftdi_list_free(&devlist);
	return 0;
}
