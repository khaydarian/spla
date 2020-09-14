// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module ppu_clock(
	input  clock,
	input  reset,

	// Control inputs
	input  xin_stall_i,
	output xin_stall_o,

	// SNES Master clock; Initially low
	output xin,

	// Counter of clock cycles; increments on falling edge of xin
	output [31:0] xin_counter_o);

reg [31:0] reg_xin_counter;
initial reg_xin_counter = 0;

reg reg_xin;
initial reg_xin = 0;

parameter CYCLES_PER_XIN_CYCLE = 10; // With 12MHz clock, effective 1.2MHz
localparam DIV_COUNT_RESET = (CYCLES_PER_XIN_CYCLE / 2) - 1;
localparam DIV_COUNT_BITS = 6;
reg [DIV_COUNT_BITS-1:0] div_count;
initial div_count = 0;

always @(posedge clock)
	if (!reset) begin
		reg_xin_counter <= 0;
		reg_xin <= 0;
	end else if (div_count != 0) begin
		div_count <= div_count - 1;
	end else if (reg_xin) begin
		reg_xin <= 0;
		reg_xin_counter <= reg_xin_counter + 1;
		div_count <= DIV_COUNT_RESET;
	end else if (!xin_stall_i) begin
		reg_xin <= 1;
		div_count <= DIV_COUNT_RESET;
	end

assign xin_stall_o = xin_stall_i & ~reg_xin & (div_count == 0);
assign xin_counter_o = reg_xin_counter;
assign xin = reg_xin;

endmodule
