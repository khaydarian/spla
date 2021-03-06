// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module uart_rx(
	input  clock,
	input  reset,
	output [7:0] data_o,
	output valid_o,
	input  rx_i);

parameter CLOCKS_PER_BAUD = 6;
localparam RESET_VALUE = CLOCKS_PER_BAUD - 1;
localparam HALF_RESET_VALUE = (CLOCKS_PER_BAUD / 2) - 1;
localparam CLOCKS_PER_BAUD_BITS = $clog2(RESET_VALUE);

wire rx;
sync2ff sync_rx(.clock(clock), .in_i(rx_i), .out_o(rx));

reg [CLOCKS_PER_BAUD_BITS:0] baudcounter;
reg [2:0] bitcounter;
reg [7:0] data;

localparam STATE_IDLE = 4'b0001;
localparam STATE_WAIT = 4'b0010;
localparam STATE_BITS = 4'b0100;
localparam STATE_STOP = 4'b1000;
reg [3:0] state;

always @(posedge clock)
	if (!reset) begin
		state <= STATE_IDLE;
	end else case (state)
		STATE_IDLE:
			if (!rx) begin
				state <= STATE_WAIT;
				baudcounter <= HALF_RESET_VALUE;
			end
		STATE_WAIT:
			if (baudcounter == 0) begin
				if (rx) begin
					// False start bit
					state <= STATE_IDLE;
				end else begin
					state <= STATE_BITS;
					bitcounter <= 7;
					baudcounter <= RESET_VALUE;
				end
			end else begin
				baudcounter <= baudcounter - 1;
			end
		STATE_BITS:
			if (baudcounter == 0) begin
				data <= {rx, data[7:1]};
				baudcounter <= RESET_VALUE;
				if (bitcounter == 0) begin
					state <= STATE_STOP;
					baudcounter <= RESET_VALUE;
				end else begin
					bitcounter <= bitcounter - 1;
				end
			end else begin
				baudcounter <= baudcounter - 1;
			end
		STATE_STOP:
			if (baudcounter == 0) begin
				state <= STATE_IDLE;
			end else begin
				baudcounter <= baudcounter - 1;
			end
		default:
			state <= STATE_IDLE;
	endcase

assign valid_o = (state == STATE_STOP && baudcounter == RESET_VALUE);
assign data_o = data;

endmodule
