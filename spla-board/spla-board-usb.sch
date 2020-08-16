EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A3 16535 11693
encoding utf-8
Sheet 2 7
Title "SPLA Board - USB"
Date "2020-04-26"
Rev "9"
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Device:R R1
U 1 1 5E4AB80E
P 3700 3550
F 0 "R1" V 3500 3550 50  0000 C CNN
F 1 "NOSTUFF" V 3600 3550 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 3740 3540 50  0001 C CNN
F 3 "~" H 3700 3550 50  0001 C CNN
F 4 "N/A" H 3700 3550 50  0001 C CNN "Digikey"
F 5 "N/A" H 3700 3550 50  0001 C CNN "Manufacturer"
F 6 "N/A" H 3700 3550 50  0001 C CNN "Manufacturer Id"
	1    3700 3550
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR0101
U 1 1 5E4AD97D
P 3200 4250
F 0 "#PWR0101" H 3200 4000 50  0001 C CNN
F 1 "GND" H 3205 4077 50  0000 C CNN
F 2 "" H 3200 4250 50  0001 C CNN
F 3 "" H 3200 4250 50  0001 C CNN
	1    3200 4250
	1    0    0    -1  
$EndComp
$Comp
L Device:C C1
U 1 1 5E4ACE23
P 3700 3950
F 0 "C1" V 3450 3950 50  0000 C CNN
F 1 "NOSTUFF" V 3550 3950 50  0000 C CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 3738 3800 50  0001 C CNN
F 3 "~" H 3700 3950 50  0001 C CNN
F 4 "N/A" H 3700 3950 50  0001 C CNN "Digikey"
F 5 "N/A" H 3700 3950 50  0001 C CNN "Manufacturer"
F 6 "N/A" H 3700 3950 50  0001 C CNN "Manufacturer Id"
	1    3700 3950
	0    1    1    0   
$EndComp
Wire Wire Line
	3450 3550 3550 3550
Wire Wire Line
	3850 3550 3950 3550
$Comp
L power:GND #PWR0102
U 1 1 5E4C66E6
P 3950 4250
F 0 "#PWR0102" H 3950 4000 50  0001 C CNN
F 1 "GND" H 3955 4077 50  0000 C CNN
F 2 "" H 3950 4250 50  0001 C CNN
F 3 "" H 3950 4250 50  0001 C CNN
	1    3950 4250
	1    0    0    -1  
$EndComp
$Comp
L Interface_USB:FT2232HL U2
U 1 1 5E5299CA
P 9950 5650
F 0 "U2" H 8900 7750 50  0000 L CNN
F 1 "FT2232H" H 9950 5650 101 0000 C CNB
F 2 "Package_QFP:LQFP-64_10x10mm_P0.5mm" H 9950 5650 50  0001 C CNN
F 3 "https://www.ftdichip.com/Support/Documents/DataSheets/ICs/DS_FT2232H.pdf" H 9950 5650 50  0001 C CNN
F 4 "768-1024-1-ND" H 9950 5650 50  0001 C CNN "Digikey"
F 5 "FT2232HL" H 9950 5650 50  0001 C CNN "Manufacturer Id"
F 6 "FTDI Ltd." H 9950 5650 50  0001 C CNN "Manufacturer"
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
$Comp
L power:GND #PWR0104
U 1 1 5E558255
P 5100 6850
F 0 "#PWR0104" H 5100 6600 50  0001 C CNN
F 1 "GND" H 5105 6677 50  0000 C CNN
F 2 "" H 5100 6850 50  0001 C CNN
F 3 "" H 5100 6850 50  0001 C CNN
	1    5100 6850
	1    0    0    -1  
$EndComp
Wire Wire Line
	6650 6350 8750 6350
Wire Wire Line
	4700 5950 6650 5950
Wire Wire Line
	4700 5950 4700 6450
Wire Wire Line
	6650 5950 6650 6350
$Comp
L Device:R R4
U 1 1 5E55BD51
P 6200 6850
F 0 "R4" V 5995 6850 50  0000 C CNN
F 1 "2.2k" V 6086 6850 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 6240 6840 50  0001 C CNN
F 3 "~" H 6200 6850 50  0001 C CNN
F 4 "RMCF0603JT2K20CT-ND" H 6200 6850 50  0001 C CNN "Digikey"
F 5 "Stackpole Electronics Inc" H 6200 6850 50  0001 C CNN "Manufacturer"
F 6 "RMCF0603JT2K20" H 6200 6850 50  0001 C CNN "Manufacturer Id"
	1    6200 6850
	0    1    1    0   
$EndComp
Wire Wire Line
	5500 6650 5800 6650
Wire Wire Line
	5800 6650 5800 6850
Wire Wire Line
	5800 6850 6050 6850
Wire Wire Line
	5500 6550 6650 6550
Wire Wire Line
	6350 6850 6650 6850
Wire Wire Line
	5500 6450 6250 6450
Wire Wire Line
	6650 6550 6650 6850
Wire Wire Line
	8750 6550 6650 6550
Connection ~ 6650 6550
Wire Wire Line
	6650 5450 6250 5450
Connection ~ 6250 5450
Wire Wire Line
	6250 5450 5800 5450
Wire Wire Line
	5800 5450 5800 5300
Connection ~ 5800 5450
Wire Wire Line
	5800 5750 5800 6650
Connection ~ 5800 6650
Wire Wire Line
	6250 5750 6250 6450
Connection ~ 6250 6450
Wire Wire Line
	6250 6450 8750 6450
Wire Wire Line
	6650 5750 6650 5950
Connection ~ 6650 5950
$Comp
L power:GND #PWR0105
U 1 1 5E58FEB5
P 6150 8000
F 0 "#PWR0105" H 6150 7750 50  0001 C CNN
F 1 "GND" H 6155 7827 50  0000 C CNN
F 2 "" H 6150 8000 50  0001 C CNN
F 3 "" H 6150 8000 50  0001 C CNN
	1    6150 8000
	1    0    0    -1  
$EndComp
Wire Wire Line
	8750 7450 8750 7850
Wire Wire Line
	8750 7850 8900 7850
Connection ~ 8900 7850
Text Notes 6000 5350 0    50   ~ 0
Weak pullup resistors
Wire Wire Line
	10450 3000 10450 3450
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
	8500 3950 8750 3950
Wire Wire Line
	9750 3450 9850 3450
Connection ~ 9850 3450
Wire Wire Line
	9850 3450 9950 3450
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
P 8500 3000
F 0 "#PWR0107" H 8500 2850 50  0001 C CNN
F 1 "+1V8" H 8515 3173 50  0000 C CNN
F 2 "" H 8500 3000 50  0001 C CNN
F 3 "" H 8500 3000 50  0001 C CNN
	1    8500 3000
	1    0    0    -1  
$EndComp
Wire Wire Line
	8500 3000 8500 3300
$Comp
L power:GND #PWR0108
U 1 1 5E616CF7
P 7400 5400
F 0 "#PWR0108" H 7400 5150 50  0001 C CNN
F 1 "GND" H 7405 5227 50  0000 C CNN
F 2 "" H 7400 5400 50  0001 C CNN
F 3 "" H 7400 5400 50  0001 C CNN
	1    7400 5400
	1    0    0    -1  
$EndComp
Wire Wire Line
	7400 5050 7400 5100
Wire Wire Line
	8050 5950 8050 5750
Wire Wire Line
	8050 5450 8050 5250
Wire Wire Line
	8050 5950 7850 5950
Wire Wire Line
	9750 3450 9750 3300
Connection ~ 9750 3450
Wire Wire Line
	9750 3300 9250 3300
$Comp
L power:+3V3 #PWR0109
U 1 1 5E649611
P 6150 7350
F 0 "#PWR0109" H 6150 7200 50  0001 C CNN
F 1 "+3V3" H 6165 7523 50  0000 C CNN
F 2 "" H 6150 7350 50  0001 C CNN
F 3 "" H 6150 7350 50  0001 C CNN
	1    6150 7350
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR0110
U 1 1 5E64A1B5
P 5100 6250
F 0 "#PWR0110" H 5100 6100 50  0001 C CNN
F 1 "+3V3" H 5115 6423 50  0000 C CNN
F 2 "" H 5100 6250 50  0001 C CNN
F 3 "" H 5100 6250 50  0001 C CNN
	1    5100 6250
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR0111
U 1 1 5E64AC08
P 7850 5950
F 0 "#PWR0111" H 7850 5800 50  0001 C CNN
F 1 "+3V3" H 7865 6123 50  0000 C CNN
F 2 "" H 7850 5950 50  0001 C CNN
F 3 "" H 7850 5950 50  0001 C CNN
	1    7850 5950
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR0112
U 1 1 5E64B6A0
P 5800 5300
F 0 "#PWR0112" H 5800 5150 50  0001 C CNN
F 1 "+3V3" H 5815 5473 50  0000 C CNN
F 2 "" H 5800 5300 50  0001 C CNN
F 3 "" H 5800 5300 50  0001 C CNN
	1    5800 5300
	1    0    0    -1  
$EndComp
Wire Wire Line
	8750 3000 10450 3000
Wire Wire Line
	8750 3000 8750 3750
$Comp
L power:+3V3 #PWR0113
U 1 1 5E65F7B7
P 10450 2900
F 0 "#PWR0113" H 10450 2750 50  0001 C CNN
F 1 "+3V3" H 10465 3073 50  0000 C CNN
F 2 "" H 10450 2900 50  0001 C CNN
F 3 "" H 10450 2900 50  0001 C CNN
	1    10450 2900
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
$Comp
L Connector:USB_B_Micro J3
U 1 1 5E4AA2D6
P 2800 4850
F 0 "J3" H 2857 5317 50  0000 C CNN
F 1 "USB_B_Micro" H 2857 5226 50  0000 C CNN
F 2 "Connector_USB:USB_Micro-B_Wuerth_629105150521" H 2950 4800 50  0001 C CNN
F 3 "~" H 2950 4800 50  0001 C CNN
F 4 "732-5960-1-ND" H 2800 4850 50  0001 C CNN "Digikey"
F 5 "629105150521" H 2800 4850 50  0001 C CNN "Manufacturer Id"
F 6 "Wuerth Electronik" H 2800 4850 50  0001 C CNN "Manufacturer"
	1    2800 4850
	1    0    0    1   
$EndComp
Text Notes 3900 5000 0    50   ~ 0
USB self-powered
Text GLabel 11150 5550 2    50   Output ~ 0
SPI_CLK
Text GLabel 11150 5650 2    50   Output ~ 0
SPI_MOSI
Text GLabel 11150 5750 2    50   Input ~ 0
SPI_MISO
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
Text GLabel 12000 5850 2    39   Output ~ 0
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
L SPLA:FT5HNBPK12.0-T1 X1
U 1 1 5FDCFC82
P 6950 7800
AR Path="/5FDCFC82" Ref="X1"  Part="1" 
AR Path="/5E4F712F/5FDCFC82" Ref="X1"  Part="1" 
F 0 "X1" H 6650 8050 50  0000 L CNN
F 1 "FT5HNBPK12.0-T1" H 6950 7550 50  0000 C CNN
F 2 "Crystal:Crystal_SMD_5032-4Pin_5.0x3.2mm" H 7000 7300 50  0001 C CNN
F 3 "" H 7380 7490 50  0001 C CNN
F 4 "631-1068-1-ND" H 6950 7800 50  0001 C CNN "Digikey"
F 5 "FT5HNBPK12.0-T1" H 6950 7800 50  0001 C CNN "Manufacturer Id"
F 6 "Fox Electronics" H 6950 7800 50  0001 C CNN "Manufacturer"
	1    6950 7800
	1    0    0    -1  
$EndComp
Wire Wire Line
	6550 7900 6150 7900
Wire Wire Line
	7350 7700 7350 7450
Connection ~ 6150 7900
NoConn ~ 11150 5050
Text GLabel 11150 6050 2    39   BiDi ~ 0
~INIT
Text GLabel 11150 6150 2    39   Output ~ 0
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
	3100 4850 8750 4850
Wire Wire Line
	3100 4750 8750 4750
Wire Wire Line
	6150 7450 6150 7600
Wire Wire Line
	6150 7800 6150 7900
Text GLabel 11150 7350 2    39   Output ~ 0
USB_~PWREN~
Text GLabel 11150 7450 2    39   Output ~ 0
USB_~SUSPEND~
NoConn ~ 11150 6250
NoConn ~ 11150 6550
NoConn ~ 11150 6650
Text Label 7700 6350 0    50   ~ 0
EECS
Text Label 7700 6550 0    50   ~ 0
EEDATA
Text Label 7700 6450 0    50   ~ 0
EECLK
Wire Wire Line
	7400 5050 8750 5050
Text Label 8250 5050 0    50   ~ 0
REF
Wire Wire Line
	8050 5250 8400 5250
Text Label 8450 5250 0    50   ~ 0
~RESET
Text Label 7600 4750 0    50   ~ 0
USB_D-
Text Label 7600 4850 0    50   ~ 0
USB_D+
Text Label 3450 4300 1    50   ~ 0
USB_ID
Text Label 5500 6650 0    50   ~ 0
EEDO
$Comp
L Device:LED D3
U 1 1 5EB1669C
P 12400 6700
F 0 "D3" V 12439 6583 50  0000 R CNN
F 1 "LED" V 12348 6583 50  0000 R CNN
F 2 "LED_SMD:LED_0805_2012Metric" H 12400 6700 50  0001 C CNN
F 3 "~" H 12400 6700 50  0001 C CNN
F 4 "732-4986-1-ND" H 12400 6700 50  0001 C CNN "Digikey"
F 5 "150080VS75000" H 12400 6700 50  0001 C CNN "Manufacturer Id"
F 6 "Wuerth Electronik" H 12400 6700 50  0001 C CNN "Manufacturer"
	1    12400 6700
	0    -1   -1   0   
$EndComp
$Comp
L Device:R_Small R27
U 1 1 5EB172EB
P 12400 7050
F 0 "R27" H 12459 7096 50  0000 L CNN
F 1 "330" H 12459 7005 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 12400 7050 50  0001 C CNN
F 3 "~" H 12400 7050 50  0001 C CNN
F 4 "RMCF0603JT330RCT-ND" H 12400 7050 50  0001 C CNN "Digikey"
F 5 "Stackpole Electronics Inc" H 12400 7050 50  0001 C CNN "Manufacturer"
F 6 "RMCF0603JT330R" H 12400 7050 50  0001 C CNN "Manufacturer Id"
	1    12400 7050
	1    0    0    -1  
$EndComp
Wire Wire Line
	11150 6450 12400 6450
Wire Wire Line
	12400 6850 12400 6950
Wire Wire Line
	12400 7150 12400 7250
$Comp
L power:GND #PWR0187
U 1 1 5EB1F2EF
P 12400 7250
F 0 "#PWR0187" H 12400 7000 50  0001 C CNN
F 1 "GND" H 12405 7077 50  0000 C CNN
F 2 "" H 12400 7250 50  0001 C CNN
F 3 "" H 12400 7250 50  0001 C CNN
	1    12400 7250
	1    0    0    -1  
$EndComp
Text Notes 12700 7050 0    50   ~ 0
(3.3V - 2.0V) / 4mA = 325 ohm
Wire Wire Line
	12400 6450 12400 6550
$Comp
L Memory_EEPROM:93LCxxB U3
U 1 1 5E53A19A
P 5100 6550
F 0 "U3" H 4800 6800 50  0000 L CNN
F 1 "93LC66B" H 4600 6550 50  0000 C CNN
F 2 "Package_SO:SOIC-8_3.9x4.9mm_P1.27mm" H 5100 6550 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/20001749K.pdf" H 5100 6550 50  0001 C CNN
F 4 "93LC66B/SN-ND" H 5100 6550 50  0001 C CNN "Digikey"
F 5 "93LC66B/SN" H 5100 6550 50  0001 C CNN "Manufacturer Id"
F 6 "Microchip Technology" H 5100 6550 50  0001 C CNN "Manufacturer"
	1    5100 6550
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR?
U 1 1 5E9C89C1
P 11900 5250
AR Path="/5E4D8358/5E9C89C1" Ref="#PWR?"  Part="1" 
AR Path="/5E4F712F/5E9C89C1" Ref="#PWR053"  Part="1" 
F 0 "#PWR053" H 11900 5100 50  0001 C CNN
F 1 "+3V3" H 11915 5423 50  0000 C CNN
F 2 "" H 11900 5250 50  0001 C CNN
F 3 "" H 11900 5250 50  0001 C CNN
	1    11900 5250
	1    0    0    -1  
$EndComp
Wire Wire Line
	6150 7450 7350 7450
NoConn ~ 6550 7700
Connection ~ 6150 7450
Wire Wire Line
	6150 7450 6150 7350
Wire Wire Line
	6150 7900 6150 8000
$Comp
L SPLA:BomExtra BOM1
U 1 1 5EA5FF9A
P 1600 4850
F 0 "BOM1" H 1750 4900 50  0000 L CNN
F 1 "USB Cable" H 1750 4800 50  0000 L CNN
F 2 "SPLA:BoM" H 1600 4850 50  0001 C CNN
F 3 "" H 1600 4850 50  0001 C CNN
F 4 "Q966-ND" H 1600 4850 50  0001 C CNN "Digikey"
F 5 "3025030-03" H 1600 4850 50  0001 C CNN "Manufacturer Id"
F 6 "Qualtek" H 1600 4850 50  0001 C CNN "Manufacturer"
	1    1600 4850
	1    0    0    -1  
$EndComp
Wire Wire Line
	11150 5850 11900 5850
Wire Wire Line
	11900 5850 11900 5700
Connection ~ 11900 5850
Wire Wire Line
	11900 5850 12000 5850
$Comp
L Device:R_Small R59
U 1 1 5EB42683
P 11900 5600
F 0 "R59" H 11959 5646 50  0000 L CNN
F 1 "10k" H 11959 5555 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 11900 5600 50  0001 C CNN
F 3 "~" H 11900 5600 50  0001 C CNN
F 4 "RMCF0603JT10K0CT-ND" H 11900 5600 50  0001 C CNN "Digikey"
F 5 "Stackpole Electronics Inc" H 11900 5600 50  0001 C CNN "Manufacturer"
F 6 "RMCF0603JT10K0" H 11900 5600 50  0001 C CNN "Manufacturer Id"
	1    11900 5600
	1    0    0    -1  
$EndComp
Wire Wire Line
	2800 4450 2800 4200
Wire Wire Line
	2800 4200 3200 4200
Wire Wire Line
	3200 4200 3200 4250
Wire Wire Line
	3100 3550 3200 3550
Wire Wire Line
	3200 3550 3200 3950
Connection ~ 3200 4200
Wire Wire Line
	3100 3950 3200 3950
Connection ~ 3200 3950
Wire Wire Line
	3200 3950 3200 4200
Wire Wire Line
	3100 4650 3450 4650
Wire Wire Line
	3450 4650 3450 3950
Wire Wire Line
	2700 4450 2700 3950
Wire Wire Line
	2700 3950 2700 3550
Wire Wire Line
	2700 3550 2800 3550
Connection ~ 2700 3950
$Comp
L Device:C C3
U 1 1 5E6D502E
P 7800 2250
F 0 "C3" H 7915 2296 50  0000 L CNN
F 1 "0.1uF" H 7915 2205 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 7838 2100 50  0001 C CNN
F 3 "~" H 7800 2250 50  0001 C CNN
F 4 "490-16477-1-ND" H 7800 2250 50  0001 C CNN "Digikey"
F 5 "Murata Electronics" H 7800 2250 50  0001 C CNN "Manufacturer"
F 6 "GCJ188R71E104KA12D" H 7800 2250 50  0001 C CNN "Manufacturer Id"
	1    7800 2250
	1    0    0    -1  
$EndComp
$Comp
L Device:C C4
U 1 1 5E6D5FB8
P 7800 2900
F 0 "C4" H 7915 2946 50  0000 L CNN
F 1 "0.1uF" H 7915 2855 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 7838 2750 50  0001 C CNN
F 3 "~" H 7800 2900 50  0001 C CNN
F 4 "490-16477-1-ND" H 7800 2900 50  0001 C CNN "Digikey"
F 5 "Murata Electronics" H 7800 2900 50  0001 C CNN "Manufacturer"
F 6 "GCJ188R71E104KA12D" H 7800 2900 50  0001 C CNN "Manufacturer Id"
	1    7800 2900
	1    0    0    -1  
$EndComp
$Comp
L Device:C C51
U 1 1 5E6D1368
P 7300 2250
F 0 "C51" H 7415 2296 50  0000 L CNN
F 1 "4.7uF" H 7415 2205 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 7338 2100 50  0001 C CNN
F 3 "~" H 7300 2250 50  0001 C CNN
F 4 "490-7203-1-ND" H 7300 2250 50  0001 C CNN "Digikey"
F 5 "Murata Electronics" H 7300 2250 50  0001 C CNN "Manufacturer"
F 6 "GRM188R61E475KE11D" H 7300 2250 50  0001 C CNN "Manufacturer Id"
	1    7300 2250
	1    0    0    -1  
$EndComp
$Comp
L Device:C C52
U 1 1 5E6D59EB
P 7300 2900
F 0 "C52" H 7415 2946 50  0000 L CNN
F 1 "4.7uF" H 7415 2855 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 7338 2750 50  0001 C CNN
F 3 "~" H 7300 2900 50  0001 C CNN
F 4 "490-7203-1-ND" H 7300 2900 50  0001 C CNN "Digikey"
F 5 "Murata Electronics" H 7300 2900 50  0001 C CNN "Manufacturer"
F 6 "GRM188R61E475KE11D" H 7300 2900 50  0001 C CNN "Manufacturer Id"
	1    7300 2900
	1    0    0    -1  
$EndComp
$Comp
L Device:R R53
U 1 1 5E619C52
P 8050 5600
F 0 "R53" H 8118 5646 50  0000 L CNN
F 1 "10k" H 8118 5555 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 8090 5590 50  0001 C CNN
F 3 "~" H 8050 5600 50  0001 C CNN
F 4 "RMCF0603JT10K0CT-ND" H 8050 5600 50  0001 C CNN "Digikey"
F 5 "Stackpole Electronics Inc" H 8050 5600 50  0001 C CNN "Manufacturer"
F 6 "RMCF0603JT10K0" H 8050 5600 50  0001 C CNN "Manufacturer Id"
	1    8050 5600
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C14
U 1 1 5E53DEA7
P 6150 7700
F 0 "C14" H 6265 7746 50  0000 L CNN
F 1 "0.1uF" H 6265 7655 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 6188 7550 50  0001 C CNN
F 3 "~" H 6150 7700 50  0001 C CNN
F 4 "490-16477-1-ND" H 6150 7700 50  0001 C CNN "Digikey"
F 5 "Murata Electronics" H 6150 7700 50  0001 C CNN "Manufacturer"
F 6 "GCJ188R71E104KA12D" H 6150 7700 50  0001 C CNN "Manufacturer Id"
	1    6150 7700
	1    0    0    -1  
$EndComp
$Comp
L Device:R R8
U 1 1 5E60E8AF
P 7400 5250
F 0 "R8" H 7468 5296 50  0000 L CNN
F 1 "12k, 1%" H 7468 5205 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 7440 5240 50  0001 C CNN
F 3 "~" H 7400 5250 50  0001 C CNN
F 4 "RMCF0603FT12K0CT-ND" H 7400 5250 50  0001 C CNN "Digikey"
F 5 "Stackpole Electronics Inc" H 7400 5250 50  0001 C CNN "Manufacturer"
F 6 "RMCF0603FT12K0" H 7400 5250 50  0001 C CNN "Manufacturer Id"
	1    7400 5250
	1    0    0    -1  
$EndComp
$Comp
L Device:R R52
U 1 1 5E572B74
P 6650 5600
F 0 "R52" H 6718 5646 50  0000 L CNN
F 1 "10k" H 6718 5555 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 6690 5590 50  0001 C CNN
F 3 "~" H 6650 5600 50  0001 C CNN
F 4 "RMCF0603JT10K0CT-ND" H 6650 5600 50  0001 C CNN "Digikey"
F 5 "Stackpole Electronics Inc" H 6650 5600 50  0001 C CNN "Manufacturer"
F 6 "RMCF0603JT10K0" H 6650 5600 50  0001 C CNN "Manufacturer Id"
	1    6650 5600
	1    0    0    -1  
$EndComp
$Comp
L Device:R R51
U 1 1 5E572548
P 6250 5600
F 0 "R51" H 6318 5646 50  0000 L CNN
F 1 "10k" H 6318 5555 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 6290 5590 50  0001 C CNN
F 3 "~" H 6250 5600 50  0001 C CNN
F 4 "RMCF0603JT10K0CT-ND" H 6250 5600 50  0001 C CNN "Digikey"
F 5 "Stackpole Electronics Inc" H 6250 5600 50  0001 C CNN "Manufacturer"
F 6 "RMCF0603JT10K0" H 6250 5600 50  0001 C CNN "Manufacturer Id"
	1    6250 5600
	1    0    0    -1  
$EndComp
$Comp
L Device:R R2
U 1 1 5F34ED5D
P 2950 3550
F 0 "R2" V 2750 3550 50  0000 C CNN
F 1 "NOSTUFF" V 2850 3550 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 2950 3550 50  0001 C CNN
F 3 "~" H 2950 3550 50  0001 C CNN
F 4 "N/A" H 2950 3550 50  0001 C CNN "Digikey"
F 5 "N/A" H 2950 3550 50  0001 C CNN "Manufacturer"
F 6 "N/A" H 2950 3550 50  0001 C CNN "Manufacturer Id"
	1    2950 3550
	0    1    1    0   
$EndComp
Wire Wire Line
	2700 3950 2800 3950
$Comp
L Device:C C2
U 1 1 5F34D947
P 2950 3950
F 0 "C2" V 2700 3950 50  0000 C CNN
F 1 "NOSTUFF" V 2800 3950 50  0000 C CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 2950 3950 50  0001 C CNN
F 3 "~" H 2950 3950 50  0001 C CNN
F 4 "N/A" V 2950 3950 50  0001 C CNN "Digikey"
F 5 "N/A" H 2950 3950 50  0001 C CNN "Manufacturer"
F 6 "N/A" H 2950 3950 50  0001 C CNN "Manufacturer Id"
	1    2950 3950
	0    1    1    0   
$EndComp
Text Label 2700 4300 1    50   ~ 0
SHIELD
Wire Wire Line
	3100 5050 3650 5050
Text Label 3250 5050 0    50   ~ 0
VBUS
NoConn ~ 3650 5050
$Comp
L Connector:TestPoint TP5
U 1 1 5F33FE5B
P 7700 3800
F 0 "TP5" H 7758 3918 50  0000 L CNN
F 1 "TP_1V8" H 7758 3827 50  0000 L CNN
F 2 "TestPoint:TestPoint_Pad_D1.0mm" H 7900 3800 50  0001 C CNN
F 3 "~" H 7900 3800 50  0001 C CNN
F 4 "N/A" H 7700 3800 50  0001 C CNN "Digikey"
F 5 "N/A" H 7700 3800 50  0001 C CNN "Manufacturer"
F 6 "N/A" H 7700 3800 50  0001 C CNN "Manufacturer Id"
	1    7700 3800
	1    0    0    -1  
$EndComp
Wire Wire Line
	8500 3950 7700 3950
Wire Wire Line
	7700 3950 7700 3800
Text GLabel 8300 8300 2    50   Output ~ 0
CLK_12MHZ
Wire Wire Line
	8100 8300 8300 8300
Wire Wire Line
	8100 6850 8750 6850
$Comp
L Device:R R3
U 1 1 5F34C3CC
P 8400 5600
F 0 "R3" H 8468 5646 50  0000 L CNN
F 1 "NOSTUFF" H 8468 5555 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 8440 5590 50  0001 C CNN
F 3 "~" H 8400 5600 50  0001 C CNN
F 4 "N/A" H 8400 5600 50  0001 C CNN "Digikey"
F 5 "N/A" H 8400 5600 50  0001 C CNN "Manufacturer"
F 6 "N/A" H 8400 5600 50  0001 C CNN "Manufacturer Id"
	1    8400 5600
	1    0    0    -1  
$EndComp
Wire Wire Line
	8400 5250 8400 5450
Connection ~ 8400 5250
Wire Wire Line
	8400 5250 8750 5250
$Comp
L power:GND #PWR0233
U 1 1 5F35C8C6
P 8400 5750
F 0 "#PWR0233" H 8400 5500 50  0001 C CNN
F 1 "GND" H 8405 5577 50  0000 C CNN
F 2 "" H 8400 5750 50  0001 C CNN
F 3 "" H 8400 5750 50  0001 C CNN
	1    8400 5750
	1    0    0    -1  
$EndComp
Wire Wire Line
	3550 3950 3450 3950
Connection ~ 3450 3950
Wire Wire Line
	3450 3950 3450 3550
Wire Wire Line
	3950 3550 3950 3950
Wire Wire Line
	3850 3950 3950 3950
Connection ~ 3950 3950
Wire Wire Line
	3950 3950 3950 4250
Wire Wire Line
	11900 5250 11900 5500
$Comp
L Device:R R75
U 1 1 5F36220C
P 8500 3600
F 0 "R75" H 8570 3646 50  0000 L CNN
F 1 "0" H 8570 3555 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 8430 3600 50  0001 C CNN
F 3 "~" H 8500 3600 50  0001 C CNN
F 4 "2019-RK73Z1JTTDCT-ND" H 8500 3600 50  0001 C CNN "Digikey"
F 5 "KOA Speer Electronics Inc." H 8500 3600 50  0001 C CNN "Manufacturer"
F 6 "RK73Z1JTTD" H 8500 3600 50  0001 C CNN "Manufacturer Id"
	1    8500 3600
	1    0    0    -1  
$EndComp
Wire Wire Line
	8500 3450 8500 3300
Connection ~ 8500 3300
Wire Wire Line
	8500 3750 8500 3950
Text Label 8850 3300 0    50   ~ 0
VREGIN
Text Label 7950 3950 0    50   ~ 0
VREGOUT
$Comp
L power:PWR_FLAG #FLG0108
U 1 1 5F75FBCC
P 9250 3300
F 0 "#FLG0108" H 9250 3375 50  0001 C CNN
F 1 "PWR_FLAG" H 9250 3473 50  0000 C CNN
F 2 "" H 9250 3300 50  0001 C CNN
F 3 "~" H 9250 3300 50  0001 C CNN
	1    9250 3300
	1    0    0    -1  
$EndComp
Connection ~ 9250 3300
Wire Wire Line
	9250 3300 8500 3300
Wire Wire Line
	10450 2900 10450 3000
Connection ~ 10450 3000
$Comp
L Device:C C53
U 1 1 5E5E774C
P 8500 4150
F 0 "C53" H 8615 4196 50  0000 L CNN
F 1 "4.7uF" H 8615 4105 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 8538 4000 50  0001 C CNN
F 3 "~" H 8500 4150 50  0001 C CNN
F 4 "490-7203-1-ND" H 8500 4150 50  0001 C CNN "Digikey"
F 5 "Murata Electronics" H 8500 4150 50  0001 C CNN "Manufacturer"
F 6 "GRM188R61E475KE11D" H 8500 4150 50  0001 C CNN "Manufacturer Id"
	1    8500 4150
	1    0    0    -1  
$EndComp
$Comp
L Device:R R50
U 1 1 5E571C78
P 5800 5600
F 0 "R50" H 5868 5646 50  0000 L CNN
F 1 "10k" H 5868 5555 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 5840 5590 50  0001 C CNN
F 3 "~" H 5800 5600 50  0001 C CNN
F 4 "RMCF0603JT10K0CT-ND" H 5800 5600 50  0001 C CNN "Digikey"
F 5 "Stackpole Electronics Inc" H 5800 5600 50  0001 C CNN "Manufacturer"
F 6 "RMCF0603JT10K0" H 5800 5600 50  0001 C CNN "Manufacturer Id"
	1    5800 5600
	1    0    0    -1  
$EndComp
$Comp
L Connector:TestPoint TP6
U 1 1 5F3A03C0
P 7600 7800
F 0 "TP6" H 7658 7918 50  0000 L CNN
F 1 "TP_12MHZ" H 7658 7827 50  0000 L CNN
F 2 "TestPoint:TestPoint_Pad_D1.0mm" H 7800 7800 50  0001 C CNN
F 3 "~" H 7800 7800 50  0001 C CNN
F 4 "N/A" H 7600 7800 50  0001 C CNN "Digikey"
F 5 "N/A" H 7600 7800 50  0001 C CNN "Manufacturer"
F 6 "N/A" H 7600 7800 50  0001 C CNN "Manufacturer Id"
	1    7600 7800
	1    0    0    -1  
$EndComp
Wire Wire Line
	8100 6850 8100 7900
Wire Wire Line
	7350 7900 7600 7900
Connection ~ 8100 7900
Wire Wire Line
	8100 7900 8100 8300
Wire Wire Line
	7600 7900 7600 7800
Connection ~ 7600 7900
Wire Wire Line
	7600 7900 8100 7900
$EndSCHEMATC
