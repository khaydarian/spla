# Objective

Build a board that can push signals through the PPU1 and PPU2 chips, with
corresponding external VRAM chips, which can communicate with host software on
a PC and log the values of each of the data buses during every cycle of
operation, feeding the results back to the PC.

In more detail: Connect the two PPU chips and tap all the important pins,
sample the results with a high-speed FPGA and dump the results temporarily into nearby ram, and later into the PC.  Traces might be very big.

Both PPU chips have ~100 pins in use, which is a lot.  We might need multiple
FPGAs running in lockstep to collect the data at full speed.  If we don't have
to run fast, this is way easier -- add a few hardware muxes and we can rotate
around the pins.

# Open Questions

* Do we need to go at full speed (~21MHz)? How fast do we need to go?  Do we have to drive at full speed (dynamic NMOS or something), or can we go slowly?

* Do we need direct write access to VRAM chips, or can we just use the PPU1 to do that?

* What chips go on the board?
  * What FPGA(s?) should we use?
    * That I can actually install.

* How many signals do we need?
  * 100 per chip, but ~20-30 are shared between them.

* Can we have the FPGA emulate the VRAM chips as well?
  * Might be handy, if we have the space.
  * If we can go slow, this is feasible with some minor helper chips (shift register or similar)

* What's the format of the signals on R/G/B output lines?

* Can I solder this myself, or does it need professional manufacturing?
  * Practical limit is TQFP or similar (which PPU chips are, I think)
  * BGAs are right out

# Closed Questions
* What are the VRAM chips?  Can I buy them?
  * Bog-standard SRAM chips; 2x 32Kx.
  * Maybe can just buy them, easy to emulate in FPGA (if enough space).

# Design Process

* Collect design-relevant information (data sheets, schematics, etc).
* Figure out bill-of-materials, tuning for something I can physically build.
* Write some proof-of-concept FPGA-styled verilog.
* Figure out what (physical) tools I need.
* Talk to Kor/Chris about this nonsense.
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


