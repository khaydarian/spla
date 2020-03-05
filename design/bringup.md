# Bringup sequence

This is the steps to build a working SPLA board, starting from part.

1.  Visually inspect PCB.
    1.  Remove all connecting jumpers.
    1.  Pre-clean PCB surface with isopropyl alcohol.
1.  Power validation.
    1.  Solder any power-related chips that aren't already present.
    1.  Solder power-related jumpers.
    1.  Verify that 5V input on barrel jack is stable (with test load).
    1.  Verify that 3.3V LDO output is stable (with test load).
    1.  Verify that 2.5V LDO output is stable (with test load).
    1.  Verify that 1.1V LDO output is stable (with test load).
    1.  Verify `MIX2025` power switch functionality -- jumper to high and low manually.
1.  USB conenction
    1.  Solder USB connector, `FT2232H` chip, and `93LC66B` EEPROM.
    1.  Solder FTDI oscillator (if needed).
    1.  Verify oscillator output (frequency and voltage) on oscilloscope.
    1.  Enable FTDI power.
    1.  Verify conenction to host (via `lsusb` at first).
    1.  Program the FTDI EEPROM with the correct settings. *Need a tool for this.*
    1.  Power cycle the board to reset FTDI.
    1.  Verify that FTDI comes up as expected on `lsusb`.
    1.  Verify `ADBUS` and `BDBUS` connectivity via MPSSE GPIO interface, on oscillscope. *Need a tool for this.*
1.  FPGA
    1.  Solder FPGA to the board, using hot air rework station or reflow oven.
    1.  Verify basic connectivity to FTDI `BDBUS` SPI pins, and get ECP5 SPI Slave interface working. *Need a tool for this.*
    1.  Load the bringup FPGA image.  *Need to write this image.*
    1.  Use function generator (and/or crummy Arduiono substitute) to drive each external pin one at a time, and verify connectivity and lack of bridges. *Need a tool for this.*
1.  Level Shifters
    1.  Solder any level shifters not already on the board.
    1.  Reverify using bringup FPGA image.
1.  SNES chips
    1.  Verify correct video operation of a victim SNES.
    1.  Desolder `PPU-1`, `PPU-2`, and both VRAM chips from the SNES board.
    1.  Visually inspect salvaged chips for damage.
    1.  Solder salvaged VRAM chips (possibly to carrier board instead of SPLA board directly).
    1.  Verify connectivity between `PPU` pads and VRAM chips, via multimeter -- probing top of pins.
    1.  Verify VRAM read/write functionality via FPGA image. *Need to write this image.*
    1.  Solder `PPU-1` and `PPU-1`.
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
    1.  Solder amplifier transistors, jumpers, and output RCA header jack.
    1.  Wire component cable into RCA header jack.
    1.  Load FPGA image that drives a test vector into the PPU memory.  *Need to collect this test vector and write this image.*
    1.  Connect RCA jacks to TV and verify image correctness.
    1.  Solder ADC chips.
    1.  Load FPGA image that drives a test vector and collects the results via USB.
    1.  Verify collected image correctness.
    1.  Debug extensively.
1.  Board bringup complete.
    1.  Proceed with software development; research-directed from this point.
