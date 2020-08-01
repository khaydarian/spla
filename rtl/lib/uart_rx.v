// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module uart_rx(
	input  clock,
	output [7:0] data_o,
	output valid_o,
	input  rx_i);

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
reg [2:0] bitcounter;
reg [7:0] data;

localparam STATE_IDLE = 2'b00;
localparam STATE_WAIT = 2'b01;
localparam STATE_BITS = 2'b10;
localparam STATE_STOP = 2'b11;
reg [1:0] state;

always @(posedge clock)
	if (state == STATE_IDLE) begin
		if (!rx) begin
			state <= STATE_WAIT;
			baudcounter <= HALF_RESET_VALUE;
		end
	end else if (state == STATE_WAIT) begin
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
	end else if (state == STATE_BITS) begin
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
	end else if (state == STATE_STOP) begin
		if (baudcounter == 0) begin
			state <= STATE_IDLE;
		end else begin
			baudcounter <= baudcounter - 1;
		end
	end else begin
		state <= STATE_IDLE;
	end

assign valid_o = (state == STATE_STOP && baudcounter == RESET_VALUE);
assign data_o = data;

endmodule
