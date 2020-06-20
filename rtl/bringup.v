// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module bringup(
	input  clk_12mhz,
	output led7,
	output led8);

wire clock;
OSCG #(.DIV(26)) oscg(.OSC(clock)); // DIV 26 == ~11.9MHz

reg int;
clock_div #(.CYCLES(6000000)) counter_int(.clock(clock), .div_o(int));

reg ext;
clock_div #(.CYCLES(6000000)) counter_ext(.clock(clk_12mhz), .div_o(ext));

assign led7 = int;
assign led8 = ext;

endmodule
