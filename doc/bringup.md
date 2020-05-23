# Bringup sequence

_This sequence assumes a "Progressive Bringup", where each section of the board
is assembled and testing one at a time. This turns out to be a really stupid
idea. Don't do it this way._

Follow these steps to build a working SPLA board, starting from a bare board
and parts.  This is the most-paranoid bringup for the first board; many steps
can be skipped or merged once the board layout is proven.

1.  Visually inspect PCB.
    1.  Verify PCB revision.  These instructions are for `SPLA Breakout Board Rev 009`.
    1.  Inspect FPGA BGA area.
    1.  Inspect 'narrow' areas (ie, minimum-pitch traces).
    1.  Inspect via alignment.
    1.  Sand edges with fine-grit sandpaper (not necessary, but more professional).
    1.  Pre-clean PCB surface with isopropyl alcohol, if necessary.
    1.  Insert hex standoffs.
1.  Power validation.
    1.  Solder barrel jack: `J7`.
    1.  Solder power pinheaders: `J12` (2x8), `J4` (2x2).
    1.  Solder `ST1S10` regulators: `U7`, `U8`.
    1.  Solder inductors: `L1`, `L2`.
    1.  Solder LEDs: `D1`, `D2`
    1.  Solder power-related passives.
    1.  Configure test load: several 220-ohm resistor(s) on breadboard.
    1.  Connect test load to power pinheader.
    1.  Connect 12V lab supply with power adapter pigtail.  Limit current to 100 mA.
    1.  Verify that 5V and 3.3V LEDs are lit.
    1.  Verify that 5V regulator output is stable (via oscilloscope).
    1.  Verify that 3.3V regulator output is stable (via oscilloscope).
    1.  Disable 12V power.
    1.  Solder 2.5V and 1.1V LDOs `U9` and `U14`.
    1.  Solder 2.5V and 1.1V passives.
    1.  Connect jumpers on `J4`.
    1.  Enable 12V power.  Limit current to 100mA.
    1.  Verify that 2.5V LDO output is stable (with test load).
    1.  Verify that 1.1V LDO output is stable (with test load).
    1.  Remove 12V power.
    1.  Connect jumpers to enable power to the rest of the board.
1.  USB connection
    1.  Solder USB connector: `J1`
    1.  Solder JTAG pinheader: `J2`.
    1.  Solder `FT2232H` chip: `U2`.
    1.  Solder `93LC66B` EEPROM: `U3`.
    1.  Solder LEDs: `D3`, `D4`, `D5`, `D6`.
    1.  Solder front-side FTDI-related passives.
    1.  Switch to back of board.
    1.  Solder crystal oscillator: `X0` (reverse of board).
    1.  Solder back-side USB/FTDI-related passives.
    1.  Enable 12V power.
    1.  Verify oscillator output (frequency and voltage) on oscilloscope.
    1.  Verify connection to host via `lsusb`.
    1.  Verify connection to host with `spla` command.
    1.  Verify the absense of IO-pin solder bridges with `spla bringup_ftdi`.
    1.  Program the FTDI EEPROM with `spla ftdi_new_device`.  Select a serial number properly.
    1.  Power cycle the board to reset FTDI.
    1.  Verify that properly-configured FTDI comes up as expected on `lsusb`.
    1.  Verify that the FTDI comes up with the correct serial number with `spla ftdi_list_devices`.
    1.  (Optionally) Verify `ADBUS` and `BDBUS` connectivity via MPSSE GPIO interface, on oscillscope. *Need a tool for this.*
    1.  *Note: After this point, these instructions are a bit fuzzy.*
1.  FPGA
    1.  Solder FPGA to the board, using hot air rework station or reflow oven. *This might need to be done first, to avoid messing up other soldering on the board.*
    1.  Verify basic connectivity to FTDI `BDBUS` SPI pins, and get ECP5 SPI Slave interface working. *Need a tool for this.*
    1.  Load `bringup_blinky` FPGA image, and verify that sample LEDs blink. *Need to write this image.*
    1.  Load the bringup FPGA image. *Need to write this image.*
    1.  Use function generator (and/or crummy Arduino substitute) to drive each external pin one at a time, and verify connectivity and lack of bridges. *Need a tool for this.*
1.  Level Shifters
    1.  Solder all level shifter chips.
    1.  Reverify using bringup FPGA image.
    1.  Verify input and output voltages with multimeter (or scope).
1.  SNES chips
    1.  Verify correct video operation of a victim SNES.
    1.  Desolder `PPU-1`, `PPU-2`, and both VRAM chips from the SNES board.
    1.  Visually inspect salvaged chips for damage.
    1.  Solder salvaged VRAM chips to the board.
    1.  Solder any related passives to the board.
    1.  Verify connectivity between `PPU` pads and VRAM chips, via multimeter -- probing top of pins.
    1.  Verify VRAM read/write functionality via FPGA image. *Need to write this image.*
    1.  Solder `PPU-1` and `PPU-2`.
    1.  Verify connectivity between `PPU` pins (not pads) and VRAM chips, via multimeter.
    1.  Verify connectivity between `PPU-1` and `PPU-2` inter-PPU bus pins, via multimeter.
    1.  Verify connectivity between `PPU-1` and `PPU-2` peripheral bus pins, via multimeter.
    1.  Verify connectivity between `PPU-1` and `PPU-2` reset pins, via multimeter.
    1.  Verify connectivity between `PPU-1` and `PPU-2` `XIN` pin and pad, via multimeter.
    1.  Solder analog jumper headers.
    1.  Verify connectivity between `PPU-2` analog pins and analog headers.
    1.  Load PPU bringup FPGA image.  *Need to write this image.*
        1.  Connect reset passthrough jumper.
        1.  Drive 21.47727MHz clock signal to both PPU chips.
        1.  Release `PPU-2` from reset.
        1.  Scan for `HBLANK` and `VBLANK` signal.
        1.  Debug extensively.
1.  Analog chips
    1.  Verify analog outputs from `PPU-2` via oscilloscope.
    1.  Solder voltage bias resistors.
    1.  Verify voltage biasing via oscilloscope.
    1.  Solder amplifier Opamps, passives, and jumpers.
    1.  Solder analog power LDO.
    1.  Verify stability of analog power domain.
    1.  Verify value and stability of reference voltage levels.
    1.  Load FPGA image that drives a test vector into the PPU memory.  *Need to collect this test vector and write this image.*
    1.  Solder ADC chips.
    1.  Load FPGA image that drives a test vector and collects the results via USB.
    1.  Verify collected image correctness.
    1.  Debug extensively.
1.  Board bringup complete.
    1.  Proceed with software development; research-directed from this point.
