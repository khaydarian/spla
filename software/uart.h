// vi: ts=2:sw=2:sts=2:et

#ifndef UART_H
#define UART_H

#include <stdint.h>
#include "status.h"

status uart_init();

status uart_read(uint8_t* data, unsigned int* size);

#endif
