// vi: ts=2:sw=2:sts=2:et

#ifndef VCD_H
#define VCD_H

#include <stdint.h>
#include "status.h"

struct vcd;
struct vcd_signal;

status vcd_open(struct vcd** v, const char* filename)
    __attribute__((warn_unused_result));
void vcd_close(struct vcd** v);

void vcd_set_module_name(struct vcd* v, const char* modulename);

struct vcd_signal* vcd_add_signal(struct vcd* v, const char* name,
                                  unsigned int bits);

status vcd_value(struct vcd_signal* vs, uint32_t value)
    __attribute__((warn_unused_result));
status vcd_timestamp(struct vcd* v, uint32_t timestamp)
    __attribute__((warn_unused_result));

#endif
