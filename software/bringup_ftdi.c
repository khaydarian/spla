// vi: ts=2:sw=2:sts=2:noet

#include "command.h"
#include "ftdiutil.h"
#include "ftdi.h"
#include "mpsse.h"
#include <assert.h>
#include <stdio.h>

struct pins {
	unsigned char a_lo;
	unsigned char a_hi;
	unsigned char b_lo;
	unsigned char b_hi;
};

static void pins_set_single_bit(struct pins* p, int bit) {
	assert(bit >= 0 && bit < 32);
	p->a_lo = ( 0 <= bit && bit <  8 ? (1 << (bit -  0)) : 0);
	p->a_hi = ( 8 <= bit && bit < 16 ? (1 << (bit -  8)) : 0);
	p->b_lo = (16 <= bit && bit < 24 ? (1 << (bit - 16)) : 0);
	p->b_hi = (24 <= bit && bit < 32 ? (1 << (bit - 24)) : 0);
}

static status check_single_bit(struct pins dir, struct pins val, struct pins* readback) {
	// set all input/output directions

	ftdiutil_set_interface(INTERFACE_A);
	mpsse_set_data_bits_low_dir(0xff, dir.a_lo, val.a_lo);
	mpsse_set_data_bits_high_dir(0xff, dir.a_hi, val.a_hi);
	ftdiutil_set_interface(INTERFACE_B);
	mpsse_set_data_bits_low_dir(0xff, dir.b_lo, val.b_lo);
	mpsse_set_data_bits_high_dir(0xff, dir.b_hi, val.b_hi);
	RETURN_IF_ERROR(ftdiutil_flush_writes(NULL));

	ftdiutil_set_interface(INTERFACE_A);
	mpsse_get_data_bits_low(&readback->a_lo);
	mpsse_get_data_bits_high(&readback->a_hi);
	ftdiutil_set_interface(INTERFACE_B);
	mpsse_get_data_bits_low(&readback->b_lo);
	mpsse_get_data_bits_high(&readback->b_hi);
	RETURN_IF_ERROR(ftdiutil_flush_reads(NULL));

	return OK;
}

#define KEY(lo, hi, expect) (((hi)<<2)|((lo)<<1)|((expect)))

static struct {
	char bad;
	char ch;
} prbits[] = {
	[KEY(0, 0, 0)] = {.ch = '0', .bad = false},
	[KEY(0, 1, 0)] = {.ch = 'K', .bad = true},
	[KEY(1, 0, 0)] = {.ch = 'J', .bad = true},
	[KEY(1, 1, 0)] = {.ch = '1', .bad = false},
	[KEY(0, 0, 1)] = {.ch = 'L', .bad = true},
	[KEY(0, 1, 1)] = {.ch = 'G', .bad = false},
	[KEY(1, 0, 1)] = {.ch = 'I', .bad = true},
	[KEY(1, 1, 1)] = {.ch = 'H', .bad = true},
};

void print_bits(unsigned char bits_lo, unsigned char bits_hi,
		unsigned char expect, int* errors) {
	int err = *errors;
	for (int m = 0x80; m; m >>= 1) {
		int bit_lo = !!(m & bits_lo);
		int bit_hi = !!(m & bits_hi);
		int expect_bit = !!(m & expect);
		int k = KEY(bit_lo, bit_hi, expect_bit);
		bool bad = prbits[k].bad;
		if (bad) {
			err++;
			printf("\033[101;30m");
		}
		printf("%c", prbits[k].ch);
		if (bad) {
			printf("\033[0m");
		}
	}
	*errors = err;
}

// [Command]
// Description: Bringup check for bridged FTDI GPIO pins.
// Option: open_usb = true
// Option: default_usb_device = new
status bringup_ftdi(int argc, char** argv) {
	RETURN_IF_ERROR(no_arguments(argc, argv));

	RETURN_IF_ERROR(ftdiutil_set_interface(INTERFACE_A));
	RETURN_IF_ERROR(mpsse_init());
	RETURN_IF_ERROR(ftdiutil_set_interface(INTERFACE_B));
	RETURN_IF_ERROR(mpsse_init());

	int errors = 0;

	printf("         b_hi     b_lo     a_hi     a_lo\n");
	for (int bit = 0; bit <= 31; bit++) {
		struct pins dir;
		pins_set_single_bit(&dir, bit);
		struct pins rd_lo;
		struct pins rd_hi;

		struct pins val = {0, 0, 0, 0};
		RETURN_IF_ERROR(check_single_bit(dir, val, &rd_lo));
		pins_set_single_bit(&val, bit);
		RETURN_IF_ERROR(check_single_bit(dir, val, &rd_hi));

		printf("bit %02d: ", bit);
		printf(" "); print_bits(rd_lo.b_hi, rd_hi.b_hi, dir.b_hi, &errors);
		printf(" "); print_bits(rd_lo.b_lo, rd_hi.b_lo, dir.b_lo, &errors);
		printf(" "); print_bits(rd_lo.a_hi, rd_hi.a_hi, dir.a_hi, &errors);
		printf(" "); print_bits(rd_lo.a_lo, rd_hi.a_lo, dir.a_lo, &errors);
		printf("\n");
	}
	printf("         b_hi     b_lo     a_hi     a_lo\n");
	printf("pin      55555554 44444433 33332222 22221111\n");
	printf("         98754328 65431098 43209876 43219876\n");

	// Leave all pins high (except PROGRAM).
	RETURN_IF_ERROR(ftdiutil_set_interface(INTERFACE_A));
	mpsse_set_data_bits_low_dir(0xff, 0xff, 0xff);
	mpsse_set_data_bits_high_dir(0xff, 0xff, 0xff);
	RETURN_IF_ERROR(ftdiutil_set_interface(INTERFACE_B));
	mpsse_set_data_bits_low_dir(0xff, 0xff, 0xbf);
	mpsse_set_data_bits_high_dir(0xff, 0xff, 0xff);
	RETURN_IF_ERROR(ftdiutil_flush_writes(NULL));

	printf("Errors: %d\n", errors);

	if (errors) {
		return errorf("FAIL");
	}
	printf("PASS\n");
	return OK;
}
