// vi: ts=2:sw=2:sts=2:et

#include <stdio.h>
#include "Vbringup_sensor.h"
#include "Vcore.h"

class BringupSensor : public Vcore<Vbringup_sensor> {
 public:
  void tick_with_dec(int n = 1) {
    for (int i = 0; i < n; i++) {
      dec_i = (cycle() % 10 == 0);
      tick();
    }
  }
};

int main(int argc, char** argv) {
  Verilated::commandArgs(argc, argv);

  BringupSensor s;
  s.trace_on("bringup_sensor.trace.vcd");

  for (int i = 0; i < 32 * 6 + 20; i++) {
    if (i % 6 == 5) s.pin_i = 1 - s.pin_i;
    s.tick_with_dec();
  }

  s.tick_with_dec(300);

  return 0;
}
