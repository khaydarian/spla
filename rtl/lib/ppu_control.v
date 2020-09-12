// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module ppu_control(
	input  clock,
	input  reset,

	// Control inputs
	input  xin_lo_i,
	input  xin_hi_i,
	input  set_ppu_reset_i,
	input  clr_ppu_reset_i,

	// PPU signals
	output xin,
	output ppu1_reset_n,
	output ppu2_reset_n);

reg reg_xin;
reg reg_ppu_reset_n;
initial reg_xin = 0;
initial reg_ppu_reset_n = 0;

assign xin = reg_xin;
assign ppu1_reset_n = reg_ppu_reset_n;
assign ppu2_reset_n = reg_ppu_reset_n;

always @(posedge clock)
	if (!reset) begin
		reg_xin = 0;
		reg_ppu_reset_n = 0; // PPU in reset
	end else begin
		if (xin_hi_i & ~xin_lo_i) begin
			reg_xin <= 1;
		end
		if (xin_lo_i & ~xin_hi_i) begin
			reg_xin <= 0;
		end
		if (set_ppu_reset_i & ~clr_ppu_reset_i) begin
			reg_ppu_reset_n <= 0;
		end
		if (clr_ppu_reset_i & ~set_ppu_reset_i) begin
			reg_ppu_reset_n <= 1;
		end
	end

endmodule
