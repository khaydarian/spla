include Makefile.toolchain

# Omit all default pattern rules.
.SUFFIXES:

ALL += build/bringup.bit
ALL += build/bringup_uart.bit
ALL += build/bringup_fifo.bit
ALL += build/bringup_boundary.bit
ALL += build/bringup_levelshifter1.bit
ALL += build/bringup_levelshifter2.bit

# By default, build all bitstreams.
.PHONY: all
all: $(ALL)

# All build artifacts are put in build/
.PHONY: clean
clean:
	rm -rf build/

# Always create the build directory first.
$(patsubst %.bit,%.json,$(ALL)): | build/

build/:
	mkdir -p $@

# Synthesis with Yosys / NextPNR
build/bringup.json: $(shell cat bringup.vf)
	$(YOSYS) -v2 -p 'synth_ecp5 -abc2 -top bringup -json $@' $^
build/bringup_uart.json: $(shell cat bringup_uart.vf)
	$(YOSYS) -v2 -p 'synth_ecp5 -abc2 -top bringup_uart -json $@' $^
build/bringup_fifo.json: $(shell cat bringup_fifo.vf)
	$(YOSYS) -v2 -p 'synth_ecp5 -abc2 -top bringup_fifo -json $@' $^
build/bringup_boundary.json: $(shell cat bringup_boundary.vf)
	$(YOSYS) -v2 -p 'synth_ecp5 -abc2 -top bringup_boundary -json $@' $^
build/bringup_levelshifter1.json: $(shell cat bringup_levelshifter1.vf)
	$(YOSYS) -v2 -p 'synth_ecp5 -abc2 -top bringup_levelshifter1 -json $@' $^
build/bringup_levelshifter2.json: $(shell cat bringup_levelshifter2.vf)
	$(YOSYS) -v2 -p 'synth_ecp5 -abc2 -top bringup_levelshifter2 -json $@' $^

%.config: %.json
	$(NEXTPNR) $(NEXTPNR_FLAGS) --json $< --textcfg $@ --lpf default.lpf -l $(patsubst %.config,%.log,$@)

%.bit: %.config
	$(ECPPACK) $< --compress --bit $@
