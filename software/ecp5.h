// vi: ts=2:sw=2:sts=2:et

#ifndef ECP5_H
#define ECP5_H

#include <stdint.h>
#include "status.h"

static const uint32_t ECP5_CHIP_ID_LFE5U_45 = 0x41112043;

status ecp5_init();

void ecp5_set_led3(bool active);
void ecp5_set_program(bool active);

status ecp5_reset();
status ecp5_release_reset();

status ecp5_read_status(uint32_t* status);
status ecp5_error_status(uint32_t status);
status ecp5_check_status();
bool ecp5_status_is_offline(uint32_t status);
bool ecp5_status_is_done(uint32_t status);
status ecp5_check_done();
void ecp5_debug_status_dump(uint32_t status);

status ecp5_read_id(uint32_t* id);
status ecp5_verify_id(uint32_t id);
status ecp5_usercode(uint32_t* usercode);
status ecp5_program_usercode(uint32_t usercode);

status ecp5_reset_crc();
status ecp5_init_address();

status ecp5_program_done();
status ecp5_isc_enable();
status ecp5_isc_disable();

status ecp5_erase();

status ecp5_write_idle_bytes(int count);

status ecp5_bitstream_burst(uint8_t* bitstream, unsigned int size,
                            void (*progress_fn)(unsigned int, unsigned int));

#endif
