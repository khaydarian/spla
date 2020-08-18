// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module bringup_fifo(
	// Clock input
	input  clock,

	output led_a,
	output led_b,

	// FIFO pins
	output [7:0] fifo_d,
	output fifo_rxf_n,
	output fifo_txe_n,
	output fifo_rd_n,
	output fifo_wr_n,
	output fifo_siwu,
	output fifo_clkout,
	output fifo_oe_n);

wire shift_pulse;
pulse #(.CLOCKS_PER_PULSE(6000000)) // 0.5 Hz
	pulse(.clock(clock), .pulse_o(shift_pulse));

reg [14:0] state;
reg toggle;

always @(posedge clock)
	if (state == 0)
		state <= 1;
	else if (shift_pulse) begin
		state <= {state[13:0], state[14]};
		toggle <= ~toggle;
	end

assign fifo_d = state[7:0];
assign fifo_rxf_n = state[8];
assign fifo_txe_n = state[9];
assign fifo_rd_n = state[10];
assign fifo_wr_n = state[11];
assign fifo_clkout = state[12];
assign fifo_oe_n = state[13];
assign fifo_siwu = state[14];

assign led_a = toggle;
assign led_b = ~toggle;

endmodule
