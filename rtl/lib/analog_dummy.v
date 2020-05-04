// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module analog_dummy(
	output clk,
	output r_oe,
	input [7:0] r,
	output g_oe,
	input [7:0] g,
	output b_oe,
	input [7:0] b);

assign clk = 1'b0;
assign r_oe = 1'b0;
assign g_oe = 1'b0;
assign b_oe = 1'b0;

endmodule
