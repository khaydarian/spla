// vi: ts=2:sw=2:sts=2:et

#include <stdio.h>
#include "Vcore.h"
#include "Vvram_control.h"

class VramControl : public Vcore<Vvram_control> {
 public:
  VramControl() {
    // Always ready for an output byte.
    // write_ready_i = 1;
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

  void mtick(unsigned n = 1) {
    for (unsigned i = 0; i < n; i++) {
      update_inputs();
      tick();
      handle_outputs();
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

  const int cycle_threshold = 7;

  void update_inputs() {
    if (vrd_n_o == 1 && vawr_n_o == 1 && vbwr_n_o == 1) {
      return;
    }

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

  unsigned ready_delay_counter = 0;

  void handle_outputs() {
    if (write_valid_o) {
      assert(outbuf_size < sizeof(outbuf));
      outbuf[outbuf_size] = write_data_o;
      outbuf_size++;
      ready_delay_counter = 6;
      // write_ready_i = 0;
    } else if (ready_delay_counter > 0) {
      ready_delay_counter--;
      if (ready_delay_counter == 0) {
        // write_ready_i = 1;
      }
      assert(ready_delay_counter < 6);
    }
  }

  uint8_t outbuf[16];
  unsigned outbuf_size = 0;

  uint8_t wait_output(unsigned max_cycles = 100) {
    for (unsigned i = 0; !outbuf_size; i++) {
      mtick();
      if (i >= max_cycles) {
        printf("Error: no output!\n");
        return 0xff;
      }
    }
    uint8_t ret = outbuf[0];
    for (unsigned i = 1; i < outbuf_size; i++) {
      outbuf[i - 1] = outbuf[i];
    }
    outbuf_size--;
    return ret;
  }
};

int main(int argc, char** argv) {
  Verilated::commandArgs(argc, argv);

  VramControl v;
  v.trace_on("vram_control.trace.vcd");

  v.mtick(10);

  printf("ECHO: send 0x41\n");
  v.send_op(0x01, 0x41);
  printf("ECHO: Got 0x%02x\n", v.wait_output());
  v.mtick(20);

  printf("Set Address / Data\n");
  v.send_op(0x21, 0x3e);
  v.send_op(0x20, 0x56);
  v.send_op(0x50, 0xa1);
  v.send_op(0x51, 0xb2);
  v.mtick(20);

  printf("Write\n");
  v.send_op(0x73, 0x00);  // Write
  v.mtick(100);

  printf("Clear VDA / VDB registers.\n");
  v.send_op(0x50, 0x55);
  v.send_op(0x51, 0xaa);
  v.mtick(20);

  printf("Read\n");
  v.send_op(0x70, 0x00);  // Read
  v.mtick(100);

  printf("Get VDA / VDB\n");
  v.send_op(0xd0, 0x00);
  printf("VDA 0x%02x\n", v.wait_output());
  v.mtick(20);
  v.send_op(0xd1, 0x00);
  printf("VDB 0x%02x\n", v.wait_output());
  v.mtick(20);

  return 0;
}
