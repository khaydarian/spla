# Notes from Design Review

On schematic / pcb revision 8:

## `LMH6611` Common Mode Voltage Range

@rrrabarbaro

The `LMH6611` claims to only support a input (common mode) voltage range up to
"1.8V max" &mdash; but it's not entirely clear if this is so -- the graphs on
page 21 appear to show a larger voltage range.  Possibly this is a problem, but
I can fix it by rescaling the various bias resistors to move the analog input
range around.

Status: Not sure if necessary.

## JLCPCB trace-to-via minimum

Kor

JLCPCB's capabilities say the track-to-via minimum is 5 mil, or 1.27mm.  The current layout has a few places that are just barely under the limit, which needs fixing.

Status: Fixed in some potentially-problematic places.  Boards were manufacturing without issue.

## 5V Power Plane

@rrrabarbaro

5V power plane attaches to the source right at a PPU, which might cause excessive ripple.  Move this away from the chips, and add decoupling capacitors.

Status: Fixed.

## Decoupling

@rrrabarbaro

Check Lattice's recommendations for decoupling capacitors on the FPGA, and add them.

Status: Fixed.

## Adjacent Pads

@rrrabarbaro

Avoid connecting adjacent pads by the long edges. historically this causes problems with etch traps, but that might not be important with modern processes.

Status: Fixed.

## ADC Clock

@rrrabarbaro

Generally for best performance the ADC clock needs to be very clean.  Driving this from the FPGA won't provide a very clean clock, re-driving for each ADC would be better.  Perhaps a star topology is ok.

Status: Probably skip; I don't need very great ADC performance.

## FPGA startup

Programming input pins ought to have a pull-up/pull-down resistors, in case the `FT2232H` sets the B bus to high impedence when A bus is in sync fifo mode.  The datasheet isn't specific about this detail.

There should be LEDs on the various important FPGA programming pins (`DONE`, `INIT`, `PROGRAM`);

Status: Done.  LEDs are still dodgy, because (I think) the FPGA pins can't drive enough current.

## `FT2232H` layout

Some of the layout around the `FT2232H` is odd because I originally had the `EP` footprint, with a large ground pad.  THis should be cleaned up.o

Also, the `+1V8` rail out to have a convenient test point, for bringup use.  Decoupling capacity (`C7`) should be near the source of this power (pin 49).

Status: Fixed.

## Ground loops

The 5V rail goes a long way around the edge of the board, but the ground return path is direct.  This might create a small magnetic field going through the middle of the board, which might be bad.

Status: Probably ignore, since I'm not sure if this is a real problem.

## Physical connectors

USB Micro adapter and 12V Barrel jack might not match reasonable actual parts; need to choose those parts and update the layout to match.

Status: These match exactly, thanks to KiCad symbols.
