# Mistakes

## Separating breakaway headers is a ballistic hazard

Breakaway headers breakaway quite vigorously; I've probably lost some pins and
bits of plastic somewhere.  Two-wide headers are even harder to separate.

## FTDI Chip Layout was Bogus

I didn't fully understand what I was doing at the time, so there's some annoying limitations in the FTDI chip layout:

* `INIT` LED has an accidental voltage divider, because I set up the LED the wrong way around (it's normally high, pulled low when needed).

## "Progressive Bringup" is a Stupid Idea

The whole idea I had here was to solder on parts of the board one step at a time, testing as I go.  This is reasonable from an amateur perspective, but problematic in practice with small-pitch parts.  In particular:

## Hand-soldering 0.5mm pin pitch parts is Really Hard

0.5mm pin pitch is small enough that you can't (quite) fit soldermask in between the pins.  This makes them prone to briding, and the pins are small enough that it's hard to clear the bridges.

It's hard to get the right amount of solder paste on the board without a stencil -- and with a stencil, you pretty much have to install and solder the entire board at once.

## Vaporized isoproypl alcohol sets off smoke detectors

Yeah, so that happened: I need to wait for the board to cool before trying to clean up flux residue. Derp.
