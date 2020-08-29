# TODO

* pm: Organize TODO items better than this list.
* pm: Survey blog posts for forgotten TODO items.
* pm: Start a website?
* blog: Write export-to-website tool (or find static site generator).
* blog: Add photos and scope images.
* reference: Retrieve datasheets for all parts.
* rtl: Build netlist-to-lpf extraction script.
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
* Consider the "paper between boards" option, which would avoid some silkscreen scratches.
* Consider ordering stencils.
* Remove `LVL_PA_DIR`, which is probably unnecessary.
* Move `FIFO_SIWU` to the correct pin (pin 30 `ACBUS4`, not pin 34 `ACBUS7`).
* Fix adjacent pins bridged on `U20`.

### Skipped ideas

* Consider adding an alternate clock source for the FPGA.
  * Not necessary at this point, I think -- 12MHz and FTDI's 60MHz should be sufficient.
* Compact the board, since there's quite a bit of unnecessary empty space.
  * This is only partially possible (pulled in left edge by 13mm), and not worth the cost savings.
* Consider adjusting 3.3V and 5V regulators to be up a notch (sligtly below spec, probably due to overly-idealistic calculations).
  * No, it's within spec for the 1% resistors.  Doesn't matter.
* Remove JTAG connector, or reduce its footprint.
  * No compelling reason to do so -- I don't need it, but it's not a space issue.
* Consider if I can have the spare pins to double-duty as both LED outputs and test-point inputs.
  * Not worth the trouble.

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
