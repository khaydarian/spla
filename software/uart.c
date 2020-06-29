// vi: ts=2:sw=2:sts=2:et

#include "uart.h"
#include "ftdi.h"
#include "ftdiutil.h"

status uart_init() {
  int ret = ftdi_set_bitmode(ftdi, 0, BITMODE_RESET);
  if (ret) {
    return ftdiutil_error("ftdi_set_bitmode(UART)", ret);
  }
  ret = ftdi_set_baudrate(ftdi, 115200);
  if (ret) {
    return ftdiutil_error("ftdi_set_baudrate", ret);
  }
  ret = ftdi_set_line_property(ftdi, BITS_8, STOP_BIT_1, NONE);
  if (ret) {
    return ftdiutil_error("ftdi_set_line_property(8N1)", ret);
  }
  ret = ftdi_set_latency_timer(ftdi, 1);
  if (ret) {
    return ftdiutil_error("ftdi_set_latency_timer()", ret);
  }
  return OK;
}

status uart_read(uint8_t* data, unsigned int* size) {
  int maxsize = *size;
  int ret = ftdi_read_data(ftdi, data, maxsize);
  if (ret < 0) {
    return ftdiutil_error("uart_read", ret);
  }
  *size = ret;
  return OK;
}
