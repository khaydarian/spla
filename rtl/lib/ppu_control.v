// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module ppu_control(
	input  clock,
	input  reset,

	// Clock control inputs
	input  xin_enabled_i,
	output xin_stalled_o,
	output [31:0] xin_counter_o,

	// Reset control inputs
	input  set_ppu_reset_i,
	input  clr_ppu_reset_i,

	// Interrupts
	input  [7:0] int_enabled_i,
	input  int_clear_all_i,

	output [7:0] int_triggered_o,
	output int_any_triggered_o,

	// PPU signals
	output xin,
	output ppu1_reset_n,
	output ppu2_reset_n,
	input  burst_n,
	input  csync_n,
	input  hblank,
	input  vblank);

wire xin_stall;
assign xin_stall = ~(xin_enabled_i & ~int_any_triggered_o);

ppu_clock ppu_clock(
	.clock(clock),
	.reset(reset),
	.xin_stall_i(xin_stall),
	.xin_stall_o(xin_stalled_o),
	.xin(xin),
	.xin_counter_o(xin_counter_o));

ppu_interrupt ppu_interrupt(
	.clock(clock),
	.reset(reset),
	.int_enabled_i(int_enabled_i),
	.int_clear_all_i(int_clear_all_i),
	.int_triggered_o(int_triggered_o),
	.int_any_triggered_o(int_any_triggered_o),
	.burst_n(burst_n),
	.csync_n(csync_n),
	.hblank(hblank),
	.vblank(vblank));

reg reg_ppu_reset_n;
initial reg_ppu_reset_n = 0;

assign ppu1_reset_n = reg_ppu_reset_n;
assign ppu2_reset_n = reg_ppu_reset_n;

always @(posedge clock)
	if (!reset) begin
		reg_ppu_reset_n = 0; // PPU in reset
	end else begin
		if (set_ppu_reset_i & ~clr_ppu_reset_i) begin
			reg_ppu_reset_n <= 0;
		end
		if (clr_ppu_reset_i & ~set_ppu_reset_i) begin
			reg_ppu_reset_n <= 1;
		end
	end

endmodule
