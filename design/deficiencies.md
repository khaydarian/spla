# Design Deficiencies

This current design has a number of known (hopefully inconsequential) deficiencies:

## USB 2.0 Full Speed Bandwidth

USB 2.0 Full Speed is 480 megabaud, or 60 MiBps at line rate.  Some of this is absorbed by protcol overhead, so I can expect to sustain at most about 40 MiBps average.  The `FT2232H` in async fifo mode can in theory sustain this, depending on the host controller.  Based on some back-of-the-envelope calculations (too crude to repeat here), this is definitely not enough for full data-rate on all the pins, and perahps not even enough for full-frame-rate 24-bit color frames.

I can mitigate this with some clever compression and filtering, and it's probably possible to runthe SNES chips as lower than the rated 27.7727 MHz clock rate.

Another option is to graduate to USB 3.0 with a more complex (and expensive) chip.

I've length-matched the USB traces, but I'm not sure I've done so correctly.

## Ignored pins

`PPU1.TST[012]` have unknown purpose, and aren't hooked up at all.

`PPU1.TST{12..15}` probably have more uses than just the 15-bit digital output, which I've ignored.

Most of the `74LVC8T245` level shifters don't have either their `OE` (output-enable) or `DIR` (direction) pins hooked up.  In most cases this doesn't matter, because the pins on the PPU / VRAM chips aren't bidirectional, and it's ok to be driving them all the time.  It's a bit clumsy though.

## Direction Control Granularity

Since the `74LVC8T245` can only control direction for all 8 channels at once, I've grouped the pins in the hopes that they'll have the same direction.  This is obviously ok for data and address buses, but there's lots of individual signals that I can't drive in separate directions.  Some groups of pins and explicitly one direction, which is a bit wasteful (but at least I only need the one kind of level shifter chip).

## Trace dimensions

Some of the traces are very long -- in particular, the VRAM data buses wrap all the way around the board. I'm not sure if this is a problem or not.

Also, the PPU chips (5V are mostly using 0.2mm traces, whereas the traces to FPGA (and elsewhere) are 0.1mm and thus higher resistance. This probably doesn't matter.

For the most part I've tried to avoid spacing traces at the minimum size: 3.5 mil, or slightly less than 0.1mm (I've set the limit at the latter).  There's a handful of places I'm stuck with it, and it's probably fine -- but those buses could couple together and cause signal integrity issues.  Probably that will only limit maximum speed, which shouldn't be a huge issue.

## PPU1 layout

The layout of the level shifters under the PPU1 chip is way tighter than necessary, and could be relaxed without causing issues.

## Power plane splits

The split between 5V and 3.3V sections of the power plan is ugly, because the level shifter chips are all over the place. Maybe this should be simplified, at the cost of some board space and increase trace stubs on the SNES buses.

## Dodgy Decoupling

I don't know if I've added enough / the right decopling capacitors; I've mostly followed the reference recommendataions.  In particular I've avoided putting in bulk decoupling, because I'm not sure if it's necessary.  I can bodge this in later if needed.

Many of the level shifter chips don't have a good place to put decoupling capacitors.  I might have enough bulk decoupling on the board that this isn't a huge problem, and I can add in a few optional ones to help.

I don't know if "distributed decoupling" is necessary, but it's cheap enough to add the extra pads.

## Power layout

The power layout is perhaps entirely nonsense and I've no idea if it'll work.  I ought to prototype this on a separate PCB and find out -- perhaps even design one that fits into the power jumper bank I have now.

There's (small) ground loops in the power layout, whch is maybe bad. The PCB layout recommends a "guard trace" which I don't know how to do correctly.

## Analog

The entire analog setup (ADCs + opamps) is based on my very limited understanding of analog electronics, so I might have done any number of things wrong and not realized so.  It's possibly fixable by replacing some passives with other values, but there's no guarantee.

The analog traces from the PPU2 outputs are pretty long (5-7cm), which could be problematic.  I don't have a good feel for whether this is problematic.
