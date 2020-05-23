# Mistakes

## Separating Breakaway Headers is a Ballistic Hazard

Breakaway headers breakaway quite vigorously; I've probably lost some pins and
bits of plastic somewhere. Two-wide headers are even harder to separate, and I
keep busting a pair of pins trying. Fortunately they're cheap.

## FTDI Chip Layout was Bogus

I didn't fully understand what I was doing at the time, so there's some annoying limitations in the FTDI chip layout:

* The USB shield should not be grounded; this makes the host PC unable to recognize the USB device. I can workaround by severing the shield on a cable, but that's super dodgy.

* `INIT` LED has an accidental voltage divider, because I set up the LED the wrong way around (it's normally high, pulled low when needed).

* Lots of pads are inconvenient to sample with the scope.

## "Progressive Bringup" is a Stupid Idea

The whole idea I had here was to solder on parts of the board one step at a time, testing as I go. This is reasonable from an amateur perspective, but problematic in practice with small-pitch parts. In particular:

## Hand-soldering 0.5mm Pin Pitch Parts is Really Hard

0.5mm pin pitch is small enough that you can't (quite) fit soldermask in between the pins. This makes them prone to briding, and the pins are small enough that it's hard to clear the bridges.

It's hard to get the right amount of solder paste on the board without a stencil -- and with a stencil, you pretty much have to install and solder the entire board at once.

## Vaporized Isoproypl Alcohol Sets Off Smoke Detectors Instantly

Yeah, so that happened: I need to wait for the board to cool before trying to clean up flux residue. Flash-boiling isopropyl sets off the smoke detectors, which then set off the dog. Derp.
