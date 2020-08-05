// vi: ts=2:sw=2:sts=2:et

#include <stdio.h>
#include "Vcore.h"
#include "Vvram_control.h"

class VramControl : public Vcore<Vvram_control> {
 public:
  VramControl() {
    // Always ready for an output byte.
    write_ready_i = 1;
    reset = 0;
  }

  void unreset() {
    mtick(3);
    reset = 1;
    mtick();
  }

  void send_byte(uint8_t byte) {
    read_data_i = byte;
    read_valid_i = 1;
    mtick();
    read_valid_i = 0;
  }

  void send_op(uint8_t opcode, uint8_t arg) {
    send_byte(opcode);
    mtick(3);
    send_byte(arg);
    mtick(6);
  }

  uint8_t wait_output(int max_cycles = 100) {
    int i = 0;
    while (1) {
      if (i >= max_cycles) {
        fprintf(stderr, "Error: no output.\n");
        trace_off();
        exit(1);
        return 0;
      }
      mtick();
      if (write_valid_o) {
        break;
      }
    }
    uint8_t out = write_data_o;
    write_ready_i = 0;
    mtick(6);
    write_ready_i = 1;
    return out;
  }

  void mtick(unsigned n = 1) {
    for (unsigned i = 0; i < n; i++) {
      update_inputs();
      tick();
    }
  }

  int vrd_n_o_last = 1;
  int vrd_counter = 0;

  int vawr_n_o_last = 1;
  int vawr_counter = 0;

  int vbwr_n_o_last = 1;
  int vbwr_counter = 0;

  uint8_t a_chip[32768];
  uint8_t b_chip[32768];

  void update_inputs() {
    if (vrd_n_o == 1 && vawr_n_o == 1 && vbwr_n_o == 1) {
      return;
    }

    const int cycle_threshold = 10;

    if (vrd_n_o == 0) {
      if (vrd_n_o_last != vrd_n_o) {
        vrd_n_o_last = vrd_n_o;
        vrd_counter = 0;
      }
      if (vrd_counter >= cycle_threshold) {
        vda_i = a_chip[va14_o << 14 | vaa_o];
        vdb_i = b_chip[va14_o << 14 | vab_o];
      } else {
        vda_i = 0x00;
        vdb_i = 0x00;
      }
      vrd_counter++;
    }

    if (vawr_n_o == 0) {
      if (vawr_n_o_last != vawr_n_o) {
        vawr_n_o_last = vawr_n_o;
        vawr_counter = 0;
      }
      if (vawr_counter >= cycle_threshold) {
        a_chip[va14_o << 14 | vaa_o] = vda_o;
      }
      vawr_counter++;
    }

    if (vbwr_n_o == 0) {
      if (vbwr_n_o_last != vbwr_n_o) {
        vbwr_n_o_last = vbwr_n_o;
        vbwr_counter = 0;
      }
      if (vbwr_counter >= cycle_threshold) {
        b_chip[va14_o << 14 | vab_o] = vdb_o;
      }
      vbwr_counter++;
    }
  }
};

int main(int argc, char** argv) {
  Verilated::commandArgs(argc, argv);

  VramControl v;
  v.trace_on("vram_control.trace.vcd");

  v.unreset();
  v.mtick(10);

  printf("ECHO: send 0x41\n");
  v.send_byte(0x02);
  v.mtick(2);
  v.send_byte(0x41);

  uint8_t first = v.wait_output();
  uint8_t second = v.wait_output();
  printf("ECHO: Got 0x%02x 0x%02x\n", first, second);

  v.mtick(20);

  v.send_op(0x21, 0x3e);
  v.send_op(0x20, 0x56);
  v.send_op(0x50, 0xef);
  v.send_op(0x51, 0xfe);

  v.mtick(20);

  v.send_op(0x80, 0x00);  // Write

  v.mtick(20);

  v.mtick(100);

  v.send_op(0x90, 0x00);  // Read
  first = v.wait_output();
  second = v.wait_output();
  printf("Read: Got 0x%02x 0x%02x\n", first, second);
  v.mtick(20);

  return 0;
}
