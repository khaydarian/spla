# Objective

Build a board that can push signals through the PPU1 and PPU2 chips, with
corresponding external VRAM chips, which can communicate with host software on
a PC and log the values of each of the data buses during every cycle of
operation, feeding the results back to the PC.

In more detail: Connect the two PPU chips and tap all the important pins,
sample the results with a high-speed FPGA and dump the results temporarily into
nearby ram, and later into the PC.  Traces might be very big.

Both PPU chips have ~100 pins in use, which is a lot.  We might need multiple
FPGAs running in lockstep to collect the data at full speed.  If we don't have
to run fast, this is way easier -- add a few hardware muxes and we can rotate
around the pins.

# Open Questions

*Not in this doc for now.*

# Closed Questions

* Do we need to go at full speed (~21MHz)? How fast do we need to go?  Do we have to drive at full speed (dynamic NMOS or something), or can we go slowly?
  * Probably we do need to run at full speed at least to start, but this is
    very achievable.  Collecting data at that rate is harder, though, so we
    might have to use USB superspeed, or stride and/or space out data
    retrievals, or else dump the whole data into an SRAM and upload slowly.

* Do we need direct write access to VRAM chips, or can we just use the PPU1 to do that?
  * Probably we don't, but we have to hook them up anyways -- doesn't cost any extra traces to do so.

* How many signals do we need?
  * 136 minimum, counting shared signals.

* Can we have the FPGA emulate the VRAM chips as well?
  * Maybe. The block ram is generally registered, so this will be at least one
    (core) clock cycle delayed.  The real SNES takes ~4-6 cycles for video
    access, so that might still be ok.  This also takes quite a lot of block ram
    which can make the FPGA more expensive.
  * It's possibly easier to take the VRAM chips from the actual board anyways.

* What's the format of the signals on R/G/B output lines?
  * Seems like 0V - 2.7V analog, which is too wide peak-to-peak for some ADC
    chips.  Still not fully characterized.

* Can I solder this myself, or does it need professional manufacturing?
  * Probably.  JLCPCB-SMT will do most of the tiny fiddly parts, and I can
    maybe (?) reflow a 0.8mm pitch BGA manually.  We'll see.

* What are the VRAM chips?  Can I buy them?
  * Bog-standard SRAM chips; 2x 32KB.  However, they're obsolete, so it might
    be hard to buy new ones that are compatible with the PPUs.

# Design Process

* Collect design-relevant information (data sheets, schematics, etc).
* Figure out bill-of-materials, tuning for something I can physically build.
* Write some proof-of-concept FPGA-styled verilog.
* Figure out what (physical) tools I need.
* Learn to solder properly.
* Figure out how to use kicad (schematics and PCBs).
* Find a source for PPU1/PPU2 chips (everything else is easy from digikey)
* Figure out a manufacturing test strategy (hard if you don't know what the chips do!)
* Find some test vectors that in principle ought to work.
* Manufacture:
  * Buy a whole bunch of stuff.
  * Order boards and chips.
  * Solder everything together.
  * Test hardware construction (scan-chain-like).

# References

Original thread: https://byuu.org/articles/edge-of-emulation
