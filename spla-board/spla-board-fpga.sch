EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A3 16535 11693
encoding utf-8
Sheet 4 5
Title "SPLA Board - FPGA"
Date "2020-02-18"
Rev "2"
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L FPGA_Lattice:ICE40HX4K-TQ144 U?
U 1 1 5E4D8455
P 2750 3600
F 0 "U?" H 3099 3828 50  0000 L CNN
F 1 "ICE40HX4K-TQ144" H 3099 3737 50  0000 L CNN
F 2 "Package_QFP:TQFP-144_20x20mm_P0.5mm" H 3750 1700 50  0001 R CNN
F 3 "http://www.latticesemi.com/Products/FPGAandCPLD/iCE40" H 1750 6100 50  0001 C CNN
	1    2750 3600
	1    0    0    -1  
$EndComp
$Comp
L FPGA_Lattice:ICE40HX4K-TQ144 U?
U 2 1 5E4DC1FF
P 4750 3650
F 0 "U?" H 5099 3878 50  0000 L CNN
F 1 "ICE40HX4K-TQ144" H 5099 3787 50  0000 L CNN
F 2 "Package_QFP:TQFP-144_20x20mm_P0.5mm" H 5750 1750 50  0001 R CNN
F 3 "http://www.latticesemi.com/Products/FPGAandCPLD/iCE40" H 3750 6150 50  0001 C CNN
	2    4750 3650
	1    0    0    -1  
$EndComp
$Comp
L FPGA_Lattice:ICE40HX4K-TQ144 U?
U 3 1 5E4DEFB8
P 6900 3550
F 0 "U?" H 7299 3778 50  0000 L CNN
F 1 "ICE40HX4K-TQ144" H 7299 3687 50  0000 L CNN
F 2 "Package_QFP:TQFP-144_20x20mm_P0.5mm" H 7900 1650 50  0001 R CNN
F 3 "http://www.latticesemi.com/Products/FPGAandCPLD/iCE40" H 5900 6050 50  0001 C CNN
	3    6900 3550
	1    0    0    -1  
$EndComp
$Comp
L FPGA_Lattice:ICE40HX4K-TQ144 U?
U 4 1 5E4E54E9
P 9550 3650
F 0 "U?" H 9899 3828 50  0000 L CNN
F 1 "ICE40HX4K-TQ144" H 9899 3737 50  0000 L CNN
F 2 "Package_QFP:TQFP-144_20x20mm_P0.5mm" H 10550 1750 50  0001 R CNN
F 3 "http://www.latticesemi.com/Products/FPGAandCPLD/iCE40" H 8550 6150 50  0001 C CNN
	4    9550 3650
	1    0    0    -1  
$EndComp
$Comp
L FPGA_Lattice:ICE40HX4K-TQ144 U?
U 5 1 5E4E79E3
P 6850 5500
F 0 "U?" H 7594 5546 50  0000 L CNN
F 1 "ICE40HX4K-TQ144" H 7594 5455 50  0000 L CNN
F 2 "Package_QFP:TQFP-144_20x20mm_P0.5mm" H 7850 3600 50  0001 R CNN
F 3 "http://www.latticesemi.com/Products/FPGAandCPLD/iCE40" H 5850 8000 50  0001 C CNN
	5    6850 5500
	1    0    0    -1  
$EndComp
Text Notes 5300 7700 0    202  ~ 0
This is the iCE40HX4K, in a TQFP-144 package.\nIt's easily hand-solderable, but only has 107 IO pins,\nand half the internal gates.
$EndSCHEMATC
