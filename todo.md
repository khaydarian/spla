# TODO

* pm: Organize TODO items better than this list.
* pm: Survey blog posts for forgotten TODO items.
* pm: Start a website?
* blog: Write export-to-website tool (or find static site generator).
* blog: Add photos and scope images.
* reference: Retrieve datasheets for all parts.
* reference: Reverify datasheets for gotcha details.
* schematic: Run through [schematic checklist](https://github.com/azonenberg/pcb-checklist/blob/master/schematic-checklist.md)
* pcb: Run through [PCB checklist](https://github.com/azonenberg/pcb-checklist/blob/master/layout-checklist.md)
* rtl: Build async fifo.
* rtl: Build plausible FTDI-fifo interface.
* rtl: Build stream merging protocol.
* rtl: Build opcode processor.
* rtl: Build bringup boundary-scan-like image? Possibly get a Lattice tool instead.
* software: Get rid of global-constant mess.
* software: Integrate or invent a decent unit testing framework.
* inventory: Write summary tool.
* inventory: Add borrowed scope.
* inventory: Note pre-existing tools (#1 screwdriver, label printer).

## Deferred

Things put off for now (possibly indefinitely).

* lab: Bodge wire to vblank / hblank, and measure analog voltage levels with scope.

## Dropped

Things that I'd planned to do, but decided to drop.

* schematic: Simulate opamp layouts in analog block.
  * They're simple enough (just voltage followers) that I'm not worried.
* schematic: Add 1-ohm 0.1% resistors in series with power rails, with test points for power measurement.
  * Decided not to bother; I don't care much about power usage (if it's not too large). I can also measure with a bench supply if I want to, which is likely more accurate anyways.
* schematic: Fix FPGA decoupling capacitors.
  * Infeasible because FPGA breakouts suck, and I don't have space.  Good enough for now.
* schematic: Review with Nate.
  * Infeasible; he's too busy at the moment.
* pcb: Shield VRAM data bus from power switching noise, if necessary?
  * It's probably not necessary.
