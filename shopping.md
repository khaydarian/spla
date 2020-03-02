Basic lab equipment:
*   A "well" style tip, for drag soldering.
*   Hot-air station: Quick 861DW
*   Board preheater / hot plate
*   Digital oscilloscope (if not borrowing from Kor).
*   Magnifying work light, on an arm.
*   Antistatic wrap strap.
*   Handy-hand grabber thingys, or something to hold stuff while I work.
*   Optional: Trinocular electronics microscope?  Not sure if needed yet; might
    be able to get a chip USB one.

Lab supplies:
*   ...

Final board parts (pending actual BoM):
*   2 or more used SNES from E-Bay (one to cannablize, and one to hook up to a
    scope for comparison).
*   PCB (likely from JLPCB), possibly with small parts pre-installed.
*   Some FPGA of reasonable size and packaging (ICE40 HX or ECP), and
    supporting chips:
    *   Big EEPROM, for holding FPGA bitstream.
*   Some USB interface chip (probably FT2232HL), and supporting chips:
    *   Some CMOS oscillator (likely 12 MHz).
    *   Small EEPROM, as recommended by FTDI datasheet.
*   Voltage regulator chips, probably LDO 5V to 3.3V / 1.8V / 1.2V.
    *   5V from USB directly, with decoupling capacitors
    *   3.3V to drive FTDI and FPGA
    *   1.8V for FTDI internal core.
    *   1.2V for FPGA I think.
*   Some voltage shifter stuff.  Not sure about this yet.
*   3x Analog ADC chips, for video rate (>3.5Msamp). Maybe an extra for
    colorburst / csync.
*   Micro USB connector.
*   Lots of surface-mount passives (resistors / capacitors / inductors?).
*   Bunch of surface-mount LEDs.
*   Bunch of 0.1-pitch headers and jumpers.
*   Standoffs and feet for the board.
