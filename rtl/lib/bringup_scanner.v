// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module bringup_scanner(
	input clock,
	input pulse_i,
	input [PINDEFMAX:0] state_i,
	output write_o,
	output [7:0] data_o,
	input hold_i);

reg writing;
reg [PINDEFMAX+8:0] state_copy;

localparam PINDEFMAX_BYTES = PINDEFMAX / 8 + 1; // 22 exactly, plus start byte
localparam COUNTER_RESET = 23 - 1;  // PINDEFMAX_BYTES - 1
localparam COUNTER_BITS = $clog2(COUNTER_RESET);
reg [COUNTER_BITS-1:0] counter;

always @(posedge clock) begin
	if (writing) begin
		if (!hold_i) begin
			if (counter == 0) begin
				writing <= 0;
			end else begin
				counter <= counter - 1;
				state_copy <= {8'h00, state_copy[PINDEFMAX+8:8]};
			end
		end
	end else if (pulse_i) begin
		writing <= 1;
		state_copy <= {state_i, 8'hf0};
		counter <= COUNTER_RESET;
	end
end

assign write_o = writing;
assign data_o = state_copy[7:0];

endmodule
