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

## Respect the Datasheet Maximums

The ECP5 datasheet says that the maximum supported I/O volatage is 3.3V, and they mean it: while running `bringup_boundary`, I shorted the 3.3V driver pin with the 5V supply, and instantly fried the FPGA.  Oops.

## Respect the Datasheet Maximums, Part 2

Temperature also matters: on the second board, I foolishly left power on while trying to reflow the FPGA to fix a disconnected pin -- which is well above the maximum operating temperature.  Oops.  This seems to have fried the I/O drivers in some bizarre fashion.  I can still program the FPGA, but is has strange behavior and definitely isn't working right.

## Don't Double-Drive Nets

Nominally, double-driving a net is "bad", but in a fairly ill-defined fashion.  In my case, I didn't damage any of the chips, but it wastes a ton of power, and the resulting heating can damage the chips.  This normally wasn't enough to be a problem, but when I tried experimentally double-driving all the VRAM address pins (to confirm that that was the issue), power usage jumped from 1.5W to 11W, and the chip temperature went from 30C to 85C in three seconds -- and then I shut everything off.

## Timing Constraints Matter

I was getting all kinds of weird data problems when trying to drive the VRAM chips for the first time.  However, there's some setup-and-hold timing constraints that I hadn't considered, so just driving the control and data signals at the same time caused weird and nondeterministic results.

## Check for dumb typo errors

While getting `bringup_vram` working (after the above issues), I had a strange problem where reading `VDA` and `VDB` would always result in `0` for `VDA, and `VDA`'s value in `VDB`.  I'd first thought this was a byte getting inserted into the UART by a glitch in the RTL, and reworked the protocol to avoid sending two bytes at a time, which didn't fix it.  I then scrubbed the code for places where I might has swapped A and B, and there weren't any. After some painful hours, I tried sticking in an extra `reset()` call, and now the A and B values appeared in the right slots -- but there was an extra pair of zeros on the first call.  This looked for all the world like my A and B data was delayed by a clock, but that's not reasonable, since the second reads are a few hundred clocks later (latency of the UART).

Finally I belatedly noticed that my `reset()` method wasn't using `OPCODE_RESET`, but instead `OPCODE_ECHO`, which returns an extra byte, throwing off the protocol.  Facepalm.

## Measure The Chips

Once I'd gotten far enough through bringup to solder the PPU chips on the board, I discovered that I'd gotten the footprint wrong, and they don't fit.

Turns out the PPU chips have 0.65mm pin pitch, not 0.635mm (ie, 40 pins per inch), which makes sense because Nintendo is Japanese and of course uses metric.  Duh.

This is a deeply annoying mistake, and probably the worst on this list: It's a classic dumb mistake, which I knew about, and measured at least four times, and *still* got it wrong.  I even printed out a paper PCB layout to verify the footprints, but somehow didn't think to desolder the PPU chips and check them specifically, even though they're the most likely chip to get the footprint wrong, and it's obviously wrong at casual inspection.
