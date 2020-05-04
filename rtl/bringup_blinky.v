// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module bringup_blinky(
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

localparam COUNTER_RESET_VAL = 1200000;
localparam COUNTER_BITS = $clog2(COUNTER_RESET_VAL);

reg [COUNTER_BITS-1:0] counter;
reg [7:0] spinner;

initial counter = 0;
initial spinner = 8'b00111011;

always @(posedge clk_12mhz) begin
	if (counter == 0) begin
		counter <= COUNTER_RESET_VAL;
		spinner <= {spinner[0], spinner[7:1]};
	end else
		counter <= counter + 1;
end

assign led7 = spinner[0];
assign led8 = ~spinner[0];

fifo_dummy fifo(
	.d(fifo_d),
	.rxf_n(fifo_rxf_n),
	.txe_n(fifo_txe_n),
	.rd_n(fifo_rd_n),
	.wr_n(fifo_wr_n),
	.siwu(fifo_siwu),
	.clkout(fifo_clkout),
	.oe_n(fifo_oe_n));

// Hold SNES chips in reset (if present).
assign xin = 1'b0;
assign ppu1_reset_n = 1'b0;
assign ppu2_reset_n = 1'b0;

// SNES B-bus
bbus_dummy bbus(
	.pard_n(pard_n),
	.pawr_n(pawr_n),
	.lvl_pa_dir(lvl_pa_dir),
	.pa(pa),
	.lvl_pd_dir(lvl_pd_dir),
	.pd(pd));

// SNES VRAM bus
vram_dummy vram(
	.vrd_n(vrd_n),
	.vawr_n(vawr_n),
	.vbwr_n(vbwr_n),
	.lvl_va_dir(lvl_va_dir),
	.va14(va14),
	.vaa(vaa),
	.vab(vab),
	.lvl_vd_dir(lvl_vd_dir),
	.vda(vda),
	.vdb(vdb));

// SNES PPU2 test (digital color inputs)
assign ppu2_tst15 = 1'b0;
assign lvl_tst_dir = LVL_DIR_INPUT;
assign lvl_tst_oe = 1'b0;

// SNES PPU1 misc outputs
misc_default misc(
	.ppu1_extsync_n(ppu1_extsync_n),
	.ppu1_hvcmode(ppu1_hvcmode),
	.ppu1_master_n(ppu1_master_n),
	.ppu1_palmode(ppu1_palmode),
	.ppu2_extlatch(ppu2_extlatch),
	.ppu2_hvcmode(ppu2_hvcmode),
	.ppu2_palmode(ppu2_palmode));

assign extra1 = led7;
assign extra2 = led8;
assign extra3 = 1'b0;
assign bodge1 = led7;
assign bodge2 = led8;
assign bodge3 = 1'b0;

analog_dummy analog(
	.clk(analog_clk),
	.r_oe(analog_r_oe),
	.r(analog_r),
	.g_oe(analog_g_oe),
	.g(analog_g),
	.b_oe(analog_b_oe),
	.b(analog_b));

endmodule
