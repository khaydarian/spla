include Makefile.toolchain

# Omit all default pattern rules.
.SUFFIXES:

# By default, build all bitstreams.
.PHONY: all
all: build/bringup_blinky.bit

# All build artifacts are put in build/
.PHONY: clean
clean:
	rm -rf build/

build/bringup_blinky.json: | build/

build/:
	mkdir -p $@

# Synthesis with Yosys / NextPNR
build/bringup_blinky.json: constants.v bringup_blinky.v lib/fifo_dummy.v lib/bbus_dummy.v lib/vram_dummy.v lib/misc_default.v lib/analog_dummy.v
	$(YOSYS) -v2 -p 'synth_ecp5 -abc2 -top bringup_blinky -json $@' $^

%.config: %.json
	$(NEXTPNR) $(NEXTPNR_FLAGS) --json $< --textcfg $@ --lpf default.lpf

%.bit: %.config
	$(ECPPACK) $< --bit $@
