// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module edge_rising(
	input clock,
	input in_i,
	output pulse_o);

reg last;
always @(posedge clock)
	last <= in_i;

assign pulse_o = in_i & ~last;

endmodule

module edge_falling(
	input clock,
	input in_i,
	output pulse_o);

reg last;
always @(posedge clock)
	last <= in_i;

assign pulse_o = ~in_i & last;

endmodule
