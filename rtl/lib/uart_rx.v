// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module uart_rx(
	input clock,
	output [7:0] data_o,
	output valid_o,
	input rx_i);

parameter CLOCKS_PER_BAUD = 6;
localparam RESET_VALUE = CLOCKS_PER_BAUD - 1;
localparam HALF_RESET_VALUE = (CLOCKS_PER_BAUD / 2) - 1;
localparam CLOCKS_PER_BAUD_BITS = $clog2(RESET_VALUE);

// 2FF synchronizer
reg rx_sync;
reg rx;
always @(posedge clock) begin
	rx_sync <= rx_i;
	rx <= rx_sync;
end

reg [CLOCKS_PER_BAUD_BITS:0] baudcounter;
reg [3:0] bitcounter;
reg [7:0] data;

localparam STATE_IDLE = 0;
localparam STATE_HALFWAIT = 1;
localparam STATE_BITS = 2;
localparam STATE_STOP = 3;
reg [1:0] state;

always @(posedge clock)
	case (state)
		STATE_IDLE: begin
			if (!rx) begin
				state <= STATE_HALFWAIT;
				baudcounter <= HALF_RESET_VALUE;
			end
		end
		STATE_HALFWAIT: begin
			if (baudcounter == 0) begin
				if (rx) begin
					// False start bit
					state <= STATE_IDLE;
				end else begin
					state <= STATE_BITS;
					bitcounter <= 7;
					baudcounter <= RESET_VALUE;
				end
			end else
				baudcounter <= baudcounter - 1;
		end
		STATE_BITS: begin
			if (baudcounter == 0) begin
				data <= {rx, data[7:1]};
				baudcounter <= RESET_VALUE;
				if (bitcounter == 0) begin
					state <= STATE_STOP;
					baudcounter <= RESET_VALUE;
				end else
					bitcounter <= bitcounter - 1;
				end
			else
				baudcounter <= baudcounter - 1;
		end
		STATE_STOP: begin
			if (baudcounter == 0)
				state <= STATE_IDLE;
			else
				baudcounter <= baudcounter - 1;
		end
	endcase

assign valid_o = (state == STATE_STOP && baudcounter == RESET_VALUE);
assign data_o = data;

endmodule
