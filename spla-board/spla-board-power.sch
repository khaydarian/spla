EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A3 16535 11693
encoding utf-8
Sheet 7 7
Title ""
Date "2020-04-12"
Rev "8"
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Connector:Barrel_Jack J7
U 1 1 5E532515
P 1050 3450
F 0 "J7" H 1107 3775 50  0000 C CNN
F 1 "Barrel_Jack" H 1107 3684 50  0000 C CNN
F 2 "Connector_BarrelJack:BarrelJack_CUI_PJ-036AH-SMT_Horizontal" H 1100 3410 50  0001 C CNN
F 3 "~" H 1100 3410 50  0001 C CNN
	1    1050 3450
	1    0    0    -1  
$EndComp
Wire Wire Line
	1350 3550 1450 3550
Wire Wire Line
	1450 3550 1450 3650
$Comp
L power:GND #PWR030
U 1 1 5E5334D6
P 2500 3650
F 0 "#PWR030" H 2500 3400 50  0001 C CNN
F 1 "GND" H 2505 3477 50  0000 C CNN
F 2 "" H 2500 3650 50  0001 C CNN
F 3 "" H 2500 3650 50  0001 C CNN
	1    2500 3650
	1    0    0    -1  
$EndComp
Wire Wire Line
	1350 3350 1750 3350
Wire Wire Line
	1750 3350 1750 3250
$Comp
L power:+12V #PWR029
U 1 1 5E534EED
P 1750 3250
F 0 "#PWR029" H 1750 3100 50  0001 C CNN
F 1 "+12V" H 1765 3423 50  0000 C CNN
F 2 "" H 1750 3250 50  0001 C CNN
F 3 "" H 1750 3250 50  0001 C CNN
	1    1750 3250
	1    0    0    -1  
$EndComp
Wire Wire Line
	1750 3350 2150 3350
Connection ~ 1750 3350
$Comp
L power:+5V #PWR041
U 1 1 5E55CEFA
P 11600 4400
F 0 "#PWR041" H 11600 4250 50  0001 C CNN
F 1 "+5V" H 11615 4573 50  0000 C CNN
F 2 "" H 11600 4400 50  0001 C CNN
F 3 "" H 11600 4400 50  0001 C CNN
	1    11600 4400
	1    0    0    -1  
$EndComp
Wire Wire Line
	11600 4400 11600 4500
Wire Wire Line
	11600 4500 11350 4500
$Comp
L Connector:TestPoint TP5
U 1 1 5E6077CA
P 2500 3250
F 0 "TP5" H 2558 3368 50  0000 L CNN
F 1 "TP_12V" H 2558 3277 50  0000 L CNN
F 2 "TestPoint:TestPoint_Pad_D2.0mm" H 2700 3250 50  0001 C CNN
F 3 "~" H 2700 3250 50  0001 C CNN
	1    2500 3250
	1    0    0    -1  
$EndComp
Wire Wire Line
	2500 3350 2500 3250
$Comp
L power:PWR_FLAG #FLG0101
U 1 1 5F9445F5
P 2150 3350
F 0 "#FLG0101" H 2150 3425 50  0001 C CNN
F 1 "PWR_FLAG" H 2150 3523 50  0000 C CNN
F 2 "" H 2150 3350 50  0001 C CNN
F 3 "~" H 2150 3350 50  0001 C CNN
	1    2150 3350
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG0102
U 1 1 5F95C03D
P 11350 4500
F 0 "#FLG0102" H 11350 4575 50  0001 C CNN
F 1 "PWR_FLAG" H 11350 4673 50  0000 C CNN
F 2 "" H 11350 4500 50  0001 C CNN
F 3 "~" H 11350 4500 50  0001 C CNN
	1    11350 4500
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole_Pad H?
U 1 1 5E9F55D4
P 13400 8150
AR Path="/5E9F55D4" Ref="H?"  Part="1" 
AR Path="/5E50D39B/5E9F55D4" Ref="H1"  Part="1" 
F 0 "H1" H 13500 8199 50  0000 L CNN
F 1 "MountingHole_Pad" H 13500 8108 50  0000 L CNN
F 2 "MountingHole:MountingHole_3.2mm_M3_Pad" H 13400 8150 50  0001 C CNN
F 3 "~" H 13400 8150 50  0001 C CNN
	1    13400 8150
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole_Pad H?
U 1 1 5E9F55DA
P 14400 8150
AR Path="/5E9F55DA" Ref="H?"  Part="1" 
AR Path="/5E50D39B/5E9F55DA" Ref="H3"  Part="1" 
F 0 "H3" H 14500 8199 50  0000 L CNN
F 1 "MountingHole_Pad" H 14500 8108 50  0000 L CNN
F 2 "MountingHole:MountingHole_3.2mm_M3_Pad" H 14400 8150 50  0001 C CNN
F 3 "~" H 14400 8150 50  0001 C CNN
	1    14400 8150
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole_Pad H?
U 1 1 5E9F55E0
P 13400 8650
AR Path="/5E9F55E0" Ref="H?"  Part="1" 
AR Path="/5E50D39B/5E9F55E0" Ref="H2"  Part="1" 
F 0 "H2" H 13500 8699 50  0000 L CNN
F 1 "MountingHole_Pad" H 13500 8608 50  0000 L CNN
F 2 "MountingHole:MountingHole_3.2mm_M3_Pad" H 13400 8650 50  0001 C CNN
F 3 "~" H 13400 8650 50  0001 C CNN
	1    13400 8650
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole_Pad H?
U 1 1 5E9F55E6
P 14400 8650
AR Path="/5E9F55E6" Ref="H?"  Part="1" 
AR Path="/5E50D39B/5E9F55E6" Ref="H4"  Part="1" 
F 0 "H4" H 14500 8699 50  0000 L CNN
F 1 "MountingHole_Pad" H 14500 8608 50  0000 L CNN
F 2 "MountingHole:MountingHole_3.2mm_M3_Pad" H 14400 8650 50  0001 C CNN
F 3 "~" H 14400 8650 50  0001 C CNN
	1    14400 8650
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5E9F55EC
P 13400 8250
AR Path="/5E9F55EC" Ref="#PWR?"  Part="1" 
AR Path="/5E50D39B/5E9F55EC" Ref="#PWR0176"  Part="1" 
F 0 "#PWR0176" H 13400 8000 50  0001 C CNN
F 1 "GND" H 13405 8077 50  0000 C CNN
F 2 "" H 13400 8250 50  0001 C CNN
F 3 "" H 13400 8250 50  0001 C CNN
	1    13400 8250
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5E9F55F2
P 14400 8250
AR Path="/5E9F55F2" Ref="#PWR?"  Part="1" 
AR Path="/5E50D39B/5E9F55F2" Ref="#PWR0180"  Part="1" 
F 0 "#PWR0180" H 14400 8000 50  0001 C CNN
F 1 "GND" H 14405 8077 50  0000 C CNN
F 2 "" H 14400 8250 50  0001 C CNN
F 3 "" H 14400 8250 50  0001 C CNN
	1    14400 8250
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5E9F55F8
P 13400 8750
AR Path="/5E9F55F8" Ref="#PWR?"  Part="1" 
AR Path="/5E50D39B/5E9F55F8" Ref="#PWR0181"  Part="1" 
F 0 "#PWR0181" H 13400 8500 50  0001 C CNN
F 1 "GND" H 13405 8577 50  0000 C CNN
F 2 "" H 13400 8750 50  0001 C CNN
F 3 "" H 13400 8750 50  0001 C CNN
	1    13400 8750
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5E9F55FE
P 14400 8750
AR Path="/5E9F55FE" Ref="#PWR?"  Part="1" 
AR Path="/5E50D39B/5E9F55FE" Ref="#PWR0184"  Part="1" 
F 0 "#PWR0184" H 14400 8500 50  0001 C CNN
F 1 "GND" H 14405 8577 50  0000 C CNN
F 2 "" H 14400 8750 50  0001 C CNN
F 3 "" H 14400 8750 50  0001 C CNN
	1    14400 8750
	1    0    0    -1  
$EndComp
$Comp
L SPLA:ST1S10PHR U7
U 1 1 5EA0D05E
P 6000 3750
F 0 "U7" H 6000 4300 50  0000 C CNN
F 1 "ST1S10PHR" H 6000 3200 50  0000 C CNN
F 2 "SPLA:ST_PowerSO-8EP_4x5mm_P1.27mm_EP3.5x2.6mm" H 6000 3100 50  0001 C CNN
F 3 "" H 6000 3800 50  0001 C CNN
	1    6000 3750
	1    0    0    -1  
$EndComp
$Comp
L SPLA:ST1S10PHR U8
U 1 1 5EA0D61F
P 6000 5800
F 0 "U8" H 6000 6350 50  0000 C CNN
F 1 "ST1S10PHR" H 6000 5250 50  0000 C CNN
F 2 "SPLA:ST_PowerSO-8EP_4x5mm_P1.27mm_EP3.5x2.6mm" H 6000 5150 50  0001 C CNN
F 3 "" H 6000 5850 50  0001 C CNN
	1    6000 5800
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR032
U 1 1 5EA0E043
P 6500 4550
F 0 "#PWR032" H 6500 4300 50  0001 C CNN
F 1 "GND" H 6505 4377 50  0000 C CNN
F 2 "" H 6500 4550 50  0001 C CNN
F 3 "" H 6500 4550 50  0001 C CNN
	1    6500 4550
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R88
U 1 1 5EA0EA27
P 5150 4350
F 0 "R88" H 5209 4396 50  0000 L CNN
F 1 "0" H 5209 4305 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 5150 4350 50  0001 C CNN
F 3 "~" H 5150 4350 50  0001 C CNN
	1    5150 4350
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR016
U 1 1 5EA0F2CC
P 5150 4550
F 0 "#PWR016" H 5150 4300 50  0001 C CNN
F 1 "GND" H 5155 4377 50  0000 C CNN
F 2 "" H 5150 4550 50  0001 C CNN
F 3 "" H 5150 4550 50  0001 C CNN
	1    5150 4550
	1    0    0    -1  
$EndComp
Text Notes 5000 4400 2    50   ~ 0
SYNC = use internal 900kHz oscillator
Connection ~ 2150 3350
Wire Wire Line
	2150 3350 2500 3350
$Comp
L Device:R_Small R87
U 1 1 5EA1301A
P 5150 3550
F 0 "R87" H 5209 3596 50  0000 L CNN
F 1 "0" H 5209 3505 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 5150 3550 50  0001 C CNN
F 3 "~" H 5150 3550 50  0001 C CNN
	1    5150 3550
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C83
U 1 1 5EA1356A
P 4650 3550
F 0 "C83" H 4742 3596 50  0000 L CNN
F 1 "4.7uF" H 4742 3505 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 4650 3550 50  0001 C CNN
F 3 "~" H 4650 3550 50  0001 C CNN
	1    4650 3550
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C81
U 1 1 5EA13C74
P 4150 3550
F 0 "C81" H 4242 3596 50  0000 L CNN
F 1 "10uF" H 4242 3505 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 4150 3550 50  0001 C CNN
F 3 "~" H 4150 3550 50  0001 C CNN
	1    4150 3550
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C84
U 1 1 5EA14438
P 7550 3550
F 0 "C84" H 7642 3596 50  0000 L CNN
F 1 "4.7nF" H 7642 3505 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 7550 3550 50  0001 C CNN
F 3 "~" H 7550 3550 50  0001 C CNN
	1    7550 3550
	1    0    0    -1  
$EndComp
$Comp
L Device:L L1
U 1 1 5EA1BECB
P 6700 3350
F 0 "L1" V 6890 3350 50  0000 C CNN
F 1 "3.3uH" V 6799 3350 50  0000 C CNN
F 2 "Inductor_SMD:L_Vishay_IHLP-2020" H 6700 3350 50  0001 C CNN
F 3 "~" H 6700 3350 50  0001 C CNN
	1    6700 3350
	0    -1   -1   0   
$EndComp
Wire Wire Line
	6500 3950 6500 4050
$Comp
L Device:R_Small R81
U 1 1 5EA1F15C
P 7000 3550
F 0 "R81" H 7059 3596 50  0000 L CNN
F 1 "5.23k, 1%" H 7059 3505 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 7000 3550 50  0001 C CNN
F 3 "~" H 7000 3550 50  0001 C CNN
	1    7000 3550
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R82
U 1 1 5EA1F84C
P 7000 3950
F 0 "R82" H 7059 3996 50  0000 L CNN
F 1 "1k, 1%" H 7059 3905 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 7000 3950 50  0001 C CNN
F 3 "~" H 7000 3950 50  0001 C CNN
	1    7000 3950
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C89
U 1 1 5EA1FD64
P 8050 3550
F 0 "C89" H 8142 3596 50  0000 L CNN
F 1 "0.1uF" H 8142 3505 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 8050 3550 50  0001 C CNN
F 3 "~" H 8050 3550 50  0001 C CNN
	1    8050 3550
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C82
U 1 1 5EA2074A
P 8500 3550
F 0 "C82" H 8592 3596 50  0000 L CNN
F 1 "22uF" H 8592 3505 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 8500 3550 50  0001 C CNN
F 3 "~" H 8500 3550 50  0001 C CNN
	1    8500 3550
	1    0    0    -1  
$EndComp
Wire Wire Line
	5600 4150 5150 4150
Wire Wire Line
	5150 4150 5150 4250
Text Notes 7050 3100 0    50   ~ 0
V_OUT = ((0.8V / 1k) * 5.23k) + 0.8V = 4.984V
Wire Wire Line
	6400 3950 6500 3950
Wire Wire Line
	6500 4050 6400 4050
Connection ~ 6500 4050
Wire Wire Line
	6500 4050 6500 4150
Wire Wire Line
	6400 4150 6500 4150
Connection ~ 6500 4150
Wire Wire Line
	6500 4150 6500 4550
Wire Wire Line
	5600 3550 5500 3550
Wire Wire Line
	5500 3550 5500 3350
Wire Wire Line
	5500 3350 5600 3350
Connection ~ 5500 3350
Wire Wire Line
	5600 3950 5150 3950
Wire Wire Line
	5150 3950 5150 3650
Wire Wire Line
	5150 3350 5150 3450
Wire Wire Line
	6400 3350 6550 3350
Wire Wire Line
	6850 3350 7000 3350
Wire Wire Line
	7000 3350 7000 3450
Wire Wire Line
	7000 3650 7000 3750
Wire Wire Line
	7000 3750 6500 3750
Wire Wire Line
	6500 3750 6500 3550
Wire Wire Line
	6500 3550 6400 3550
Wire Wire Line
	7000 3350 7550 3350
Wire Wire Line
	7550 3350 7550 3450
Connection ~ 7000 3350
Wire Wire Line
	7550 3650 7550 3750
Wire Wire Line
	7000 4050 7000 4150
$Comp
L power:GND #PWR034
U 1 1 5EA49A7C
P 7000 4150
F 0 "#PWR034" H 7000 3900 50  0001 C CNN
F 1 "GND" H 7005 3977 50  0000 C CNN
F 2 "" H 7000 4150 50  0001 C CNN
F 3 "" H 7000 4150 50  0001 C CNN
	1    7000 4150
	1    0    0    -1  
$EndComp
Wire Wire Line
	7000 3750 7550 3750
Connection ~ 7000 3750
Wire Wire Line
	4150 3350 4150 3450
Connection ~ 5150 3350
Wire Wire Line
	4650 3450 4650 3350
Connection ~ 4650 3350
Wire Wire Line
	4650 3350 4150 3350
Wire Wire Line
	4650 3650 4650 3750
Wire Wire Line
	4650 3750 4150 3750
Wire Wire Line
	4150 3750 4150 3650
$Comp
L power:GND #PWR012
U 1 1 5EA6ACF5
P 4150 3850
F 0 "#PWR012" H 4150 3600 50  0001 C CNN
F 1 "GND" H 4155 3677 50  0000 C CNN
F 2 "" H 4150 3850 50  0001 C CNN
F 3 "" H 4150 3850 50  0001 C CNN
	1    4150 3850
	1    0    0    -1  
$EndComp
Connection ~ 4150 3750
Wire Wire Line
	8050 3650 8050 3750
Wire Wire Line
	8050 3750 8500 3750
Wire Wire Line
	8500 3650 8500 3750
Connection ~ 8500 3750
Connection ~ 7550 3350
Wire Wire Line
	8050 3450 8050 3350
Connection ~ 8050 3350
Wire Wire Line
	8050 3350 7550 3350
Wire Wire Line
	8500 3450 8500 3350
Connection ~ 8500 3350
Wire Wire Line
	8500 3350 8050 3350
Connection ~ 4150 3350
Wire Wire Line
	5150 4450 5150 4550
Text Notes 4400 4100 0    50   ~ 0
~INH~ = Always On
Wire Wire Line
	2500 3350 3400 3350
Connection ~ 2500 3350
Wire Wire Line
	4150 3850 4150 3750
$Comp
L power:GND #PWR036
U 1 1 5EAA1CE6
P 8500 3850
F 0 "#PWR036" H 8500 3600 50  0001 C CNN
F 1 "GND" H 8505 3677 50  0000 C CNN
F 2 "" H 8500 3850 50  0001 C CNN
F 3 "" H 8500 3850 50  0001 C CNN
	1    8500 3850
	1    0    0    -1  
$EndComp
Wire Wire Line
	8500 3850 8500 3750
$Comp
L power:GND #PWR033
U 1 1 5EABC777
P 6500 6600
F 0 "#PWR033" H 6500 6350 50  0001 C CNN
F 1 "GND" H 6505 6427 50  0000 C CNN
F 2 "" H 6500 6600 50  0001 C CNN
F 3 "" H 6500 6600 50  0001 C CNN
	1    6500 6600
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R98
U 1 1 5EABC781
P 5150 6400
F 0 "R98" H 5209 6446 50  0000 L CNN
F 1 "0" H 5209 6355 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 5150 6400 50  0001 C CNN
F 3 "~" H 5150 6400 50  0001 C CNN
	1    5150 6400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR031
U 1 1 5EABC78B
P 5150 6600
F 0 "#PWR031" H 5150 6350 50  0001 C CNN
F 1 "GND" H 5155 6427 50  0000 C CNN
F 2 "" H 5150 6600 50  0001 C CNN
F 3 "" H 5150 6600 50  0001 C CNN
	1    5150 6600
	1    0    0    -1  
$EndComp
Text Notes 5000 6450 2    50   ~ 0
SYNC = use internal 900kHz oscillator
$Comp
L Device:R_Small R97
U 1 1 5EABC7A0
P 5150 5600
F 0 "R97" H 5209 5646 50  0000 L CNN
F 1 "0" H 5209 5555 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 5150 5600 50  0001 C CNN
F 3 "~" H 5150 5600 50  0001 C CNN
	1    5150 5600
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C93
U 1 1 5EABC7AA
P 4650 5600
F 0 "C93" H 4742 5646 50  0000 L CNN
F 1 "4.7uF" H 4742 5555 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 4650 5600 50  0001 C CNN
F 3 "~" H 4650 5600 50  0001 C CNN
	1    4650 5600
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C91
U 1 1 5EABC7B4
P 4150 5600
F 0 "C91" H 4242 5646 50  0000 L CNN
F 1 "10uF" H 4242 5555 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 4150 5600 50  0001 C CNN
F 3 "~" H 4150 5600 50  0001 C CNN
	1    4150 5600
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C94
U 1 1 5EABC7BE
P 7550 5600
F 0 "C94" H 7642 5646 50  0000 L CNN
F 1 "4.7nF" H 7642 5555 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 7550 5600 50  0001 C CNN
F 3 "~" H 7550 5600 50  0001 C CNN
	1    7550 5600
	1    0    0    -1  
$EndComp
$Comp
L Device:L L2
U 1 1 5EABC7C8
P 6700 5400
F 0 "L2" V 6890 5400 50  0000 C CNN
F 1 "3.3uH" V 6799 5400 50  0000 C CNN
F 2 "Inductor_SMD:L_Vishay_IHLP-2020" H 6700 5400 50  0001 C CNN
F 3 "~" H 6700 5400 50  0001 C CNN
	1    6700 5400
	0    -1   -1   0   
$EndComp
Wire Wire Line
	6500 6000 6500 6100
$Comp
L Device:R_Small R91
U 1 1 5EABC7D3
P 7000 5600
F 0 "R91" H 7059 5646 50  0000 L CNN
F 1 "3.09k, 1%" H 7059 5555 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 7000 5600 50  0001 C CNN
F 3 "~" H 7000 5600 50  0001 C CNN
	1    7000 5600
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R92
U 1 1 5EABC7DD
P 7000 6000
F 0 "R92" H 7059 6046 50  0000 L CNN
F 1 "1k, 1%" H 7059 5955 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 7000 6000 50  0001 C CNN
F 3 "~" H 7000 6000 50  0001 C CNN
	1    7000 6000
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C99
U 1 1 5EABC7E7
P 8050 5600
F 0 "C99" H 8142 5646 50  0000 L CNN
F 1 "0.1uF" H 8142 5555 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 8050 5600 50  0001 C CNN
F 3 "~" H 8050 5600 50  0001 C CNN
	1    8050 5600
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C92
U 1 1 5EABC7F1
P 8500 5600
F 0 "C92" H 8592 5646 50  0000 L CNN
F 1 "22uF" H 8592 5555 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 8500 5600 50  0001 C CNN
F 3 "~" H 8500 5600 50  0001 C CNN
	1    8500 5600
	1    0    0    -1  
$EndComp
Wire Wire Line
	5600 6200 5150 6200
Wire Wire Line
	5150 6200 5150 6300
Text Notes 7050 5150 0    50   ~ 0
V_OUT = ((0.8V / 1k) * 3.09k) + 0.8V = 3.272V
Wire Wire Line
	6400 6000 6500 6000
Wire Wire Line
	6500 6100 6400 6100
Connection ~ 6500 6100
Wire Wire Line
	6500 6100 6500 6200
Wire Wire Line
	6400 6200 6500 6200
Connection ~ 6500 6200
Wire Wire Line
	6500 6200 6500 6600
Wire Wire Line
	5600 5600 5500 5600
Wire Wire Line
	5500 5600 5500 5400
Wire Wire Line
	5500 5400 5600 5400
Connection ~ 5500 5400
Wire Wire Line
	5600 6000 5150 6000
Wire Wire Line
	5150 6000 5150 5700
Wire Wire Line
	5150 5400 5150 5500
Wire Wire Line
	6400 5400 6550 5400
Wire Wire Line
	6500 5800 6500 5600
Wire Wire Line
	6500 5600 6400 5600
Wire Wire Line
	7000 5400 7000 5500
Wire Wire Line
	7000 5700 7000 5800
Wire Wire Line
	7000 6100 7000 6200
$Comp
L power:GND #PWR035
U 1 1 5EABC830
P 7000 6200
F 0 "#PWR035" H 7000 5950 50  0001 C CNN
F 1 "GND" H 7005 6027 50  0000 C CNN
F 2 "" H 7000 6200 50  0001 C CNN
F 3 "" H 7000 6200 50  0001 C CNN
	1    7000 6200
	1    0    0    -1  
$EndComp
Connection ~ 7000 5800
Wire Wire Line
	7000 5800 7000 5900
Wire Wire Line
	5150 5400 4650 5400
Wire Wire Line
	4150 5400 4150 5500
Connection ~ 5150 5400
Wire Wire Line
	4650 5500 4650 5400
Connection ~ 4650 5400
Wire Wire Line
	4650 5400 4150 5400
Wire Wire Line
	4650 5700 4650 5800
Wire Wire Line
	4650 5800 4150 5800
Wire Wire Line
	4150 5800 4150 5700
$Comp
L power:GND #PWR013
U 1 1 5EABC847
P 4150 5900
F 0 "#PWR013" H 4150 5650 50  0001 C CNN
F 1 "GND" H 4155 5727 50  0000 C CNN
F 2 "" H 4150 5900 50  0001 C CNN
F 3 "" H 4150 5900 50  0001 C CNN
	1    4150 5900
	1    0    0    -1  
$EndComp
Connection ~ 4150 5800
Wire Wire Line
	8050 5700 8050 5800
Wire Wire Line
	8500 5700 8500 5800
Connection ~ 8500 5800
Connection ~ 7000 5400
Wire Wire Line
	8050 5500 8050 5400
Connection ~ 8050 5400
Wire Wire Line
	8050 5400 7550 5400
Wire Wire Line
	8500 5500 8500 5400
Connection ~ 8500 5400
Wire Wire Line
	8500 5400 8050 5400
Connection ~ 4150 5400
Wire Wire Line
	5150 6500 5150 6600
Text Notes 4400 6150 0    50   ~ 0
~INH~ = Always On
Wire Wire Line
	4150 5900 4150 5800
$Comp
L power:GND #PWR037
U 1 1 5EABC867
P 8500 5900
F 0 "#PWR037" H 8500 5650 50  0001 C CNN
F 1 "GND" H 8505 5727 50  0000 C CNN
F 2 "" H 8500 5900 50  0001 C CNN
F 3 "" H 8500 5900 50  0001 C CNN
	1    8500 5900
	1    0    0    -1  
$EndComp
Wire Wire Line
	8500 5900 8500 5800
Wire Wire Line
	3400 3350 3400 5400
Connection ~ 3400 3350
Wire Wire Line
	3400 3350 4150 3350
Wire Wire Line
	3400 5400 4150 5400
Text Label 2850 3350 0    50   ~ 0
PWR_12V
Text Label 8700 3350 0    50   ~ 0
PWR_PRE_5V
Text Label 8700 5400 0    50   ~ 0
PWR_PRE_3V3
Wire Wire Line
	9800 4700 10350 4700
Text Label 5200 3950 0    50   ~ 0
~INH~_5V
Text Label 5200 6000 0    50   ~ 0
~INH~_3V3
Text Label 5200 4150 0    50   ~ 0
SYNC_5V
Text Label 5200 6200 0    50   ~ 0
SYNC_3V3
Text Label 6600 3750 0    50   ~ 0
VFB_5V
Text Label 6600 5800 0    50   ~ 0
VFB_3V3
Text Label 6500 3350 1    50   ~ 0
SW_5V
Text Label 6500 5400 1    50   ~ 0
SW_3V3
Wire Wire Line
	5150 3350 5500 3350
Wire Wire Line
	4650 3350 5150 3350
Wire Wire Line
	5150 5400 5500 5400
Wire Wire Line
	7000 3850 7000 3750
Wire Wire Line
	8500 3350 9350 3350
Wire Wire Line
	6500 5800 7000 5800
Wire Wire Line
	6850 5400 7000 5400
Wire Wire Line
	7550 5500 7550 5400
Connection ~ 7550 5400
Wire Wire Line
	7550 5400 7000 5400
Wire Wire Line
	7550 5700 7550 5800
Wire Wire Line
	7550 5800 7000 5800
Wire Wire Line
	8050 5800 8500 5800
Wire Wire Line
	8500 5400 9350 5400
Wire Wire Line
	10350 4900 10350 4800
Connection ~ 10350 4700
Connection ~ 10350 4800
Wire Wire Line
	10350 4800 10350 4700
$Comp
L Regulator_Linear:TLV73311PDBV U14
U 1 1 5EA1661B
P 13200 6450
F 0 "U14" H 13200 6792 50  0000 C CNN
F 1 "TLV73311PDBV" H 13200 6701 50  0000 C CNN
F 2 "Package_TO_SOT_SMD:SOT-23-5" H 13200 6775 50  0001 C CIN
F 3 "http://www.ti.com/lit/ds/symlink/tlv733p.pdf" H 13200 6450 50  0001 C CNN
	1    13200 6450
	1    0    0    -1  
$EndComp
$Comp
L Regulator_Linear:TLV73325PDBV U9
U 1 1 5EA1703F
P 13200 5200
F 0 "U9" H 13200 5542 50  0000 C CNN
F 1 "TLV73325PDBV" H 13200 5451 50  0000 C CNN
F 2 "Package_TO_SOT_SMD:SOT-23-5" H 13200 5525 50  0001 C CIN
F 3 "http://www.ti.com/lit/ds/symlink/tlv733p.pdf" H 13200 5200 50  0001 C CNN
	1    13200 5200
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C42
U 1 1 5EA1E7DB
P 13600 6550
F 0 "C42" H 13692 6596 50  0000 L CNN
F 1 "0.1uF" H 13692 6505 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 13600 6550 50  0001 C CNN
F 3 "~" H 13600 6550 50  0001 C CNN
	1    13600 6550
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R33
U 1 1 5EA230D5
P 12050 5250
F 0 "R33" H 12109 5296 50  0000 L CNN
F 1 "0" H 12109 5205 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 12050 5250 50  0001 C CNN
F 3 "~" H 12050 5250 50  0001 C CNN
	1    12050 5250
	1    0    0    -1  
$EndComp
Wire Wire Line
	12900 5100 12050 5100
Wire Wire Line
	12050 5150 12050 5100
Wire Wire Line
	12050 5350 12050 5400
Wire Wire Line
	12050 5400 12900 5400
Wire Wire Line
	12900 5400 12900 5200
$Comp
L Device:R_Small R34
U 1 1 5EA25E8A
P 12050 6500
F 0 "R34" H 12109 6546 50  0000 L CNN
F 1 "0" H 12109 6455 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 12050 6500 50  0001 C CNN
F 3 "~" H 12050 6500 50  0001 C CNN
	1    12050 6500
	1    0    0    -1  
$EndComp
Wire Wire Line
	12900 6350 12050 6350
Wire Wire Line
	12050 6400 12050 6350
Connection ~ 12050 6350
Wire Wire Line
	12050 6600 12050 6650
Wire Wire Line
	12050 6650 12900 6650
Wire Wire Line
	12900 6650 12900 6450
Wire Wire Line
	13500 6350 13600 6350
Wire Wire Line
	13600 6450 13600 6350
Wire Wire Line
	13600 6650 13600 6750
Wire Wire Line
	13600 6750 13400 6750
$Comp
L power:GND #PWR067
U 1 1 5EA2A584
P 13400 6750
F 0 "#PWR067" H 13400 6500 50  0001 C CNN
F 1 "GND" H 13405 6577 50  0000 C CNN
F 2 "" H 13400 6750 50  0001 C CNN
F 3 "" H 13400 6750 50  0001 C CNN
	1    13400 6750
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C41
U 1 1 5EA2A86D
P 13600 5300
F 0 "C41" H 13692 5346 50  0000 L CNN
F 1 "0.1uF" H 13692 5255 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 13600 5300 50  0001 C CNN
F 3 "~" H 13600 5300 50  0001 C CNN
	1    13600 5300
	1    0    0    -1  
$EndComp
Wire Wire Line
	13500 5100 13600 5100
Wire Wire Line
	13600 5200 13600 5100
Wire Wire Line
	13600 5400 13600 5500
$Comp
L power:GND #PWR038
U 1 1 5EA2B8C5
P 13400 5500
F 0 "#PWR038" H 13400 5250 50  0001 C CNN
F 1 "GND" H 13405 5327 50  0000 C CNN
F 2 "" H 13400 5500 50  0001 C CNN
F 3 "" H 13400 5500 50  0001 C CNN
	1    13400 5500
	1    0    0    -1  
$EndComp
Connection ~ 13400 5500
Wire Wire Line
	13400 5500 13200 5500
Wire Wire Line
	13400 5500 13600 5500
Connection ~ 13400 6750
Wire Wire Line
	13400 6750 13200 6750
Connection ~ 12050 5100
Wire Wire Line
	15350 5850 15350 5750
Wire Wire Line
	15850 5850 15850 5950
$Comp
L power:+1V1 #PWR044
U 1 1 5E56FFF6
P 15850 5850
F 0 "#PWR044" H 15850 5700 50  0001 C CNN
F 1 "+1V1" H 15865 6023 50  0000 C CNN
F 2 "" H 15850 5850 50  0001 C CNN
F 3 "" H 15850 5850 50  0001 C CNN
	1    15850 5850
	1    0    0    -1  
$EndComp
$Comp
L power:+2V5 #PWR043
U 1 1 5E56BE1E
P 15350 5750
F 0 "#PWR043" H 15350 5600 50  0001 C CNN
F 1 "+2V5" H 15365 5923 50  0000 C CNN
F 2 "" H 15350 5750 50  0001 C CNN
F 3 "" H 15350 5750 50  0001 C CNN
	1    15350 5750
	1    0    0    -1  
$EndComp
Wire Wire Line
	11500 5100 11850 5100
Wire Wire Line
	11400 6350 11850 6350
Text Label 12250 5100 0    50   ~ 0
PWR_2V5_IN
Text Label 12250 6350 0    50   ~ 0
PWR_1V1_IN
Wire Wire Line
	10350 4700 10450 4700
Wire Wire Line
	10350 4800 10450 4800
Wire Wire Line
	10350 4900 10450 4900
Wire Wire Line
	10350 4900 10350 5000
Wire Wire Line
	10350 5000 10450 5000
Connection ~ 10350 4900
$Comp
L Connector_Generic:Conn_02x08_Odd_Even J12
U 1 1 5E5D4B8F
P 10750 4700
F 0 "J12" H 10800 5250 50  0000 C CNN
F 1 "J_POWER" H 10800 5150 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_2x08_P2.54mm_Vertical" H 10750 4700 50  0001 C CNN
F 3 "~" H 10750 4700 50  0001 C CNN
	1    10750 4700
	-1   0    0    -1  
$EndComp
Text Label 12250 6650 0    50   ~ 0
PWR_1V1_EN
Text Label 12250 5400 0    50   ~ 0
PWR_2V5_EN
Wire Wire Line
	9800 5400 9800 4700
Wire Wire Line
	11050 5000 11050 4700
Wire Wire Line
	10950 4800 11500 4800
Wire Wire Line
	10950 4900 11400 4900
Wire Wire Line
	11050 4700 10950 4700
Connection ~ 11050 4700
Wire Wire Line
	10950 5000 11050 5000
Wire Wire Line
	11400 4900 11400 6350
Wire Wire Line
	11500 4800 11500 5100
Wire Wire Line
	11850 4700 11050 4700
Connection ~ 11850 4700
$Comp
L power:PWR_FLAG #FLG0103
U 1 1 5F95CD6F
P 11850 4700
F 0 "#FLG0103" H 11850 4775 50  0001 C CNN
F 1 "PWR_FLAG" H 11850 4873 50  0000 C CNN
F 2 "" H 11850 4700 50  0001 C CNN
F 3 "~" H 11850 4700 50  0001 C CNN
	1    11850 4700
	1    0    0    -1  
$EndComp
Wire Wire Line
	12100 4700 11850 4700
Wire Wire Line
	12100 4600 12100 4700
$Comp
L power:+3V3 #PWR042
U 1 1 5E561012
P 12100 4600
F 0 "#PWR042" H 12100 4450 50  0001 C CNN
F 1 "+3V3" H 12115 4773 50  0000 C CNN
F 2 "" H 12100 4600 50  0001 C CNN
F 3 "" H 12100 4600 50  0001 C CNN
	1    12100 4600
	1    0    0    -1  
$EndComp
Wire Wire Line
	10250 4600 10450 4600
Wire Wire Line
	10250 4600 10250 5100
Connection ~ 10250 4600
Wire Wire Line
	10950 4600 11150 4600
Connection ~ 11150 4600
$Comp
L power:GND #PWR0185
U 1 1 5EA663D8
P 10250 5200
F 0 "#PWR0185" H 10250 4950 50  0001 C CNN
F 1 "GND" H 10255 5027 50  0000 C CNN
F 2 "" H 10250 5200 50  0001 C CNN
F 3 "" H 10250 5200 50  0001 C CNN
	1    10250 5200
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0186
U 1 1 5EA66B84
P 11150 5200
F 0 "#PWR0186" H 11150 4950 50  0001 C CNN
F 1 "GND" H 11155 5027 50  0000 C CNN
F 2 "" H 11150 5200 50  0001 C CNN
F 3 "" H 11150 5200 50  0001 C CNN
	1    11150 5200
	1    0    0    -1  
$EndComp
Wire Wire Line
	10250 4400 10450 4400
Wire Wire Line
	10250 4400 10250 4600
Wire Wire Line
	11150 4400 10950 4400
Wire Wire Line
	11150 4400 11150 4600
Wire Wire Line
	9800 4500 10450 4500
Wire Wire Line
	9800 3350 9800 4500
Wire Wire Line
	11350 4500 10950 4500
Connection ~ 11350 4500
Wire Wire Line
	11150 4600 11150 5100
Wire Wire Line
	10950 5100 11150 5100
Connection ~ 11150 5100
Wire Wire Line
	11150 5100 11150 5200
Wire Wire Line
	10450 5100 10250 5100
Wire Wire Line
	10250 5200 10250 5100
Connection ~ 10250 5100
$Comp
L Connector:TestPoint TP6
U 1 1 5EAFCBB1
P 2500 3650
F 0 "TP6" H 2558 3768 50  0000 L CNN
F 1 "TP_GND" H 2558 3677 50  0000 L CNN
F 2 "TestPoint:TestPoint_Pad_D2.0mm" H 2700 3650 50  0001 C CNN
F 3 "~" H 2700 3650 50  0001 C CNN
	1    2500 3650
	1    0    0    -1  
$EndComp
Wire Wire Line
	2500 3650 1450 3650
Connection ~ 2500 3650
$Comp
L Device:LED D?
U 1 1 5EB36971
P 9350 3600
AR Path="/5E4F712F/5EB36971" Ref="D?"  Part="1" 
AR Path="/5E50D39B/5EB36971" Ref="D2"  Part="1" 
F 0 "D2" V 9389 3483 50  0000 R CNN
F 1 "LED" V 9298 3483 50  0000 R CNN
F 2 "LED_SMD:LED_0805_2012Metric" H 9350 3600 50  0001 C CNN
F 3 "~" H 9350 3600 50  0001 C CNN
	1    9350 3600
	0    -1   -1   0   
$EndComp
$Comp
L Device:R_Small R?
U 1 1 5EB36977
P 9350 3950
AR Path="/5E4F712F/5EB36977" Ref="R?"  Part="1" 
AR Path="/5E50D39B/5EB36977" Ref="R86"  Part="1" 
F 0 "R86" H 9409 3996 50  0000 L CNN
F 1 "750" H 9409 3905 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 9350 3950 50  0001 C CNN
F 3 "~" H 9350 3950 50  0001 C CNN
	1    9350 3950
	1    0    0    -1  
$EndComp
Wire Wire Line
	9350 3750 9350 3850
Wire Wire Line
	9350 4050 9350 4150
$Comp
L power:GND #PWR?
U 1 1 5EB3697F
P 9350 4150
AR Path="/5E4F712F/5EB3697F" Ref="#PWR?"  Part="1" 
AR Path="/5E50D39B/5EB3697F" Ref="#PWR0190"  Part="1" 
F 0 "#PWR0190" H 9350 3900 50  0001 C CNN
F 1 "GND" H 9355 3977 50  0000 C CNN
F 2 "" H 9350 4150 50  0001 C CNN
F 3 "" H 9350 4150 50  0001 C CNN
	1    9350 4150
	1    0    0    -1  
$EndComp
Text Notes 8350 4550 0    50   ~ 0
(5.0V - 2.0V) / 4mA = 750 ohm
Wire Wire Line
	9350 3350 9350 3450
$Comp
L Device:LED D?
U 1 1 5EB3D482
P 9350 5650
AR Path="/5E4F712F/5EB3D482" Ref="D?"  Part="1" 
AR Path="/5E50D39B/5EB3D482" Ref="D1"  Part="1" 
F 0 "D1" V 9389 5533 50  0000 R CNN
F 1 "LED" V 9298 5533 50  0000 R CNN
F 2 "LED_SMD:LED_0805_2012Metric" H 9350 5650 50  0001 C CNN
F 3 "~" H 9350 5650 50  0001 C CNN
	1    9350 5650
	0    -1   -1   0   
$EndComp
$Comp
L Device:R_Small R?
U 1 1 5EB3D48C
P 9350 6000
AR Path="/5E4F712F/5EB3D48C" Ref="R?"  Part="1" 
AR Path="/5E50D39B/5EB3D48C" Ref="R96"  Part="1" 
F 0 "R96" H 9409 6046 50  0000 L CNN
F 1 "330" H 9409 5955 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 9350 6000 50  0001 C CNN
F 3 "~" H 9350 6000 50  0001 C CNN
	1    9350 6000
	1    0    0    -1  
$EndComp
Wire Wire Line
	9350 5800 9350 5900
Wire Wire Line
	9350 6100 9350 6200
$Comp
L power:GND #PWR?
U 1 1 5EB3D498
P 9350 6200
AR Path="/5E4F712F/5EB3D498" Ref="#PWR?"  Part="1" 
AR Path="/5E50D39B/5EB3D498" Ref="#PWR0191"  Part="1" 
F 0 "#PWR0191" H 9350 5950 50  0001 C CNN
F 1 "GND" H 9355 6027 50  0000 C CNN
F 2 "" H 9350 6200 50  0001 C CNN
F 3 "" H 9350 6200 50  0001 C CNN
	1    9350 6200
	1    0    0    -1  
$EndComp
Text Notes 8350 6600 0    50   ~ 0
(3.3V - 2.0V) / 4mA = 325 ohm
Wire Wire Line
	9350 5400 9350 5500
Connection ~ 9350 5400
Wire Wire Line
	9350 5400 9800 5400
Connection ~ 9350 3350
Wire Wire Line
	9350 3350 9800 3350
$Comp
L power:PWR_FLAG #FLG0104
U 1 1 5ED3DBC2
P 11850 5100
F 0 "#FLG0104" H 11850 5175 50  0001 C CNN
F 1 "PWR_FLAG" H 11850 5273 50  0000 C CNN
F 2 "" H 11850 5100 50  0001 C CNN
F 3 "~" H 11850 5100 50  0001 C CNN
	1    11850 5100
	1    0    0    -1  
$EndComp
Connection ~ 11850 5100
Wire Wire Line
	11850 5100 12050 5100
$Comp
L power:PWR_FLAG #FLG0105
U 1 1 5ED44CD4
P 11850 6350
F 0 "#FLG0105" H 11850 6425 50  0001 C CNN
F 1 "PWR_FLAG" H 11850 6523 50  0000 C CNN
F 2 "" H 11850 6350 50  0001 C CNN
F 3 "~" H 11850 6350 50  0001 C CNN
	1    11850 6350
	1    0    0    -1  
$EndComp
Connection ~ 11850 6350
Wire Wire Line
	11850 6350 12050 6350
$Comp
L Connector_Generic:Conn_02x02_Odd_Even J4
U 1 1 5F14B7D8
P 14600 5950
F 0 "J4" H 14650 5625 50  0000 C CNN
F 1 "J_POWER2" H 14650 5716 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_2x02_P2.54mm_Vertical" H 14600 5950 50  0001 C CNN
F 3 "~" H 14600 5950 50  0001 C CNN
	1    14600 5950
	1    0    0    1   
$EndComp
Wire Wire Line
	13600 5100 14300 5100
Wire Wire Line
	14300 5100 14300 5850
Wire Wire Line
	14300 5850 14400 5850
Connection ~ 13600 5100
Wire Wire Line
	14400 5950 14300 5950
Wire Wire Line
	14300 5950 14300 6350
Wire Wire Line
	14300 6350 13600 6350
Connection ~ 13600 6350
$Comp
L power:PWR_FLAG #FLG0106
U 1 1 5F180F83
P 15100 5850
F 0 "#FLG0106" H 15100 5925 50  0001 C CNN
F 1 "PWR_FLAG" H 15100 6023 50  0000 C CNN
F 2 "" H 15100 5850 50  0001 C CNN
F 3 "~" H 15100 5850 50  0001 C CNN
	1    15100 5850
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG0107
U 1 1 5F1887AE
P 15600 5950
F 0 "#FLG0107" H 15600 6025 50  0001 C CNN
F 1 "PWR_FLAG" H 15600 6123 50  0000 C CNN
F 2 "" H 15600 5950 50  0001 C CNN
F 3 "~" H 15600 5950 50  0001 C CNN
	1    15600 5950
	1    0    0    -1  
$EndComp
Wire Wire Line
	15350 5850 15100 5850
Connection ~ 15100 5850
Wire Wire Line
	15100 5850 14900 5850
Wire Wire Line
	14900 5950 15600 5950
Connection ~ 15600 5950
Wire Wire Line
	15600 5950 15850 5950
Text Label 13700 5100 0    50   ~ 0
PWR_2V5_OUT
Text Label 13700 6350 0    50   ~ 0
PWR_1V1_OUT
$EndSCHEMATC
