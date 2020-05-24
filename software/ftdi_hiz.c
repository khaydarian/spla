// vi: ts=2:sw=2:sts=2:noet

#include "command.h"
#include "ftdiutil.h"
#include "ftdi.h"
#include "mpsse.h"

// [Command]
// Description: Test FTDI interface with individual commands.
// Option: open_usb = true
// Option: default_usb_device = board
status ftdi_hiz(int argc, char** argv) {
	RETURN_IF_ERROR(no_arguments(argc, argv));
	mpsse_init();

	ftdiutil_set_interface(INTERFACE_A);
	mpsse_set_data_bits_low_dir(0xff, 0, 0);
	mpsse_set_data_bits_high_dir(0xff, 0, 0);
	ftdiutil_set_interface(INTERFACE_B);
	mpsse_set_data_bits_low_dir(0xff, 0, 0);
	mpsse_set_data_bits_high_dir(0xff, 0, 0);

	return ftdiutil_flush_writes(0);
}
