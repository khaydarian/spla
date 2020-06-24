// vi: ts=2:sw=2:sts=2:et

#include <stdio.h>
#include "Vbringup_scanner.h"
#include "Vcore.h"

class BringupScanner : public Vcore<Vbringup_scanner> {
 public:
  BringupScanner() {
    state_i[0] = 0xddccbbaa;
    state_i[1] = 0x1d1c1b1a;
    state_i[2] = 0x2d2c2b2a;
    state_i[3] = 0x3d3c3b3a;
    state_i[4] = 0x4d4c4b4a;
    state_i[5] = 0x5d5c5b5a;
  }

  void pulse() {
    pulse_i = 1;
    tick();
    pulse_i = 0;
  }

  void tick_with_uart(unsigned cycles) {
    for (unsigned i = 0; i < cycles; i++) {
      if (counter) {
        counter--;
      } else if (write_o) {
        counter = 4;
      }
      hold_i = (counter > 0);
      tick();
    }
  }

 private:
  int counter = 0;
};

int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);

  BringupScanner s;
  s.trace_on("bringup_scanner.trace.vcd");

  s.tick_with_uart(10);
  s.pulse();
  s.tick_with_uart(200);
  s.pulse();
  s.tick_with_uart(200);

  return 0;
}
