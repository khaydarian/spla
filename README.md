SPLA is a Super Nintendo PPU Logic Analyzer, a breakout board design and
software to fully reverse-engineer the Super Nintendo PPU chips, which are
controlled by the CPU and generate the image you see on your TV.

Current status:

* Design stabilized, 80% complete, with some open questions.
  * Power regulation is wrong and needs rework.
  * Analog ADC layout needs adjustment to handle 2V peak-to-peak limitations.
* Schematic 80% complete, pending above design changes and FPGA pinmapping.
* Early PCB layout experiments in progress.
* Software: Minimally started.
* Manufacturing: Not started.

Design components:

* USB interface to a host PC with an FTDI `FT2232H` chip, which can drive up to
  60MBps (USB 2.0 "Full Speed" maximum throughput).
* A Lattice `ECP5` FPGA, which forms the central brains of the board.
* Both SNES `PPU` chips, and their corresponding video SRAM chips.
* Three `ADS9280` high-speed analog-to-digital video capture chips, to capture
  the analog RGB signal output and convert it back to digital for analysis.

## References

* [Original post that inspired this project](https://byuu.org/articles/edge-of-emulation)
* [Ars Technica Article](https://arstechnica.com/gaming/2020/04/how-snes-emulators-got-a-few-pixels-from-complete-perfection/)
