// vi: ts=2:sw=2:sts=2:et

#include <stdio.h>
#include "Vuart_rx.h"
#include "Vcore.h"

class UartRx : public Vcore<Vuart_rx> {
 public:
   UartRx() {
     rx_i = 1;
   }

   void send(uint8_t value) {
     const int clocks_per_baud = 6;

     // Start bit.
     rx_i = 0;
     tick(clocks_per_baud);

     // 8 bits, LSB first.
     for (int i = 0; i < 8; i++) {
       rx_i = value & 1;
       value >>= 1;
       tick(clocks_per_baud);
     }

     // Stop bit.
     rx_i = 1;
     tick(clocks_per_baud);
   }
};

int main(int argc, char** argv) {
  Verilated::commandArgs(argc, argv);

  UartRx u;
  u.trace_on("uart_rx.trace.vcd");

  u.tick(20);
  u.send(0x41);
  u.tick(30);
  u.send(0xaa);
  u.tick(30);
  u.send(0x55);
  u.tick(30);
  u.send(0x00);
  u.tick(30);
  u.send(0xff);
  u.tick(30);
  u.send(0x41);
  u.send(0xbe);
  u.send(0x41);
  u.tick(30);

  return 0;
}
