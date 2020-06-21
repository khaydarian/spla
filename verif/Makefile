include Makefile.toolchain

TOP := bringup_sensor

all: verilator

.SUFFIXES:

.PHONY: clean
clean:
	rm -rf build

RTLDIR:=../rtl/lib

build/obj_dir/V$(TOP).cpp: | build/

build/:
	mkdir -p $@

# Simulation with Verilator

build/obj_dir/V$(TOP).cpp: $(RTLDIR)/$(TOP).v
	(cd build && $(VERILATOR) --trace -Wall -I.. -cc ../$<)

build/obj_dir/V$(TOP)__ALL.a: build/obj_dir/V$(TOP).cpp
	make --no-print-directory -C build/obj_dir -f V$(TOP).mk

build/$(TOP): $(TOP).cpp build/obj_dir/V$(TOP)__ALL.a
	$(CC) $(CC_FLAGS) -I$(VERILATOR_INCLUDE) -I build/obj_dir \
		$(VERILATOR_INCLUDE)/verilated.cpp \
		$(VERILATOR_INCLUDE)/verilated_vcd_c.cpp \
		-o $@ $^

build/$(TOP).trace.vcd: build/$(TOP)
	(cd build && ./$(TOP))

verilator: build/$(TOP).trace.vcd
