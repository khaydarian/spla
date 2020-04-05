EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A3 16535 11693
encoding utf-8
Sheet 2 7
Title "SPLA Board - USB"
Date "2020-04-01"
Rev "6"
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Device:R R1
U 1 1 5E4AB80E
P 3750 4150
F 0 "R1" H 3682 4104 50  0000 R CNN
F 1 "0" H 3682 4195 50  0000 R CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 3790 4140 50  0001 C CNN
F 3 "~" H 3750 4150 50  0001 C CNN
	1    3750 4150
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR0101
U 1 1 5E4AD97D
P 2450 4450
F 0 "#PWR0101" H 2450 4200 50  0001 C CNN
F 1 "GND" H 2455 4277 50  0000 C CNN
F 2 "" H 2450 4450 50  0001 C CNN
F 3 "" H 2450 4450 50  0001 C CNN
	1    2450 4450
	1    0    0    -1  
$EndComp
$Comp
L Device:C C1
U 1 1 5E4ACE23
P 3350 4150
F 0 "C1" H 3235 4104 50  0000 R CNN
F 1 "0.1uF" H 3235 4195 50  0000 R CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 3388 4000 50  0001 C CNN
F 3 "~" H 3350 4150 50  0001 C CNN
	1    3350 4150
	-1   0    0    1   
$EndComp
Wire Wire Line
	3750 3850 3750 4000
Wire Wire Line
	3350 4000 3350 3850
Connection ~ 3350 3850
Wire Wire Line
	3350 3850 3750 3850
Wire Wire Line
	3350 4300 3350 4450
Wire Wire Line
	3750 4300 3750 4450
$Comp
L power:GND #PWR0102
U 1 1 5E4C66E6
P 3500 4450
F 0 "#PWR0102" H 3500 4200 50  0001 C CNN
F 1 "GND" H 3505 4277 50  0000 C CNN
F 2 "" H 3500 4450 50  0001 C CNN
F 3 "" H 3500 4450 50  0001 C CNN
	1    3500 4450
	1    0    0    -1  
$EndComp
Wire Wire Line
	3350 4450 3500 4450
Connection ~ 3500 4450
Wire Wire Line
	3500 4450 3750 4450
$Comp
L Interface_USB:FT2232H U2
U 1 1 5E5299CA
P 9950 5650
F 0 "U2" H 8900 7750 50  0000 L CNN
F 1 "FT2232H" H 9950 5650 101 0000 C CNB
F 2 "Package_QFP:LQFP-64-1EP_10x10mm_P0.5mm_EP6.5x6.5mm" H 9950 5650 50  0001 C CNN
F 3 "https://www.ftdichip.com/Support/Documents/DataSheets/ICs/DS_FT2232H.pdf" H 9950 5650 50  0001 C CNN
	1    9950 5650
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0103
U 1 1 5E52FAA0
P 8900 7850
F 0 "#PWR0103" H 8900 7600 50  0001 C CNN
F 1 "GND" H 8905 7677 50  0000 C CNN
F 2 "" H 8900 7850 50  0001 C CNN
F 3 "" H 8900 7850 50  0001 C CNN
	1    8900 7850
	1    0    0    -1  
$EndComp
Wire Wire Line
	10250 7850 10150 7850
Connection ~ 9350 7850
Wire Wire Line
	9350 7850 8900 7850
Connection ~ 9550 7850
Wire Wire Line
	9550 7850 9350 7850
Connection ~ 9650 7850
Wire Wire Line
	9650 7850 9550 7850
Connection ~ 9750 7850
Wire Wire Line
	9750 7850 9650 7850
Connection ~ 9850 7850
Wire Wire Line
	9850 7850 9750 7850
Connection ~ 9950 7850
Wire Wire Line
	9950 7850 9850 7850
Connection ~ 10050 7850
Wire Wire Line
	10050 7850 9950 7850
Connection ~ 10150 7850
Wire Wire Line
	10150 7850 10050 7850
NoConn ~ 8750 7250
Wire Wire Line
	7550 7900 8100 7900
Wire Wire Line
	8100 7900 8100 6850
Wire Wire Line
	8100 6850 8750 6850
$Comp
L Device:C_Small C2
U 1 1 5E53DEA7
P 6350 7600
F 0 "C2" H 6465 7646 50  0000 L CNN
F 1 "0.1uF" H 6465 7555 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 6388 7450 50  0001 C CNN
F 3 "~" H 6350 7600 50  0001 C CNN
	1    6350 7600
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0104
U 1 1 5E558255
P 5700 6850
F 0 "#PWR0104" H 5700 6600 50  0001 C CNN
F 1 "GND" H 5705 6677 50  0000 C CNN
F 2 "" H 5700 6850 50  0001 C CNN
F 3 "" H 5700 6850 50  0001 C CNN
	1    5700 6850
	1    0    0    -1  
$EndComp
Wire Wire Line
	7250 6350 8750 6350
$Comp
L Memory_EEPROM:93LCxxA U3
U 1 1 5E53A19A
P 5700 6550
F 0 "U3" H 5400 6800 50  0000 L CNN
F 1 "93LCxxA" H 5200 6550 50  0000 C CNN
F 2 "Package_SO:SOIC-8_3.9x4.9mm_P1.27mm" H 5700 6550 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/20001749K.pdf" H 5700 6550 50  0001 C CNN
	1    5700 6550
	1    0    0    -1  
$EndComp
Wire Wire Line
	5300 5950 7250 5950
Wire Wire Line
	5300 5950 5300 6450
Wire Wire Line
	7250 5950 7250 6350
$Comp
L Device:R R3
U 1 1 5E55BD51
P 6800 6850
F 0 "R3" V 6595 6850 50  0000 C CNN
F 1 "2.2K" V 6686 6850 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 6840 6840 50  0001 C CNN
F 3 "~" H 6800 6850 50  0001 C CNN
	1    6800 6850
	0    1    1    0   
$EndComp
Wire Wire Line
	6100 6650 6400 6650
Wire Wire Line
	6400 6650 6400 6850
Wire Wire Line
	6400 6850 6650 6850
Wire Wire Line
	6100 6550 7250 6550
Wire Wire Line
	6950 6850 7250 6850
Wire Wire Line
	6100 6450 6850 6450
Wire Wire Line
	7250 6550 7250 6850
Wire Wire Line
	8750 6550 7250 6550
Connection ~ 7250 6550
$Comp
L Device:R R2
U 1 1 5E571C78
P 6400 5600
F 0 "R2" H 6468 5646 50  0000 L CNN
F 1 "10K" H 6468 5555 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 6440 5590 50  0001 C CNN
F 3 "~" H 6400 5600 50  0001 C CNN
	1    6400 5600
	1    0    0    -1  
$EndComp
$Comp
L Device:R R4
U 1 1 5E572548
P 6850 5600
F 0 "R4" H 6918 5646 50  0000 L CNN
F 1 "10K" H 6918 5555 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 6890 5590 50  0001 C CNN
F 3 "~" H 6850 5600 50  0001 C CNN
	1    6850 5600
	1    0    0    -1  
$EndComp
$Comp
L Device:R R5
U 1 1 5E572B74
P 7250 5600
F 0 "R5" H 7318 5646 50  0000 L CNN
F 1 "10K" H 7318 5555 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 7290 5590 50  0001 C CNN
F 3 "~" H 7250 5600 50  0001 C CNN
	1    7250 5600
	1    0    0    -1  
$EndComp
Wire Wire Line
	7250 5450 6850 5450
Connection ~ 6850 5450
Wire Wire Line
	6850 5450 6400 5450
Wire Wire Line
	6400 5450 6400 5300
Connection ~ 6400 5450
Wire Wire Line
	6400 5750 6400 6650
Connection ~ 6400 6650
Wire Wire Line
	6850 5750 6850 6450
Connection ~ 6850 6450
Wire Wire Line
	6850 6450 8750 6450
Wire Wire Line
	7250 5750 7250 5950
Connection ~ 7250 5950
$Comp
L power:GND #PWR0105
U 1 1 5E58FEB5
P 6350 7900
F 0 "#PWR0105" H 6350 7650 50  0001 C CNN
F 1 "GND" H 6355 7727 50  0000 C CNN
F 2 "" H 6350 7900 50  0001 C CNN
F 3 "" H 6350 7900 50  0001 C CNN
	1    6350 7900
	1    0    0    -1  
$EndComp
Wire Wire Line
	8750 7450 8750 7850
Wire Wire Line
	8750 7850 8900 7850
Connection ~ 8900 7850
Text Notes 6600 5350 0    50   ~ 0
Weak pullup resistors
Wire Wire Line
	10450 3200 10450 3450
Wire Wire Line
	10150 3450 10250 3450
Connection ~ 10450 3450
Connection ~ 10250 3450
Wire Wire Line
	10250 3450 10350 3450
Connection ~ 10350 3450
Wire Wire Line
	10350 3450 10450 3450
Wire Wire Line
	8500 3300 8500 3950
Wire Wire Line
	8500 3950 8750 3950
Wire Wire Line
	9750 3450 9850 3450
Connection ~ 9850 3450
Wire Wire Line
	9850 3450 9950 3450
$Comp
L Device:C C7
U 1 1 5E5E774C
P 8500 4150
F 0 "C7" H 8615 4196 50  0000 L CNN
F 1 "3.3uF" H 8615 4105 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 8538 4000 50  0001 C CNN
F 3 "~" H 8500 4150 50  0001 C CNN
	1    8500 4150
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0106
U 1 1 5E5E7F66
P 8500 4300
F 0 "#PWR0106" H 8500 4050 50  0001 C CNN
F 1 "GND" H 8505 4127 50  0000 C CNN
F 2 "" H 8500 4300 50  0001 C CNN
F 3 "" H 8500 4300 50  0001 C CNN
	1    8500 4300
	1    0    0    -1  
$EndComp
Wire Wire Line
	8500 3950 8500 4000
Connection ~ 8500 3950
$Comp
L power:+1V8 #PWR0107
U 1 1 5E5F64FC
P 8500 3100
F 0 "#PWR0107" H 8500 2950 50  0001 C CNN
F 1 "+1V8" H 8515 3273 50  0000 C CNN
F 2 "" H 8500 3100 50  0001 C CNN
F 3 "" H 8500 3100 50  0001 C CNN
	1    8500 3100
	1    0    0    -1  
$EndComp
Wire Wire Line
	8500 3100 8500 3300
Connection ~ 8500 3300
$Comp
L Device:R R6
U 1 1 5E60E8AF
P 7800 5250
F 0 "R6" H 7868 5296 50  0000 L CNN
F 1 "12K" H 7868 5205 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 7840 5240 50  0001 C CNN
F 3 "~" H 7800 5250 50  0001 C CNN
	1    7800 5250
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0108
U 1 1 5E616CF7
P 7800 5400
F 0 "#PWR0108" H 7800 5150 50  0001 C CNN
F 1 "GND" H 7805 5227 50  0000 C CNN
F 2 "" H 7800 5400 50  0001 C CNN
F 3 "" H 7800 5400 50  0001 C CNN
	1    7800 5400
	1    0    0    -1  
$EndComp
Wire Wire Line
	7800 5050 7800 5100
$Comp
L Device:R R7
U 1 1 5E619C52
P 8300 5600
F 0 "R7" H 8368 5646 50  0000 L CNN
F 1 "1K" H 8368 5555 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 8340 5590 50  0001 C CNN
F 3 "~" H 8300 5600 50  0001 C CNN
	1    8300 5600
	1    0    0    -1  
$EndComp
Wire Wire Line
	8300 5950 8300 5750
Wire Wire Line
	8300 5450 8300 5250
Wire Wire Line
	8300 5950 8100 5950
Wire Wire Line
	9750 3450 9750 3300
Connection ~ 9750 3450
Wire Wire Line
	9750 3300 8500 3300
$Comp
L power:+3V3 #PWR0109
U 1 1 5E649611
P 7550 7350
F 0 "#PWR0109" H 7550 7200 50  0001 C CNN
F 1 "+3V3" H 7565 7523 50  0000 C CNN
F 2 "" H 7550 7350 50  0001 C CNN
F 3 "" H 7550 7350 50  0001 C CNN
	1    7550 7350
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR0110
U 1 1 5E64A1B5
P 5700 6250
F 0 "#PWR0110" H 5700 6100 50  0001 C CNN
F 1 "+3V3" H 5715 6423 50  0000 C CNN
F 2 "" H 5700 6250 50  0001 C CNN
F 3 "" H 5700 6250 50  0001 C CNN
	1    5700 6250
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR0111
U 1 1 5E64AC08
P 8100 5950
F 0 "#PWR0111" H 8100 5800 50  0001 C CNN
F 1 "+3V3" H 8115 6123 50  0000 C CNN
F 2 "" H 8100 5950 50  0001 C CNN
F 3 "" H 8100 5950 50  0001 C CNN
	1    8100 5950
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR0112
U 1 1 5E64B6A0
P 6400 5300
F 0 "#PWR0112" H 6400 5150 50  0001 C CNN
F 1 "+3V3" H 6415 5473 50  0000 C CNN
F 2 "" H 6400 5300 50  0001 C CNN
F 3 "" H 6400 5300 50  0001 C CNN
	1    6400 5300
	1    0    0    -1  
$EndComp
Wire Wire Line
	8750 3200 10450 3200
Wire Wire Line
	8750 3200 8750 3750
$Comp
L power:+3V3 #PWR0113
U 1 1 5E65F7B7
P 8750 3100
F 0 "#PWR0113" H 8750 2950 50  0001 C CNN
F 1 "+3V3" H 8765 3273 50  0000 C CNN
F 2 "" H 8750 3100 50  0001 C CNN
F 3 "" H 8750 3100 50  0001 C CNN
	1    8750 3100
	1    0    0    -1  
$EndComp
Connection ~ 8750 3200
Wire Wire Line
	8750 3200 8750 3100
Text Notes 3800 4350 0    25   ~ 0
(Not sure what this 0-Ohm resistor is for.)
$Comp
L Device:C C3
U 1 1 5E6D1368
P 7300 2250
F 0 "C3" H 7415 2296 50  0000 L CNN
F 1 "4.7uF" H 7415 2205 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 7338 2100 50  0001 C CNN
F 3 "~" H 7300 2250 50  0001 C CNN
	1    7300 2250
	1    0    0    -1  
$EndComp
$Comp
L Device:C C5
U 1 1 5E6D502E
P 7800 2250
F 0 "C5" H 7915 2296 50  0000 L CNN
F 1 "0.1uF" H 7915 2205 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 7838 2100 50  0001 C CNN
F 3 "~" H 7800 2250 50  0001 C CNN
	1    7800 2250
	1    0    0    -1  
$EndComp
$Comp
L Device:C C4
U 1 1 5E6D59EB
P 7300 2900
F 0 "C4" H 7415 2946 50  0000 L CNN
F 1 "4.7uF" H 7415 2855 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 7338 2750 50  0001 C CNN
F 3 "~" H 7300 2900 50  0001 C CNN
	1    7300 2900
	1    0    0    -1  
$EndComp
$Comp
L Device:C C6
U 1 1 5E6D5FB8
P 7800 2900
F 0 "C6" H 7915 2946 50  0000 L CNN
F 1 "0.1uF" H 7915 2855 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 7838 2750 50  0001 C CNN
F 3 "~" H 7800 2900 50  0001 C CNN
	1    7800 2900
	1    0    0    -1  
$EndComp
Wire Wire Line
	9450 3450 9450 2750
Wire Wire Line
	9450 2750 7800 2750
Connection ~ 7800 2750
Wire Wire Line
	7800 2750 7300 2750
Wire Wire Line
	9550 2100 7800 2100
Connection ~ 7800 2100
Wire Wire Line
	7800 2100 7300 2100
$Comp
L power:+3V3 #PWR0114
U 1 1 5E6E2FCF
P 6950 2000
F 0 "#PWR0114" H 6950 1850 50  0001 C CNN
F 1 "+3V3" H 6965 2173 50  0000 C CNN
F 2 "" H 6950 2000 50  0001 C CNN
F 3 "" H 6950 2000 50  0001 C CNN
	1    6950 2000
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR0115
U 1 1 5E6E38A9
P 6950 2650
F 0 "#PWR0115" H 6950 2500 50  0001 C CNN
F 1 "+3V3" H 6965 2823 50  0000 C CNN
F 2 "" H 6950 2650 50  0001 C CNN
F 3 "" H 6950 2650 50  0001 C CNN
	1    6950 2650
	1    0    0    -1  
$EndComp
Wire Wire Line
	7300 2100 6950 2100
Wire Wire Line
	6950 2100 6950 2000
Connection ~ 7300 2100
Wire Wire Line
	7300 2750 6950 2750
Wire Wire Line
	6950 2750 6950 2650
Connection ~ 7300 2750
Wire Wire Line
	9550 2100 9550 3450
$Comp
L power:GND #PWR0116
U 1 1 5E6F4907
P 7300 2400
F 0 "#PWR0116" H 7300 2150 50  0001 C CNN
F 1 "GND" H 7305 2227 50  0000 C CNN
F 2 "" H 7300 2400 50  0001 C CNN
F 3 "" H 7300 2400 50  0001 C CNN
	1    7300 2400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0117
U 1 1 5E6F5039
P 7300 3050
F 0 "#PWR0117" H 7300 2800 50  0001 C CNN
F 1 "GND" H 7305 2877 50  0000 C CNN
F 2 "" H 7300 3050 50  0001 C CNN
F 3 "" H 7300 3050 50  0001 C CNN
	1    7300 3050
	1    0    0    -1  
$EndComp
Wire Wire Line
	7800 2400 7300 2400
Connection ~ 7300 2400
Wire Wire Line
	7800 3050 7300 3050
Connection ~ 7300 3050
Text Notes 7200 1950 0    50   ~ 0
Decoupling Capacitors\n
Wire Wire Line
	3100 3850 3350 3850
NoConn ~ 3100 5050
$Comp
L Connector:USB_B_Micro J1
U 1 1 5E4AA2D6
P 2800 4850
F 0 "J1" H 2857 5317 50  0000 C CNN
F 1 "USB_B_Micro" H 2857 5226 50  0000 C CNN
F 2 "Connector_USB:USB_Micro-B_Wuerth_629105150521" H 2950 4800 50  0001 C CNN
F 3 "~" H 2950 4800 50  0001 C CNN
	1    2800 4850
	1    0    0    1   
$EndComp
Text Notes 3250 5000 0    50   ~ 0
USB self-powered
Text GLabel 11150 5550 2    50   Output ~ 0
SPI_CLK
Text GLabel 11150 5650 2    50   Output ~ 0
SPI_MOSI
Text GLabel 11150 5750 2    50   Input ~ 0
SPI_MISO
Text Notes 11800 6450 0    50   ~ 0
TODO: Include an LED here, for bringup.
Text GLabel 11150 3750 2    50   BiDi ~ 0
FIFO_D0
Text GLabel 11150 3850 2    50   BiDi ~ 0
FIFO_D1
Text GLabel 11150 3950 2    50   BiDi ~ 0
FIFO_D2
Text GLabel 11150 4050 2    50   BiDi ~ 0
FIFO_D3
Text GLabel 11150 4150 2    50   BiDi ~ 0
FIFO_D4
Text GLabel 11150 4250 2    50   BiDi ~ 0
FIFO_D5
Text GLabel 11150 4350 2    50   BiDi ~ 0
FIFO_D6
Text GLabel 11150 4450 2    50   BiDi ~ 0
FIFO_D7
Text GLabel 11150 5850 2    39   Input ~ 0
SPI_~CS~
Text GLabel 11150 4650 2    39   Output ~ 0
FIFO_~RXF~
Text GLabel 11150 4750 2    39   Output ~ 0
FIFO_~TXE~
Text GLabel 11150 4850 2    39   Input ~ 0
FIFO_~RD~
Text GLabel 11150 4950 2    39   Input ~ 0
FIFO_~WR~
Text GLabel 11150 5150 2    50   Output ~ 0
FIFO_CLKOUT
Text GLabel 11150 5250 2    39   Input ~ 0
FIFO_~OE~
Text GLabel 11150 5350 2    50   Input ~ 0
FIFO_SIWU
$Comp
L SPLA:O252012MEDH4MI X1
U 1 1 5FDCFC82
P 7150 7800
F 0 "X1" H 6850 8050 50  0000 L CNN
F 1 "O252012MEDH4MI" H 7150 7550 50  0000 C CNN
F 2 "Crystal:Crystal_SMD_2520-4Pin_2.5x2.0mm" H 7200 7300 50  0001 C CNN
F 3 "" H 7580 7490 50  0001 C CNN
	1    7150 7800
	1    0    0    -1  
$EndComp
Wire Wire Line
	6750 7900 6350 7900
Wire Wire Line
	6350 7350 6750 7350
Wire Wire Line
	7550 7700 7550 7350
Connection ~ 7550 7350
Wire Wire Line
	6750 7700 6750 7350
Connection ~ 6750 7350
Wire Wire Line
	6750 7350 7550 7350
Connection ~ 6350 7900
NoConn ~ 11150 5050
Text GLabel 11150 6050 2    39   BiDi ~ 0
~INIT
Text GLabel 11150 6150 2    39   Input ~ 0
~PROGRAM
Text GLabel 11150 5950 2    50   BiDi ~ 0
DONE
NoConn ~ 11150 6750
Text GLabel 11150 7150 2    50   Input ~ 0
JTAG_TMS
Text GLabel 11150 6850 2    50   Input ~ 0
JTAG_TCK
Text GLabel 11150 6950 2    50   Input ~ 0
JTAG_TDI
Text GLabel 11150 7050 2    50   Input ~ 0
JTAG_TDO
Wire Wire Line
	2800 4450 2700 4450
Connection ~ 2700 4450
Wire Wire Line
	2700 4450 2450 4450
Wire Wire Line
	3100 4850 8750 4850
Wire Wire Line
	3100 4750 8750 4750
Wire Wire Line
	3100 4650 3100 3850
Text GLabel 8300 8300 2    50   Output ~ 0
CLK_12MHZ
Wire Wire Line
	8100 7900 8100 8300
Wire Wire Line
	8100 8300 8300 8300
Connection ~ 8100 7900
Wire Wire Line
	6350 7350 6350 7500
Wire Wire Line
	6350 7700 6350 7900
Text Notes 5400 8450 0    50   ~ 0
CMOS digital oscillator, rather than FTDI's crystal suggestion
Text GLabel 11150 7350 2    39   Output ~ 0
USB_~PWREN~
Text GLabel 11150 7450 2    39   Output ~ 0
USB_~SUSPEND~
NoConn ~ 11150 6250
NoConn ~ 11150 6450
NoConn ~ 11150 6550
NoConn ~ 11150 6650
Text Label 7700 6350 0    50   ~ 0
EECS
Text Label 7700 6550 0    50   ~ 0
EEDATA
Text Label 7700 6450 0    50   ~ 0
EECLK
Wire Wire Line
	7800 5050 8750 5050
Text Label 8250 5050 0    50   ~ 0
REF
Wire Wire Line
	8300 5250 8750 5250
Text Label 8450 5250 0    50   ~ 0
~RESET
Text Label 7600 4750 0    50   ~ 0
USB_D-
Text Label 7600 4850 0    50   ~ 0
USB_D+
Text Label 3450 3850 0    50   ~ 0
USB_ID
Text Label 6100 6650 0    50   ~ 0
EEDO
$EndSCHEMATC
