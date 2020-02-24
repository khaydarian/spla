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
S 4000 4500 1500 1000
U 5E4F712F
F0 "SPLA Board - USB" 50
F1 "spla-board-usb.sch" 50
$EndSheet
$Sheet
S 6500 4500 1500 1000
U 5E4D8358
F0 "SPLA Board - FPGA" 50
F1 "spla-board-fpga.sch" 50
$EndSheet
$Sheet
S 8500 4500 1500 1000
U 5E50D400
F0 "SPLA Board - Level Shifters" 50
F1 "spla-board-level-shifters.sch" 50
$EndSheet
$Sheet
S 10500 4500 1500 1000
U 5E50E589
F0 "SPLA Board - PPU" 50
F1 "spla-board-ppu.sch" 50
$EndSheet
$Sheet
S 8500 6000 1500 1000
U 5E520B87
F0 "SPLA Board - Analog" 50
F1 "spla-board-analog.sch" 50
$EndSheet
$Sheet
S 5500 2500 1500 1000
U 5E50D39B
F0 "SPLA Board - Power" 50
F1 "spla-board-power.sch" 50
$EndSheet
$Sheet
S 5000 6500 1500 1000
U 5E50D3C6
F0 "SPLA Board - SRAM" 50
F1 "spla-board-sram.sch" 50
$EndSheet
Wire Notes Line width 12 style solid
	2500 5000 4000 5000
Text Notes 2850 4950 0    50   ~ 0
USB 2.0 High Speed
Wire Notes Line width 12 style solid
	5500 5000 6500 5000
Wire Notes Line width 12 style solid
	8000 5000 8500 5000
Wire Notes Line width 12 style solid
	10000 5000 10500 5000
Wire Notes Line width 12 style solid
	11500 5500 11500 6250
Wire Notes Line width 12 style solid
	11500 6250 10000 6250
Wire Notes Line width 12 style solid
	8500 6500 7600 6500
Wire Notes Line width 12 style solid
	7600 6500 7600 5500
Wire Notes Line width 12 style solid
	6500 5400 6200 5400
Wire Notes Line width 12 style solid
	6200 5400 6200 6500
Wire Notes Line width 12 style solid
	10000 6700 11500 6700
Text Notes 10450 6650 0    50   ~ 0
Component Out
Text Notes 6150 6200 1    50   ~ 0
32-bit R/W bus
Text Notes 5850 5100 0    50   ~ 0
60 MHz
Text Notes 8450 4950 2    50   ~ 0
(wide bus)
Text Notes 10450 4950 2    50   ~ 0
(wide bus)
Text Notes 11000 6200 2    50   ~ 0
Analog R/G/B
Text Notes 8400 6450 2    50   ~ 0
30-bit R/G/B bus
Wire Notes Line style solid
	7000 2700 7300 2700
Wire Notes Line style solid
	7300 2650 7300 2750
Wire Notes Line style solid
	7300 2750 7350 2700
Wire Notes Line style solid
	7300 2650 7350 2700
Wire Notes Line style solid
	7000 2900 7300 2900
Wire Notes Line style solid
	7300 2850 7300 2950
Wire Notes Line style solid
	7300 2950 7350 2900
Wire Notes Line style solid
	7300 2850 7350 2900
Wire Notes Line style solid
	7000 3100 7300 3100
Wire Notes Line style solid
	7300 3050 7300 3150
Wire Notes Line style solid
	7300 3150 7350 3100
Wire Notes Line style solid
	7300 3050 7350 3100
Text Notes 7100 2700 0    50   ~ 0
5V
Text Notes 7050 2900 0    50   ~ 0
3.3V
Text Notes 7050 3100 0    50   ~ 0
2.5V
Wire Notes Line style solid
	7000 3300 7300 3300
Wire Notes Line style solid
	7300 3250 7300 3350
Wire Notes Line style solid
	7300 3350 7350 3300
Wire Notes Line style solid
	7300 3250 7350 3300
Text Notes 7050 3300 0    50   ~ 0
1.1V
Wire Notes Line style solid
	5150 3000 5450 3000
Wire Notes Line style solid
	5450 2950 5450 3050
Wire Notes Line style solid
	5450 3050 5500 3000
Wire Notes Line style solid
	5450 2950 5500 3000
Text Notes 5250 3000 0    50   ~ 0
5V
Text Notes 7400 2700 0    50   ~ 0
(SNES)
Text Notes 7400 2900 0    50   ~ 0
(USB, FPGA, Various)
Text Notes 7400 3100 0    50   ~ 0
(FPGA)
Text Notes 7400 3300 0    50   ~ 0
(FPGA)
Text Notes 5700 4950 0    50   ~ 0
8-bit Sync FIFO
Text Notes 8100 5100 0    25   ~ 0
21.47727 MHz\n3.579545 MHz
Text Notes 10100 5100 0    25   ~ 0
21.47727 MHz\n3.579545 MHz
Text Notes 10600 6350 0    25   ~ 0
21.47727 MHz\n3.579545 MHz
Text Notes 7850 6600 0    25   ~ 0
21.47727 MHz\n3.579545 MHz
Text Notes 6300 6050 1    50   ~ 0
100 MHz
Text Notes 2850 5100 0    50   ~ 0
480 Mbps / 60MBps
Wire Notes Line width 12 style solid
	2350 4850 2500 4850
Wire Notes Line width 12 style solid
	2500 4850 2500 5150
Wire Notes Line width 12 style solid
	2500 5150 2350 5150
Wire Notes Line width 12 style solid
	2350 5150 2350 4850
Wire Notes Line width 12 style solid
	11500 6550 11650 6550
Wire Notes Line width 12 style solid
	11650 6550 11650 6850
Wire Notes Line width 12 style solid
	11650 6850 11500 6850
Wire Notes Line width 12 style solid
	11500 6850 11500 6550
Text Notes 10500 6750 0    25   ~ 0
Analog NTSC Component
$EndSCHEMATC
