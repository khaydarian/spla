// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module test_button(
	input  clock,
	output led_a,
	output led_b,
	output led_c,
	output led_d,
	input  button);

assign led_a = button;
assign led_b = ~button;
assign led_c = button;
assign led_d = ~button;

endmodule
