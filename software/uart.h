// vi: ts=2:sw=2:sts=2:et

#ifndef UART_H
#define UART_H

#include <stdint.h>
#include "status.h"

status uart_init() __attribute__((warn_unused_result));

status uart_read(uint8_t* data, unsigned int* size)
    __attribute__((warn_unused_result));

#endif
