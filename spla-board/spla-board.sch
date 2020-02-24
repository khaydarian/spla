EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A3 16535 11693
encoding utf-8
Sheet 1 8
Title "SPLA Board - Root"
Date "2020-02-21"
Rev "3"
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Sheet
S 4500 4500 1500 1000
U 5E4F712F
F0 "SPLA Board - USB" 50
F1 "spla-board-usb.sch" 50
$EndSheet
$Sheet
S 7000 4500 1500 1000
U 5E4D8358
F0 "SPLA Board - FPGA" 50
F1 "spla-board-fpga.sch" 50
$EndSheet
$Sheet
S 9000 4500 1500 1000
U 5E50D400
F0 "SPLA Board - Level Shifters" 50
F1 "spla-board-level-shifters.sch" 50
$EndSheet
$Sheet
S 11000 4500 1500 1000
U 5E50E589
F0 "SPLA Board - PPU" 50
F1 "spla-board-ppu.sch" 50
$EndSheet
$Sheet
S 9000 6000 1500 1000
U 5E520B87
F0 "SPLA Board - Analog" 50
F1 "spla-board-analog.sch" 50
$EndSheet
$Sheet
S 6000 2500 1500 1000
U 5E50D39B
F0 "SPLA Board - Power" 50
F1 "spla-board-power.sch" 50
$EndSheet
$Sheet
S 5500 6500 1500 1000
U 5E50D3C6
F0 "SPLA Board - SRAM" 50
F1 "spla-board-sram.sch" 50
$EndSheet
Wire Notes Line width 12 style solid
	3000 5000 4500 5000
Text Notes 3350 4950 0    50   ~ 0
USB 2.0 High Speed
Wire Notes Line width 12 style solid
	6000 5000 7000 5000
Wire Notes Line width 12 style solid
	8500 5000 9000 5000
Wire Notes Line width 12 style solid
	10500 5000 11000 5000
Wire Notes Line width 12 style solid
	12000 5500 12000 6250
Wire Notes Line width 12 style solid
	12000 6250 10500 6250
Wire Notes Line width 12 style solid
	9000 6500 8100 6500
Wire Notes Line width 12 style solid
	8100 6500 8100 5500
Wire Notes Line width 12 style solid
	7000 5400 6700 5400
Wire Notes Line width 12 style solid
	6700 5400 6700 6500
Wire Notes Line width 12 style solid
	10500 6700 12000 6700
Text Notes 10950 6650 0    50   ~ 0
Component Out
Text Notes 6650 6200 1    50   ~ 0
32-bit R/W bus
Text Notes 6350 5100 0    50   ~ 0
60 MHz
Text Notes 8950 4950 2    50   ~ 0
(wide bus)
Text Notes 10950 4950 2    50   ~ 0
(wide bus)
Text Notes 11500 6200 2    50   ~ 0
Analog R/G/B
Text Notes 8900 6450 2    50   ~ 0
30-bit R/G/B bus
Wire Notes Line style solid
	7500 2700 7800 2700
Wire Notes Line style solid
	7800 2650 7800 2750
Wire Notes Line style solid
	7800 2750 7850 2700
Wire Notes Line style solid
	7800 2650 7850 2700
Wire Notes Line style solid
	7500 2900 7800 2900
Wire Notes Line style solid
	7800 2850 7800 2950
Wire Notes Line style solid
	7800 2950 7850 2900
Wire Notes Line style solid
	7800 2850 7850 2900
Wire Notes Line style solid
	7500 3100 7800 3100
Wire Notes Line style solid
	7800 3050 7800 3150
Wire Notes Line style solid
	7800 3150 7850 3100
Wire Notes Line style solid
	7800 3050 7850 3100
Text Notes 7600 2700 0    50   ~ 0
5V
Text Notes 7550 2900 0    50   ~ 0
3.3V
Text Notes 7550 3100 0    50   ~ 0
2.5V
Wire Notes Line style solid
	7500 3300 7800 3300
Wire Notes Line style solid
	7800 3250 7800 3350
Wire Notes Line style solid
	7800 3350 7850 3300
Wire Notes Line style solid
	7800 3250 7850 3300
Text Notes 7550 3300 0    50   ~ 0
1.1V
Wire Notes Line style solid
	5650 3000 5950 3000
Wire Notes Line style solid
	5950 2950 5950 3050
Wire Notes Line style solid
	5950 3050 6000 3000
Wire Notes Line style solid
	5950 2950 6000 3000
Text Notes 5750 3000 0    50   ~ 0
5V
Text Notes 7900 2700 0    50   ~ 0
(SNES)
Text Notes 7900 2900 0    50   ~ 0
(USB, FPGA, Various)
Text Notes 7900 3100 0    50   ~ 0
(FPGA)
Text Notes 7900 3300 0    50   ~ 0
(FPGA)
Text Notes 6200 4950 0    50   ~ 0
8-bit Sync FIFO
Text Notes 8600 5100 0    25   ~ 0
21.47727 MHz\n3.579545 MHz
Text Notes 10600 5100 0    25   ~ 0
21.47727 MHz\n3.579545 MHz
Text Notes 11100 6350 0    25   ~ 0
21.47727 MHz\n3.579545 MHz
Text Notes 8350 6600 0    25   ~ 0
21.47727 MHz\n3.579545 MHz
Text Notes 6800 6050 1    50   ~ 0
100 MHz
Text Notes 3350 5100 0    50   ~ 0
480 Mbps / 60MBps
Wire Notes Line width 12 style solid
	2850 4850 3000 4850
Wire Notes Line width 12 style solid
	3000 4850 3000 5150
Wire Notes Line width 12 style solid
	3000 5150 2850 5150
Wire Notes Line width 12 style solid
	2850 5150 2850 4850
Wire Notes Line width 12 style solid
	12000 6550 12150 6550
Wire Notes Line width 12 style solid
	12150 6550 12150 6850
Wire Notes Line width 12 style solid
	12150 6850 12000 6850
Wire Notes Line width 12 style solid
	12000 6850 12000 6550
Text Notes 11000 6750 0    25   ~ 0
Analog NTSC Component
$EndSCHEMATC
