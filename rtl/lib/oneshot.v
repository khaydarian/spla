// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module oneshot(
	input  clock,
	input  in,
	output out);

parameter CYCLES = 64;
localparam RESET_VALUE = CYCLES - 1;
localparam COUNTER_BITS = $clog2(RESET_VALUE);

reg [COUNTER_BITS-1:0] counter;
always @(posedge clock)
	if (in)
		counter <= RESET_VALUE;
	else if (counter > 0)
		counter <= counter - 1;

assign out = (counter > 0);

endmodule
