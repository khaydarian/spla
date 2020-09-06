// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module bringup_ppu(
	// Clock input
	input  clock,

	// SNES Master clock
	output xin,

	// SNES reset
	output ppu1_reset_n,
	output ppu2_reset_n,

	// Video signals
	input  hblank,
	input  vblank,

	// B-Bus
	output pard_n,
	output pawr_n,
	output lvl_pa_dir,
	output lvl_pd_dir,

	// VRAM Bus
	output lvl_va_dir,
	output lvl_vd_dir,

	// PPU2 TST
	output ppu2_tst15,
	output lvl_tst_dir,
	output lvl_tst_oe,

	// Misc
	output ppu1_extsync_n,
	output ppu1_hvcmode,
	output ppu1_master_n,
	output ppu1_palmode,
	output ppu2_extlatch,
	output ppu2_hvcmode,
	output ppu2_palmode,

	// LEDs
	output  led_a,
	output  led_b);

// SNES Master Clock
assign xin = clock;

// SNES Reset
assign ppu1_reset_n = 1; // released, but maybe irrelevant depending on J5 setting
assign ppu2_reset_n = 1; // released

// Video signals

sync2ff vblank_sync2ff(.clock(clock), .in_i(vblank), .out_o(vblank_sync));
wire vblank_sync;
edge_falling vblank_edge(.clock(clock), .in_i(vblank_sync), .pulse_o(vblank_pulse));
wire vblank_pulse;
reg [3:0] vblank_counter;
initial vblank_counter = 0;
reg vblank_output;
initial vblank_output = 0;
always @(posedge clock)
	if (vblank_pulse) begin
		if (vblank_counter == 15) begin
			vblank_counter <= 0;
			vblank_output <= ~vblank_output;
		end else begin
			vblank_counter <= vblank_counter + 1;
		end
	end
assign led_a = vblank_output;

sync2ff hblank_sync2ff(.clock(clock), .in_i(hblank), .out_o(hblank_sync));
wire hblank_sync;
edge_falling hblank_edge(.clock(clock), .in_i(hblank_sync), .pulse_o(hblank_pulse));
wire hblank_pulse;
reg [13:0] hblank_counter;
initial hblank_counter = 0;
reg hblank_output;
initial hblank_output = 0;
always @(posedge clock)
	if (hblank_pulse) begin
		if (hblank_counter == 15750) begin
			hblank_counter <= 0;
			hblank_output <= ~hblank_output;
		end else begin
			hblank_counter <= hblank_counter + 1;
		end
	end
assign led_b = hblank_output;

// B-Bus
assign pard_n = 1;
assign pawr_n = 1;
assign lvl_pa_dir = 0; // input
assign lvl_pd_dir = 0; // input

// VRAM Bus
assign lvl_va_dir = 0; // input
assign lvl_vd_dir = 0; // input

// PPU2 TST
assign ppu2_tst15 = 0; // Disabled
assign lvl_tst_dir = 0; // input (irrelevant, given oe)
assign lvl_tst_oe = 1; // output disabled (active low)

// Misc
misc_default misc_default(
	.ppu1_extsync_n(ppu1_extsync_n),
	.ppu1_hvcmode(ppu1_hvcmode),
	.ppu1_master_n(ppu1_master_n),
	.ppu1_palmode(ppu1_palmode),
	.ppu2_extlatch(ppu2_extlatch),
	.ppu2_hvcmode(ppu2_hvcmode),
	.ppu2_palmode(ppu2_palmode));

endmodule
