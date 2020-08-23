// vi: ts=2:sw=2:sts=2:et

#include "uart.h"
#include "ftdi.h"
#include "ftdiutil.h"

status uart_init() {
  RETURN_IF_ERROR(ftdiutil_set_bitmode_uart());
  int ret = ftdi_set_baudrate(ftdi, 115200);
  if (ret) {
    return ftdiutil_error("ftdi_set_baudrate", ret);
  }
  // HACK: We're setting two stop bits here as a workaround
  // for problematic code in the uart_rx RTL.  This is a bad idea.
  ret = ftdi_set_line_property(ftdi, BITS_8, STOP_BIT_2, NONE);
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
