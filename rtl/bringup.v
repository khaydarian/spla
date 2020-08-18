// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module bringup(
	input  clock_12mhz,
	output led_a,
	output led_b);

wire clock;
OSCG #(.DIV(26)) oscg(.OSC(clock)); // DIV 26 == ~11.9MHz

reg int;
clock_div #(.CYCLES(6000000)) counter_int(.clock(clock), .div_o(int));

reg ext;
clock_div #(.CYCLES(6000000)) counter_ext(.clock(clock_12mhz), .div_o(ext));

assign led_a = int;
assign led_b = ext;

endmodule
