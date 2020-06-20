// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module bringup(
	input  clk_12mhz,
	output led7,
	output led8);

wire clock;
OSCG #(.DIV(26)) oscg(.OSC(clock)); // DIV 26 == ~11.9MHz

localparam COUNTER_RESET_VAL = 12000000;
localparam COUNTER_BITS = $clog2(COUNTER_RESET_VAL);

reg [COUNTER_BITS-1:0] counter_internal;
reg int;
always @(posedge clock) begin
	if (counter_internal == 0) begin
		counter_internal <= COUNTER_RESET_VAL;
		int <= ~int;
	end else
		counter_internal <= counter_internal + 1;
end

reg [COUNTER_BITS-1:0] counter_external;
reg ext;
always @(posedge clk_12mhz) begin
	if (counter_external == 0) begin
		counter_external <= COUNTER_RESET_VAL;
		ext <= ~ext;
	end else
		counter_external <= counter_external + 1;
end

assign led7 = int;
assign led8 = ext;

endmodule
