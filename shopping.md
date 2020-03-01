Basic lab equipment:
*   Soldering station, with digital temperature control and fine-point tips.
    *   Hakko FX888D
*   Also a "well" style tip, for drag soldering.
*   Solder fume handling thing (either vent outdoors, or filtering).
*   Hot-air station.
    *   Quick 861DW
*   Board preheater (maybe?)
*   Digital oscilloscope (if not borrowing from Kor).
*   Cheap multimeter.  Really only need this for connectivity testing etc.
    *   If doing manual BGA reflow: K-type themocouple probe for it.
*   Magnifying work light, on an arm.
*   Some kind of antistatic, thermal-protective surface for the table.
*   Antistatic wrap strap.
*   Electronics tweezers.
*   Handy-hand grabber thingys, or something to hold stuff while I work.
*   Optional: Trinocular electronics microscope?  Not sure if needed yet; might
    be able to get a chip USB one.

Lab supplies:
*   Solder (leaded), fine <0.5mm.
*   Solder wick braid (two sizes).
*   Flux pen.
*   Captan tape (or something similar).
*   Bodge wires (which might be small) -- 30 AWG wire wrapping wire

Final board parts:
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
