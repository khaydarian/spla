// vi: ts=2:sw=2:sts=2:et

#ifndef ECP5_H
#define ECP5_H

#include <stdint.h>
#include "bitstream.h"
#include "status.h"

static const uint32_t ECP5_CHIP_ID_LFE5U_45 = 0x41112043;

status ecp5_init();

void ecp5_set_led3(bool active);
void ecp5_set_program(bool active);
void ecp5_set_hold(bool active);

status ecp5_reset();
status ecp5_release_reset();

status ecp5_read_id(uint32_t* id);
status ecp5_usercode(uint32_t* usercode);
status ecp5_program_usercode(uint32_t usercode);

status ecp5_write_bitstream(struct bitstream* bits);

#endif
