include Makefile.toolchain

ALL += build/bringup_sensor.trace.vcd
ALL += build/bringup_scanner.trace.vcd
ALL += build/uart_rx.trace.vcd
ALL += build/vram_control.trace.vcd
ALL += build/fifo_testbench.vcd
ALL += build/ppu_interrupt_testbench.vcd
ALL += build/ppu_clock_testbench.vcd

.PHONY: all
all: $(ALL)

.SUFFIXES:

.PHONY: clean
clean:
	rm -rf build

RTLDIR:=../rtl/lib

build/obj_dir/Vbringup_sensor.cpp: | build/
build/obj_dir/Vbringup_scanner.cpp: | build/
build/obj_dir/Vuart_rx.cpp: | build/

build/:
	mkdir -p $@

# Simulation with Verilator

build/obj_dir/Vbringup_sensor.cpp: $(RTLDIR)/bringup_sensor.v
	(cd build && $(VERILATOR) --trace -Wall -I.. -cc ../$<)

build/obj_dir/Vbringup_sensor__ALL.a: build/obj_dir/Vbringup_sensor.cpp
	make --no-print-directory -C build/obj_dir -f Vbringup_sensor.mk

build/bringup_sensor: bringup_sensor.cpp build/obj_dir/Vbringup_sensor__ALL.a
	$(CC) $(CC_FLAGS) -I$(VERILATOR_INCLUDE) -I build/obj_dir \
		$(VERILATOR_INCLUDE)/verilated.cpp \
		$(VERILATOR_INCLUDE)/verilated_vcd_c.cpp \
		-o $@ $^

build/bringup_sensor.trace.vcd: build/bringup_sensor
	(cd build && ./bringup_sensor)

build/bringup_scanner.concat.v: $(RTLDIR)/pindef.v $(RTLDIR)/bringup_scanner.v
	cat $^ >$@

build/obj_dir/Vbringup_scanner.cpp: build/bringup_scanner.concat.v
	(cd build && $(VERILATOR) --trace -Wall -I.. -cc ../$<)

build/obj_dir/Vbringup_scanner__ALL.a: build/obj_dir/Vbringup_scanner.cpp
	make --no-print-directory -C build/obj_dir -f Vbringup_scanner.mk

build/bringup_scanner: bringup_scanner.cpp build/obj_dir/Vbringup_scanner__ALL.a
	$(CC) $(CC_FLAGS) -I$(VERILATOR_INCLUDE) -I build/obj_dir \
		$(VERILATOR_INCLUDE)/verilated.cpp \
		$(VERILATOR_INCLUDE)/verilated_vcd_c.cpp \
		-o $@ $^

build/bringup_scanner.trace.vcd: build/bringup_scanner
	(cd build && ./bringup_scanner)

build/uart_rx.concat.v: $(RTLDIR)/uart_rx.v $(RTLDIR)/sync2ff.v
	(echo "/* verilator lint_off DECLFILENAME */"; cat $^) >$@

build/obj_dir/Vuart_rx.cpp: build/uart_rx.concat.v
	(cd build && $(VERILATOR) --trace -Wall -I.. -cc ../$<)

build/obj_dir/Vuart_rx__ALL.a: build/obj_dir/Vuart_rx.cpp
	make --no-print-directory -C build/obj_dir -f Vuart_rx.mk

build/uart_rx: uart_rx.cpp build/obj_dir/Vuart_rx__ALL.a
	$(CC) $(CC_FLAGS) -I$(VERILATOR_INCLUDE) -I build/obj_dir \
		$(VERILATOR_INCLUDE)/verilated.cpp \
		$(VERILATOR_INCLUDE)/verilated_vcd_c.cpp \
		-o $@ $^

build/uart_rx.trace.vcd: build/uart_rx
	(cd build && ./uart_rx)

build/vram_control.concat.v: $(RTLDIR)/constants.v $(RTLDIR)/vram_control.v
	(echo "/* verilator lint_off DECLFILENAME */"; cat $^) >$@

build/obj_dir/Vvram_control.cpp: build/vram_control.concat.v
	(cd build && $(VERILATOR) --trace -Wall -I.. -cc ../$<)

build/obj_dir/Vvram_control__ALL.a: build/obj_dir/Vvram_control.cpp
	make --no-print-directory -C build/obj_dir -f Vvram_control.mk

build/vram_control: vram_control.cpp build/obj_dir/Vvram_control__ALL.a
	$(CC) $(CC_FLAGS) -I$(VERILATOR_INCLUDE) -I build/obj_dir \
		$(VERILATOR_INCLUDE)/verilated.cpp \
		$(VERILATOR_INCLUDE)/verilated_vcd_c.cpp \
		-o $@ $^

build/vram_control.trace.vcd: build/vram_control
	(cd build && ./vram_control)

build/fifo_testbench.vvp: | build/
build/fifo_testbench.vvp: fifo_testbench.v ../rtl/lib/fifo.v
	$(IVERILOG_COMPILE) $^ -o $@

build/fifo_testbench.vcd: build/fifo_testbench.vvp
	(cd build/ && $(IVERLOG_SIMULATE) ../$<)

build/ppu_interrupt_testbench.vvp: | build/
build/ppu_interrupt_testbench.vvp: ppu_interrupt_testbench.v ../rtl/lib/ppu_interrupt.v
	$(IVERILOG_COMPILE) $^ -o $@

build/ppu_interrupt_testbench.vcd: build/ppu_interrupt_testbench.vvp
	(cd build/ && $(IVERLOG_SIMULATE) ../$<)

build/ppu_clock_testbench.vvp: | build/
build/ppu_clock_testbench.vvp: ppu_clock_testbench.v ../rtl/lib/ppu_clock.v
	$(IVERILOG_COMPILE) $^ -o $@

build/ppu_clock_testbench.vcd: build/ppu_clock_testbench.vvp
	(cd build/ && $(IVERLOG_SIMULATE) ../$<)
