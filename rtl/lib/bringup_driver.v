// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module bringup_driver(
	input  clock,
	output pin_o);

parameter CLOCKS_PER_CYCLE = 120;

localparam COUNTER_RESET = (CLOCKS_PER_CYCLE / 2) - 1;
localparam COUNTER_BITS = $clog2(COUNTER_RESET);

reg [COUNTER_BITS-1:0] counter;
reg out;

always @(posedge clock)
	if (counter == 0) begin
		counter <= COUNTER_RESET;
		out <= ~out;
	end else
		counter <= counter - 1;

assign pin_o = out;

endmodule
