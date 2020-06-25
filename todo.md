# TODO

* pm: Organize TODO items better than this list.
* pm: Survey blog posts for forgotten TODO items.
* pm: Start a website?
* blog: Write export-to-website tool (or find static site generator).
* blog: Add photos and scope images.
* reference: Retrieve datasheets for all parts.
* rtl: Build async fifo module.
* rtl: Build plausible FTDI-fifo-interface module.
* rtl: Design stream merging protocol.
* rtl: Build stream merging protocol module.
* rtl: Build opcode processor.
* software: Get rid of global-constant mess.
* software: Fix device enumeration logic, and `ftdi_list_devices`.
* software: Fixup `ftdi_test_raw` to handle mpsse modes better (labelled pins, individual changes, etc).
* software: Add pin numbers/names to `bringup_ftdi`.
* software: Fix MPSSE hi/lo flushing to be less touchy.
* software: Integrate or invent a decent unit testing framework.
* inventory: Write summary tool.
* inventory: Write inventory-to-BoM comparison tool.
* inventory: Add borrowed scope.
* inventory: Note pre-existing tools (#1 screwdriver, label printer).

## Next Schematic / PCB revision

* Consider ENIG finish, which makes the BGA easier to install.
* Omit large areas of silkscreen, which are awkward to print and can have lower quality.
* Consider the "paper between boards" option, which would avoid some silkscreen scratches.
* Consider ordering stencils.
* Review the back-side silkscreen more carefully; there's several references clumsily placed (`U32`, `C10`, etc).
* Compact the board, since there's quite a bit of unnecessary empty space.
* Consider adding an alternate clock source for the FPGA.
* Consider adding an easier test pad for the oscillator.
* Move `J5` and `J6` further away from each other.
* Maybe add `VCC` and `GND` to JTAG connector.
* Fix `J3` pin 3 layout, which has a weird connection.
* `U32` has pads connected on the long side, which it should not.
* Don't ground the USB shield; it's grounded on the host side and might introduce noise.
* Bring FTDI 1.8V regulator lines through a 0-ohm resistor, so I have the option of re-wiring easily.  Alternately, add pads for an optional 1.8V LDO.
* Add test point for FTDI 1.8V regulator.
* Add explicit jumper / button for FTDI reset.
* Add physical power switch (toggle).
* Add an easier test point for the 12MHz oscillator.
* Replace 12k 5% resistor (FTDI `REF`) with 12k 1%.
* Add SMD test clips for scope ground.
* Reverse `D6` (`INIT`) LED direction (net is pulled the opposite way).
* Avoid inverted LEDs, which is confusing (and we don't care about the power draw).
* Consolidate BoM part selections.
* Consider adjusting 3.3V and 5V regulators to be up a notch (sligtly below spec, probably due to overly-idealistic calculations).
* Drive all LEDs with high-impedence input things (transistors) to avoid biasing the signals I'm trying to sample.
* Replace `TP7` / `TP8` / `TP9` pads with pins, which are larger but easier to work with.

## Deferred

Things put off for now (possibly indefinitely).

* lab: Bodge wire to vblank / hblank on real SNES, and measure analog voltage levels with scope.

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
* reference: Reverify datasheets for gotcha details.
  * Laziness.
* schematic: Run through [schematic checklist](https://github.com/azonenberg/pcb-checklist/blob/master/schematic-checklist.md)
  * Laziness.
* pcb: Run through [PCB checklist](https://github.com/azonenberg/pcb-checklist/blob/master/layout-checklist.md)
  * Laziness.
