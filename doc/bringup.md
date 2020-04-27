# Bringup sequence

This is the steps to build a working SPLA board, starting from a bare board and parts.

1.  Visually inspect PCB.
    1.  Remove all connecting jumpers.
    1.  Sand edges with fine-grit sandpaper (not necessary, but more professional).
    1.  Pre-clean PCB surface with isopropyl alcohol.
1.  Power validation.
    1.  Solder any power-related chips that aren't already present.
    1.  Solder power-related jumpers.
    1.  Verify that 12V input on barrel jack is stable (with test load).
    1.  Verify that 5V regulator output is stable (with test load).
    1.  Verify that 3.3V regulator output is stable (with test load).
    1.  Verify that 5V and 3.3V LEDs are lit.
    1.  Verify that 2.5V LDO output is stable (with test load).
    1.  Verify that 1.1V LDO output is stable (with test load).
    1.  Connect jumpers to enable power to the rest of the board.
1.  USB conenction
    1.  Solder USB connector, `FT2232H` chip, and `93LC66B` EEPROM.
    1.  Solder crystal oscillator.
    1.  Verify oscillator output (frequency and voltage) on oscilloscope.
    1.  Enable FTDI power.
    1.  Verify conenction to host (via `lsusb` at first).
    1.  Program the FTDI EEPROM with the correct settings. *Need a tool for this.*
    1.  Power cycle the board to reset FTDI.
    1.  Verify that FTDI comes up as expected on `lsusb`.
    1.  Verify `ADBUS` and `BDBUS` connectivity via MPSSE GPIO interface, on oscillscope. *Need a tool for this.*
    1.  Toggle the LED on `BDBUS`. *Need a tool for this.*
1.  FPGA
    1.  Solder FPGA to the board, using hot air rework station or reflow oven. *This might need to be done first, to avoid messing up other soldering on the board.*
    1.  Verify basic connectivity to FTDI `BDBUS` SPI pins, and get ECP5 SPI Slave interface working. *Need a tool for this.*
    1.  Load first-run FPGA image, and verify that sample LEDs blink. *Need to write this image.*
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
