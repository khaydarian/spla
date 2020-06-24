// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module pulse(
	input clock,
	input pulse_o);

parameter CLOCKS_PER_PULSE = 10;
localparam PULSE_RESET = CLOCKS_PER_PULSE - 1;
localparam PULSE_BITS = $clog2(PULSE_RESET);

reg [PULSE_BITS-1:0] counter;
reg pulse;

always @(posedge clock)
	if (counter == 0) begin
		counter <= PULSE_RESET;
		pulse <= 1;
	end else begin
		counter <= counter - 1;
		pulse <= 0;
	end

assign pulse_o = pulse;

endmodule
