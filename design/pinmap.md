# Pinmap

Derived from `pinout_s-ppu1.pdf` and `pinout_s-ppu2.pdf`.

PPU1 signals:

Chip |Pin | Need | Name     | Purpose
-----|----|------|----------|-----------------
PPU1 |  1 | no    | TST1     | Unknown (GND)
PPU1 |  2 | no    | TST0     | Unknown (GND)
PPU1 |  3 | yes   | /PARD    | 5A22 B-Bus Read Strobe (Active-Low)
PPU1 |  4 | yes   | /PAWR    | 5A22 B-Bus Write Strobe (Active-Low)
PPU1 |  5 | yes   | PA7      | 5A22 B-Bus Address
PPU1 |  6 | yes   | PA6      | 5A22 B-Bus Address
PPU1 |  7 | yes   | PA5      | 5A22 B-Bus Address
PPU1 |  8 | yes   | PA4      | 5A22 B-Bus Address
PPU1 |  9 | yes   | PA3      | 5A22 B-Bus Address
PPU1 | 10 | yes   | PA2      | 5A22 B-Bus Address
PPU1 | 11 | yes   | PA1      | 5A22 B-Bus Address
PPU1 | 12 | yes   | PA0      | 5A22 B-Bus Address
PPU1 | 13 | no    | VCC      | Supply
PPU1 | 14 | yes   | D7       | 5A22 Data Bus
PPU1 | 15 | yes   | D6       | 5A22 Data Bus
PPU1 | 16 | yes   | D5       | 5A22 Data Bus
PPU1 | 17 | yes   | D4       | 5A22 Data Bus
PPU1 | 18 | yes   | D3       | 5A22 Data Bus
PPU1 | 19 | yes   | D2       | 5A22 Data Bus
PPU1 | 20 | yes   | D1       | 5A22 Data Bus
PPU1 | 21 | yes   | D0       | 5A22 Data Bus
PPU1 | 22 | no    | GND      | Supply
PPU1 | 23 | maybe | HVCMODE  | Home Video Computer (GND)
PPU1 | 24 | yes   | PALMODE  | PAL Video Mode Enable (VCC=PAL, GND=NTSC)
PPU1 | 25 | no    | /MASTER  | Unknown (GND)
PPU1 | 26 | no    | /EXTSYNC | Unknown (VCC)
PPU1 | 27 | no    | NC       | GND
PPU1 | 28 | yes   | VDB0     | VRAM Data Bus (High Byte)
PPU1 | 29 | yes   | VDB1     | VRAM Data Bus (High Byte)
PPU1 | 30 | yes   | VDB2     | VRAM Data Bus (High Byte)
PPU1 | 31 | yes   | VDB3     | VRAM Data Bus (High Byte)
PPU1 | 32 | yes   | VDB4     | VRAM Data Bus (High Byte)
PPU1 | 33 | yes   | VDB5     | VRAM Data Bus (High Byte)
PPU1 | 34 | yes   | VDB6     | VRAM Data Bus (High Byte)
PPU1 | 35 | yes   | VDB7     | VRAM Data Bus (High Byte)
PPU1 | 36 | no    | VCC      | Supply
PPU1 | 37 | yes   | VDA0     | VRAM Data Bus (Low Byte)
PPU1 | 38 | yes   | VDA1     | VRAM Data Bus (Low Byte)
PPU1 | 39 | yes   | VDA2     | VRAM Data Bus (Low Byte)
PPU1 | 40 | yes   | VDA3     | VRAM Data Bus (Low Byte)
PPU1 | 41 | yes   | VDA4     | VRAM Data Bus (Low Byte)
PPU1 | 42 | yes   | VDA5     | VRAM Data Bus (Low Byte)
PPU1 | 43 | yes   | VDA6     | VRAM Data Bus (Low Byte)
PPU1 | 44 | yes   | VDA7     | VRAM Data Bus (Low Byte)
PPU1 | 45 | no    | GND      | Supply
PPU1 | 46 | no    | VA15     | VRAM Address Bus (NC)
PPU1 | 47 | yes   | VA14     | VRAM Address Bus 
PPU1 | 48 | yes   | VAB13    | VRAM Address Bus (High Byte)
PPU1 | 49 | yes   | VAB12    | VRAM Address Bus (High Byte)
PPU1 | 50 | yes   | VAB11    | VRAM Address Bus (High Byte)
PPU1 | 51 | yes   | VAB10    | VRAM Address Bus (High Byte)
PPU1 | 52 | yes   | VAB9     | VRAM Address Bus (High Byte)
PPU1 | 53 | yes   | VAB8     | VRAM Address Bus (High Byte)
PPU1 | 54 | yes   | VAB7     | VRAM Address Bus (High Byte)
PPU1 | 55 | yes   | VAB6     | VRAM Address Bus (High Byte)
PPU1 | 56 | yes   | VAB5     | VRAM Address Bus (High Byte)
PPU1 | 57 | yes   | VAB4     | VRAM Address Bus (High Byte)
PPU1 | 58 | yes   | VAB3     | VRAM Address Bus (High Byte)
PPU1 | 59 | yes   | VAB2     | VRAM Address Bus (High Byte)
PPU1 | 60 | yes   | VAB1     | VRAM Address Bus (High Byte)
PPU1 | 61 | yes   | VAB0     | VRAM Address Bus (High Byte)
PPU1 | 62 | no    | VCC      | Supply
PPU1 | 63 | yes   | VAA13    | VRAM Address Bus (Low Byte)
PPU1 | 64 | yes   | VAA12    | VRAM Address Bus (Low Byte)
PPU1 | 65 | yes   | VAA11    | VRAM Address Bus (Low Byte)
PPU1 | 66 | yes   | VAA10    | VRAM Address Bus (Low Byte)
PPU1 | 67 | yes   | VAA9     | VRAM Address Bus (Low Byte)
PPU1 | 68 | yes   | VAA8     | VRAM Address Bus (Low Byte)
PPU1 | 69 | yes   | VAA7     | VRAM Address Bus (Low Byte)
PPU1 | 70 | yes   | VAA6     | VRAM Address Bus (Low Byte)
PPU1 | 71 | yes   | VAA5     | VRAM Address Bus (Low Byte)
PPU1 | 72 | yes   | VAA4     | VRAM Address Bus (Low Byte)
PPU1 | 73 | yes   | VAA3     | VRAM Address Bus (Low Byte)
PPU1 | 74 | yes   | VAA2     | VRAM Address Bus (Low Byte)
PPU1 | 75 | yes   | VAA1     | VRAM Address Bus (Low Byte)
PPU1 | 76 | yes   | VAA0     | VRAM Address Bus (Low Byte)
PPU1 | 77 | no    | GND      | Supply
PPU1 | 78 | yes   | /VAWR    | VRAM Write Strobe (High Byte) (Active-Low)
PPU1 | 79 | yes   | /VBWR    | VRAM Write Strobe (Low Byte) (Active-Low)
PPU1 | 80 | yes   | /VRD     | VRAM Read Strobe (16-bit) (Active-Low)
PPU1 | 81 | no    | VCC      | Supply
PPU1 | 82 | yes   | CHR3     | Unknown (connected to PPU2)
PPU1 | 83 | yes   | CHR2     | Unknown (connected to PPU2)
PPU1 | 84 | yes   | CHR1     | Unknown (connected to PPU2)
PPU1 | 85 | yes   | CHR0     | Unknown (connected to PPU2)
PPU1 | 86 | yes   | PRIO1    | Unknown (connected to PPU2)
PPU1 | 87 | yes   | PRIO0    | Unknown (connected to PPU2)
PPU1 | 88 | yes   | COLOR2   | Unknown (connected to PPU2)
PPU1 | 89 | yes   | COLOR1   | Unknown (connected to PPU2)
PPU1 | 90 | yes   | COLOR0   | Unknown (connected to PPU2)
PPU1 | 91 | yes   | /VCLD    | Unknown (connected to PPU2)
PPU1 | 92 | yes   | /HCLD    | Unknown (connected to PPU2)
PPU1 | 93 | yes   | /5MOU    | Dot Clock Out (5.37MHz) (connected to PPU2)
PPU1 | 94 | yes   | /OVER    | Unknown (connected to PPU2)
PPU1 | 95 | yes   | FIELD    | Unknown (connected to PPU2)
PPU1 | 96 | no    | GND      | Supply
PPU1 | 97 | yes   | /5MIN    | Dot Clock In (5.37MHz) (driven by local /5MOUT)
PPU1 | 98 | yes   | /RESET   | Reset (from PPU2) 
PPU1 | 99 | no    | TST2     | Unknown (GND)
PPU1 |100 | yes   | XIN      | Master Clock (21.47727MHz)

PPU2 |  1 | yes   | /BURST   | Video Output Color Burst Strobe (Active-Low) (to-S-ENC)
PPU2 |  2 | no    | /PED     | Unknown (NC) 
PPU2 |  3 | yes   | 3.58M    | Video Output Clock (3.58MHz) (NTSC) (to S-ENC)
PPU2 |  4 | no    | /TOUMEI  | Unknown (NC) 
PPU2 |  5 | no    | VCC      | Supply
PPU2 |  6 | yes   | /PAWR    | 5A22 B-Bus Write Strobe (Active-Low)
PPU2 |  7 | yes   | /PARD    | 5A22 B-Bus Read Strobe (Active-Low)
PPU2 |  8 | yes   | D7       | 5A22 Data Bus
PPU2 |  9 | yes   | D6       | 5A22 Data Bus 
PPU2 | 10 | yes   | D5       | 5A22 Data Bus 
PPU2 | 11 | yes   | D4       | 5A22 Data Bus 
PPU2 | 12 | yes   | D3       | 5A22 Data Bus 
PPU2 | 13 | yes   | D2       | 5A22 Data Bus 
PPU2 | 14 | yes   | D1       | 5A22 Data Bus 
PPU2 | 15 | yes   | D0       | 5A22 Data Bus 
PPU2 | 16 | no    | GND      | Supply 
PPU2 | 17 | yes   | PA7      | 5A22 B-Bus Address
PPU2 | 18 | yes   | PA6      | 5A22 B-Bus Address
PPU2 | 19 | yes   | PA5      | 5A22 B-Bus Address
PPU2 | 20 | yes   | PA4      | 5A22 B-Bus Address
PPU2 | 21 | yes   | PA3      | 5A22 B-Bus Address
PPU2 | 22 | yes   | PA2      | 5A22 B-Bus Address
PPU2 | 23 | yes   | PA1      | 5A22 B-Bus Address
PPU2 | 24 | yes   | PA0      | 5A22 B-Bus Address
PPU2 | 25 | yes   | HBLANK   | Horizontal Blank (to 5A22)
PPU2 | 26 | yes   | VBLANK   | Vertical Blank (to 5A22)
PPU2 | 27 | yes   | /5MOUT   | Dot Clock Out (5.37MHz) (to expansion port)
PPU2 | 28 | yes   | /RESOUT1 | Reset Out 1 (to CPU, APU, Cartridge, Expansion port, etc.)
PPU2 | 29 | yes   | EXTLATCH | External Latch (Lightpen signal) (to Joypad)
PPU2 | 30 | no    | PALMODE  | PAL Video Mode Enable (VCC=PAL, GND=NTSC) (GND)
PPU2 | 31 | yes   | XIN      | Master Clock (21.47727MHz) (from Osc)
PPU2 | 32 | no    | VCC      | Supply
PPU2 | 33 | yes   | /RESOUT0 | Reset Out 0 (to PPU1)
PPU2 | 34 | yes   | /RESET   | Reset In (from CIC)
PPU2 | 35 | no    | GND      | Supply
PPU2 | 36 | yes   | FIELD    | Unknown (connected to PPU1)
PPU2 | 37 | yes   | /OVER1   | Unknown (connected to PPU1)
PPU2 | 38 | yes   | /5MIN    | Dot Clock In (5.37MHz) (from PPU1)
PPU2 | 39 | yes   | /HCLD    | Unknown (connected to PPU1)
PPU2 | 40 | yes   | /VCLD    | Unknown (connected to PPU1)
PPU2 | 41 | yes   | COLOR0   | Unknown (connected to PPU2)
PPU2 | 42 | yes   | COLOR1   | Unknown (connected to PPU2)
PPU2 | 43 | yes   | COLOR2   | Unknown (connected to PPU2)
PPU2 | 44 | yes   | PRIO0    | Unknown (connected to PPU2)
PPU2 | 45 | yes   | PRIO1    | Unknown (connected to PPU2)
PPU2 | 46 | yes   | CHR0     | Unknown (connected to PPU2)
PPU2 | 47 | yes   | CHR1     | Unknown (connected to PPU2)
PPU2 | 48 | yes   | CHR2     | Unknown (connected to PPU2)
PPU2 | 49 | yes   | CHR3     | Unknown (connected to PPU2)
PPU2 | 50 | yes   | /OVER2   | Unknown (connected to local /OVER1, and /OVER on PPU1)
PPU2 | 51 | yes   | VDB0     | VRAM Data Bus (High Byte)
PPU2 | 52 | yes   | VDB1     | VRAM Data Bus (High Byte)
PPU2 | 53 | yes   | VDB2     | VRAM Data Bus (High Byte)
PPU2 | 54 | yes   | VDB3     | VRAM Data Bus (High Byte)
PPU2 | 55 | yes   | VDB4     | VRAM Data Bus (High Byte)
PPU2 | 56 | yes   | VDB5     | VRAM Data Bus (High Byte)
PPU2 | 57 | yes   | VDB6     | VRAM Data Bus (High Byte)
PPU2 | 58 | yes   | VDB7     | VRAM Data Bus (High Byte)
PPU2 | 59 | no    | VCC      | Supply
PPU2 | 60 | yes   | VDA0     | VRAM Data Bus (Low Byte)
PPU2 | 61 | yes   | VDA1     | VRAM Data Bus (Low Byte)
PPU2 | 62 | yes   | VDA2     | VRAM Data Bus (Low Byte)
PPU2 | 63 | yes   | VDA3     | VRAM Data Bus (Low Byte)
PPU2 | 64 | yes   | VDA4     | VRAM Data Bus (Low Byte)
PPU2 | 65 | yes   | VDA5     | VRAM Data Bus (Low Byte)
PPU2 | 66 | yes   | VDA6     | VRAM Data Bus (Low Byte)
PPU2 | 67 | yes   | VDA7     | VRAM Data Bus (Low Byte)
PPU2 | 68 | no    | GND      | Supply
PPU2 | 69 | maybe | EXT0     | External Video Input (from VRAM Data Bus (High Byte)) (it is unclear why this is wired up to VRAM in SNES)
PPU2 | 70 | maybe | EXT1     | External Video Input (from VRAM Data Bus (High Byte)) (it is unclear why this is wired up to VRAM in SNES)
PPU2 | 71 | maybe | EXT2     | External Video Input (from VRAM Data Bus (High Byte)) (it is unclear why this is wired up to VRAM in SNES)
PPU2 | 72 | maybe | EXT3     | External Video Input (from VRAM Data Bus (High Byte)) (it is unclear why this is wired up to VRAM in SNES)
PPU2 | 73 | maybe | EXT4     | External Video Input (from VRAM Data Bus (High Byte)) (it is unclear why this is wired up to VRAM in SNES)
PPU2 | 74 | maybe | EXT5     | External Video Input (from VRAM Data Bus (High Byte)) (it is unclear why this is wired up to VRAM in SNES)
PPU2 | 75 | maybe | EXT6     | External Video Input (from VRAM Data Bus (High Byte)) (it is unclear why this is wired up to VRAM in SNES)
PPU2 | 76 | maybe | EXT7     | External Video Input (from VRAM Data Bus (High Byte)) (it is unclear why this is wired up to VRAM in SNES)
PPU2 | 77 | no    | TST0     | Unknown (NC)
PPU2 | 78 | no    | TST1     | Unknown (NC)
PPU2 | 79 | no    | TST2     | Unknown (NC)
PPU2 | 80 | no    | TST3     | Unknown (NC)
PPU2 | 81 | no    | TST4     | Unknown (NC)
PPU2 | 82 | no    | TST5     | Unknown (NC)
PPU2 | 83 | no    | VCC      | Supply
PPU2 | 84 | no    | TST6     | Unknown (NC)
PPU2 | 85 | no    | TST7     | Unknown (NC)
PPU2 | 86 | no    | TST8     | Unknown (NC)
PPU2 | 87 | no    | TST9     | Unknown (NC)
PPU2 | 88 | no    | TST10    | Unknown (NC)
PPU2 | 89 | no    | TST11    | Unknown (NC)
PPU2 | 90 | no    | TST12    | Unknown (NC)
PPU2 | 91 | no    | TST13    | Unknown (NC)
PPU2 | 92 | no    | TST14    | Unknown (NC)
PPU2 | 93 | no    | TST15    | Unknown (NC)
PPU2 | 94 | no    | AVCC     | Supply
PPU2 | 95 | yes   | R        | Analog Red Component (to S-ENC)
PPU2 | 96 | yes   | G        | Analog Green Component (to S-ENC)
PPU2 | 97 | yes   | B        | Analog Blue Component (to S-ENC)
PPU2 | 98 | maybe | HVCMODE  | Home Video Computer (a.k.a. Famicom) Mode (purpose unknown since SNES can play Famicom games already) (GND)
PPU2 | 99 | no    | GND      | Supply
PPU2 | 100| yes   | /CSYNC   | Video Output Composite Sync (Active-Low) (to S-ENC)
