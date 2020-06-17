include Makefile.toolchain

# Omit all default pattern rules.
.SUFFIXES:

# By default, build all bitstreams.
.PHONY: all
all: build/bringup_blinky.bit build/bringup.bit

# All build artifacts are put in build/
.PHONY: clean
clean:
	rm -rf build/

build/bringup_blinky.json: | build/
build/bringup.json: | build/

build/:
	mkdir -p $@

# Synthesis with Yosys / NextPNR
build/bringup_blinky.json: $(shell cat bringup_blinky.vf)
	$(YOSYS) -v2 -p 'synth_ecp5 -abc2 -top bringup_blinky -json $@' $^

build/bringup.json: $(shell cat bringup.vf)
	$(YOSYS) -v2 -p 'synth_ecp5 -abc2 -top bringup -json $@' $^

%.config: %.json
	$(NEXTPNR) $(NEXTPNR_FLAGS) --json $< --textcfg $@ --lpf default.lpf -l $(patsubst %.config,%.log,$@)

%.bit: %.config
	$(ECPPACK) $< --bit $@
