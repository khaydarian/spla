// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module bringup_blinky(
	// Clock input
	input  clk_12mhz,

	// Bringup / Test LEDs
	output led7,
	output led8,

	// Ftdi Fifo
	input  [7:0] fifo_d,
	input  fifo_rxf_n,
	input  fifo_txe_n,
	output fifo_rd_n,
	output fifo_wr_n,
	output fifo_siwu,
	input  fifo_clkout,
	output fifo_oe_n,

	// FTDI misc
	input  usb_pwren_n,
	input  usb_suspend_n,

	// SNES clock output
	output xin,

	// SNES reset
	output ppu1_reset_n,
	output ppu2_reset_n,
	input  ppu2_resout0_n,
	input  ppu2_resout1_n,

	// SNES sync
	input  burst_n,
	input  csync_n,
	input  ppu2_hblank,
	input  ppu2_vblank,

	// SNES B-bus
	output pard_n,
	output pawr_n,
	output lvl_pa_dir,
	input  [7:0] pa,
	output lvl_pd_dir,
	input  [7:0] pd,

	// SNES VRAM bus
	output lvl_va_dir,
	input  vrd_n,
	input  vawr_n,
	input  vbwr_n,
	input  va14,
	input  [13:0] vaa,
	input  [13:0] vab,
	output lvl_vd_dir,
	input  [7:0] vda,
	input  [7:0] vdb,

	// SNES Inter-PPU bus
	input  field,
	input  over_n,
	input  ppu_5m,
	input  hcld_n,
	input  vcld_n,
	input  [2:0] color,
	input  [1:0] prio,
	input  [3:0] chr,

	// SNES PPU2 test (digital color inputs)
	output ppu2_tst15,
	output lvl_tst_dir,
	output lvl_tst_oe,
	input  [14:0] ppu2_tst,

	// SNES PPU1 misc outputs
	output ppu1_extsync_n,
	output ppu1_hvcmode,
	output ppu1_master_n,
	output ppu1_palmode,

	// SNES PPU2 misc inputs
	input  ppu2_3p58m,
	input  ppu2_ped_n,
	input  ppu2_5mout_n,
	input  ppu2_toumei_n,

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
	input  [7:0] analog_r,
	output analog_g_oe,
	input  [7:0] analog_g,
	output analog_b_oe,
	input  [7:0] analog_b);

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

// Ftdi Fifo
wire [7:0] fifo_d_in;
wire [7:0] fifo_d_out;
wire fifo_d_dir;
pin_bidir_8 pin_bidir_8_for_fifo_d(
	.i(fifo_d_in),
	.o(fifo_d_out), .dir(fifo_d_dir),
	.pin(fifo_d));
fifo_dummy fifo(
	.d_in(fifo_d_in),
	.d_out(fifo_d_out),
	.d_dir(fifo_d_dir),
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
wire [7:0] pa_in;
wire [7:0] pa_out;
wire pa_dir;
wire [7:0] pd_in;
wire [7:0] pd_out;
wire pd_dir;
pin_bidir_8 pin_bidir_8_for_pa(
	.i(pa_in), .o(pa_out), .dir(pa_dir), .pin(pa));
pin_bidir_8 pin_bidir_8_for_bd(
	.i(pd_in), .o(pd_out), .dir(pd_dir), .pin(pd));
bbus_dummy bbus(
	.pard_n(pard_n),
	.pawr_n(pawr_n),
	.lvl_pa_dir(lvl_pa_dir),
	.pa_in(pa_in),
	.pa_out(pa_out),
	.pa_dir(pa_dir),
	.lvl_pd_dir(lvl_pd_dir),
	.pd_in(pd_in),
	.pd_out(pd_out),
	.pd_dir(pd_dir),
	);

// SNES VRAM bus
wire vrd_n_in;
wire vrd_n_out;
wire vrd_n_dir;
wire vawr_n_in;
wire vawr_n_out;
wire vawr_n_dir;
wire vbwr_n_in;
wire vbwr_n_out;
wire vbwr_n_dir;
wire va14_in;
wire va14_out;
wire va14_dir;
wire [13:0] vaa_in;
wire [13:0] vaa_out;
wire vaa_dir;
wire [13:0] vab_in;
wire [13:0] vab_out;
wire vab_dir;
wire [7:0] vda_in;
wire [7:0] vda_out;
wire vda_dir;
wire [7:0] vdb_in;
wire [7:0] vdb_out;
wire vdb_dir;
pin_bidir pin_bidir_for_vrd(
	.i(vrd_n_in), .o(vrd_n_out), .dir(vrd_n_dir), .pin(vrd_n));
pin_bidir pin_bidir_for_vawr(
	.i(vawr_n_in), .o(vawr_n_out), .dir(vawr_n_dir), .pin(vawr_n));
pin_bidir pin_bidir_for_vbwr(
	.i(vbwr_n_in), .o(vbwr_n_out), .dir(vbwr_n_dir), .pin(vbwr_n));
pin_bidir pin_bidir_for_va14(
	.i(va14_in), .o(va14_out), .dir(va14_dir), .pin(va14));
pin_bidir_14 pin_bidir_14_for_vaa(
	.i(vaa_in), .o(vaa_out), .dir(vaa_dir), .pin(vaa));
pin_bidir_14 pin_bidir_14_for_vab(
	.i(vab_in), .o(vab_out), .dir(vab_dir), .pin(vab));
pin_bidir_8 pin_bidir_8_for_vda(
	.i(vda_in), .o(vda_out), .dir(vda_dir), .pin(vda));
pin_bidir_8 pin_bidir_8_for_vdb(
	.i(vdb_in), .o(vdb_out), .dir(vdb_dir), .pin(vdb));
vram_dummy vram(
	.lvl_va_dir(lvl_va_dir),
	.vrd_n_in(vrd_n_in), .vrd_n_out(vrd_n_out), .vrd_n_dir(vrd_n_dir),
	.vawr_n_in(vawr_n_in), .vawr_n_out(vawr_n_out), .vawr_n_dir(vawr_n_dir),
	.vbwr_n_in(vbwr_n_in), .vbwr_n_out(vbwr_n_out), .vbwr_n_dir(vbwr_n_dir),
	.va14_in(va14_in), .va14_out(va14_out), .va14_dir(va14_dir),
	.vaa_in(vaa_in), .vaa_out(vaa_out), .vaa_dir(vaa_dir),
	.vab_in(vab_in), .vab_out(vab_out), .vab_dir(vab_dir),
	.lvl_vd_dir(lvl_vd_dir),
	.vda_in(vda_in), .vda_out(vda_out), .vda_dir(vda_dir),
	.vdb_in(vdb_in), .vdb_out(vdb_out), .vdb_dir(vdb_dir));

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
