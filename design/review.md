# Notes from Design Review

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

Status: Pending.

## 5V Power Plane

@rrrabarbaro

5V power plane attaches to the source right at a PPU, which might cause excessive ripple.  Move this away from the chips, and add decoupling capacitors.

Status: Pending.

## Decoupling

@rrrabarbaro

Check Lattice's recommendations for decoupling capacitors on the FPGA, and add them.

Status: Pending.

## Adjacent Pads

@rrrabarbaro

Avoid connecting adjacent pads by the long edges. historically this causes problems with etch traps, but that might not be important with modern processes.

Status: Pending.

## ADC Clock

@rrrabarbaro

Generally for best performance the ADC clock needs to be very clean.  Driving this from the FPGA won't provide a very clean clock, re-driving for each ADC would be better.  Perhaps a star topology is ok.

Status: Probably skip; I don't need very great ADC performance.
