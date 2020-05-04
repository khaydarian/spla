// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module top_template(
	// Clock input
	input clk_12mhz,

	// Bringup / Test LEDs
	output led7,
	output led8,

	// Ftdi Fifo
	inout [7:0] fifo_d,
	input fifo_rxf_n,
	input fifo_txe_n,
	output fifo_rd_n,
	output fifo_wr_n,
	output fifo_siwu,
	input fifo_clkout,
	output fifo_oe_n,

	// FTDI misc
	input usb_pwren_n,
	input usb_suspend_n,

	// SNES clock output
	output xin,

	// SNES reset
	output ppu1_reset_n,
	output ppu2_reset_n,
	input ppu2_resout0_n,
	input ppu2_resout1_n,

	// SNES sync
	input burst_n,
	input csync_n,
	input ppu2_hblank,
	input ppu2_vblank,

	// SNES B-bus
	output pard_n,
	output pawr_n,
	output lvl_pa_dir,
	inout [7:0] pa,
	output lvl_pd_dir,
	inout [7:0] pd,

	// SNES VRAM bus
	output vrd_n,
	output vawr_n,
	output vbwr_n,
	output lvl_va_dir,
	inout va14,
	inout [13:0] vaa,
	inout [13:0] vab,
	output lvl_vd_dir,
	inout [7:0] vda,
	inout [7:0] vdb,

	// SNES Inter-PPU bus
	input field,
	input over_n,
	input ppu_5m,
	input hcld_n,
	input vcld_n,
	input [2:0] color,
	input [1:0] prio,
	input [3:0] chr,

	// SNES PPU2 test (digital color inputs)
	output ppu2_tst15,
	output lvl_tst_dir,
	output lvl_tst_oe,
	input [14:0] ppu2_tst,

	// SNES PPU1 misc outputs
	output ppu1_extsync_n,
	output ppu1_hvcmode,
	output ppu1_master_n,
	output ppu1_palmode,

	// SNES PPU2 misc inputs
	input ppu2_3p58m,
	input ppu2_ped_n,
	input ppu2_5mout_n,
	input ppu2_toumei_n,

	// SNES PPU2 misc outputs
	output ppu2_extlatch,
	output ppu2_hvcmode,
	output ppu2_palmode,

	// Extra (3.3V)
	output extra1,
	output extra2,
	output extra3,

	// Bodge (5V)
	output bodge1,
	output bodge2,
	output bodge3,

	// Analog block
	output analog_clk,
	output analog_r_oe,
	input [7:0] analog_r,
	output analog_g_oe,
	input [7:0] analog_g,
	output analog_b_oe,
	input [7:0] analog_b);

endmodule
