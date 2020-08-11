# Part Selection

Choosing parts is a nontrivally-diffcult task. This page documents why I've chosen the parts in the current design.

Generally speaking, I'm selecting for parts that I can most easily get working, and specifically not the cheapest available. I'm not planning to build more than a handful of boards, so having them be a few dollars more expensive is acceptable.

## USB Interface: `FT2232H`

I'm familiar with FTDI chips, so I didn't put a lot of effort into this choice. The `FT2232H` in particular has a synchronous FIFO mode which can reach the theoretical maximum throughput (60MBps), although other similar chips (`FT4232H`, in particular) don't have this mode.

If this isn't enough bandwidth, the `FT600` / `FT601` are comparable USB 3.0 chips, which have a 16-bit or 32-bit FIFO interface. However, they don't have as many GPIO pins, which I'm using to upload the FPGA image (rather than programming a SPI chip every time).

## FPGA: Lattice ECP5 `LFE5U-45F-6BG256`

First and foremost, I want to use the open-source FPGA toolchains (specifically yosys), which sharply limits the FPGA possibilities. The only supported ones I know of are the Lattice HX family (via Project IceStorm) and the Lattice `ECP5` family (via Project Trellis).

Almost all FPGAs come in BGA packages, which is tricky to hand-solder -- but there's no good way around that. I want the largest pitch, smallest package I thought I could get away with, given the number of IOs I need: ~190, counting both the SNES signals and the `FT2232H` connection.

The HX family is mostly small ball-pitch parts (0.35mm, 0.4mm, 0.5mm), which is probably infeasibly small to do by hand. The 0.8mm varieties are only the `HX8K`: 121-ball caBGA (9x9mm) with 95 IO, and 256-ball 16x16 caBGA with 208 IO. 95 IOs isn't likely enough, leaving only the `HX8K` caBGA-256. However, the `HX8K` only has 7680 logic cells, and 128Kbits of embedded ram, and 2 PLLs. This might be too cramped to get any clever logic involved, and there's very little space to buffer data.

THe `ECP5` family, in 0.8mm ball pitch, has 256-, 381-, 554-, and 756-ball parts. (They don't have any with SERDES block in this size, but I don't need them.)  Sticking with 256-ball (197 IOs), I can get:

* `LFE5U-12`: 12K LUTs, 32x 18Kbits block ram, 576 Kbits embedded ram, 97 Kbits distributed ram
* `LFE5U-25`: 24K LUTs, 56x 18Kbits block ram, 1008 Kbits embedded ram, 194 Kbits distributed ram
* `LFE5U-45`: 44K LUTs, 108x 18Kbits block ram, 1944 Kbits embedded ram, 351 Kbits distributed ram

Choosing the biggest one here (to give myself as much headroom as possible), leaves the `LFE5U-45F-6BG256`.

## Power: `ST1S10`, `TLV733P`

I went through several iterations of power regulator layout, and settled on a suggestion of Nate's for the `ST1S10` for the 3.3V and 5V power domains, which both have the highest power requirements. A switching regulator is complicated (need a bunch of passives and an inductor), but fairly unavoidable, as simpler LDOs generally will dissspate too much heat on their own. For comparison, the actual SNES uses a single `17805` regulator to drop from 10V input to 5V supply -- and it gets hot enough to need a heatsink.  Switching regulators will have more noise, but can sustain a lot more current (multiple amps).

For the FPGA's 1.1V and 2.5V domains, I've picked a fairly simple LDO regulator, the `TLV733P`. This has fixed output (`TLV73311P` for 1.1V, `TLV73325P` for 2.5V), which is fine for my use. This only sustains ~300mA of current, which is probably enough. I've no idea if the thermal dissapation for the LDOs if a problem, but I've hedged against it by adding separate power pins.

I've also added a seperate `TLV73333P` for the analog block, as the ADC datasheet says not to use the same power domain as the digital chips. This might not be sufficient to isolate noise out of the circuit.

In retrospect it probably would be easier to buy a power regulator module to stack on top of the board, and not design it myself.  I don't know if I can easily get one with all the voltages I need, though (5V, 3.3V, 2.5V, 1.1V).

All of this I've set up so I can take the entire power setup out of circuit and run the board from a bench supply, if I have to.

## Level shifter: `74LVC8T245`

I'd originally tried the `TXS0108E`, but auto direction control could be problematic in several ways. Instead, I settled for the explicit direction control of the `74LVC8T245` -- although later on I ended up hard-wiring a lot of the direction control pins that I don't need. This isn't a very satisfying solution to interconverting 3.3V and 5V signals.

## ADC: `ADC1173`

The pixel clock for NTSC is ~5.38MHz (at least for the SNES), so I want at least a 15MHz sample rate to cover the interval. The output signal is only 5-bit, so I probably don't need more than 8-bit depth to recover the signal (and also ADCs get _enormously_ more expensive with higher bit depth). From some investigation, many high-speed ADC chips have a limited input signal range (max 2V, usually), so that's a limitation I'll just have to deal with. Searching Digikey for 8-bit dpeth, sampling rates between 15Msps and 30Msps (active, SMD, sort by price) drops to 15 parts, mostly variants of:

* `ADC1175`
* `ADC1173`
* `ADS9280`
* `MAX1192`
* Other chips that are faster / more expensive than necessary.

`MAX1192` is a strange dual input thing, which isn't useful to me since I need three inputs anyway, and bundling two together is possibly problematic. `ADC1175` is a faster (20Msps) and higher-power version of `ADC1173`, and has a bit less available stock.

I'd originally chosen the `ADS9280`, but I don't really need the other features it supports, and it's not very well stocked (~hundreds, rather than >10k), and it's twice as expensive as the `ADC1173`. As a nice bonus, the `ADC1173` datasheet has better application examples, including sample layouts driving the ADC with an op-amp.

Aside: There are video-capture chips, but they generally take analog composite input, and I don't want to deal with the artifacts and adding the `BA6592F` from the SNES on the board as well. I haven't looked into this very much.

## Opamp: `LMH6611`

Driving the ADC is tricky; most op-amps want a wide voltage range with negative supply. I found the `LMH6611` by accident in Kicad's part library, and it's a single-supply rail-to-rail-output opamp, with fast slew rate and high bandwidth (max 345MHz). This will probably work out ok. Also, the datasheet has good example applications, including (critically!) driving a single-ended ADC input. This happens to be using a slower ADC than mine, with a wide voltage input range, but it's a good example of how to set up an opamp in general.

I've also used the same opamp to drive and stabilize the input reference voltages, which might be overkill. At least I don't have to read an extra datasheet.

## Crystal oscillator: Fox Electronics `FOX924`

Arbitrary and cheap HCMOS osciallator.

## Passives

Resistors from Stackpole Electronics (arbitrary); Capacitors from Murata Electrons (arbitrary).  Mostly `0603` packages, which I can comfortably hand-solder; some `0402` capacitors for FPGA decoupling (spacing is tricky in the BGA).

Inductor is Vishay Dale `IHLP2020CZ` (arbitrary).

## LEDs

LEDs are all green, from Wuerth Electronik (cheap, and arbitrary).  All `0603` package.

## USB Micro-B Connector

Matches conveniently-available KiCad symbol, from Wuerth Electronik.

## 12V Barrel Jack

Matches conveniently-available KiCad symbol, from CUI Devices.

## Mechanical parts

All essentially arbitrary.

*   2.54mm Pin Headers (lots): single- and double-row, from Sullins Connector Solutions.
*   Jumpers, from Sullins Connector Solutions.
*   Standoff Hex Legs: from Wuerth Electronik.

### 12V Power Supply Brick

Arbitrary.  I'm mostly using my bench supply anyhow.

