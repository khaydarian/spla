// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module test_bidir(
	input  clock,
	output led_a,
	output led_b,
	inout  extra3,
	output bodge3);

reg [2:0] state;
initial state = 1;

reg step;
pulse #(.CLOCKS_PER_PULSE(4 * 12000000))
	step_pulse(.clock(clock), .pulse_o(step));

always @(posedge clock) begin
	if (step) begin
		state = (state << 1) | state[2];
	end
end

wire bb_i;
wire bb_o;
wire bb_t;

assign bb_t = (state == 3'b100);
assign bb_i = (state != 3'b001);

assign led_a = state[0];
assign led_b = state[1];

BB bb(.I(bb_i), .O(bb_o), .T(bb_t), .B(extra3));

assign bodge3 = bb_o;

endmodule
