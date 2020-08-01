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

// Combinations:
// fail -- STATE_ONEHOT LOGIC_CASE
// pass -- STATE_ONEHOT LOGIC_CASE LOGIC_CASE_DEFAULT
// fail -- STATE_ONEHOT LOGIC_IF
// pass -- STATE_ONEHOT LOGIC_IF LOGIC_IF_FINAL_ELSE
// fail -- STATE_TWOBIT LOGIC_CASE
// fail -- STATE_TWOBIT LOGIC_CASE LOGIC_CASE_DEFAULT
// fail -- STATE_TWOBIT LOGIC_IF
// pass -- STATE_TWOBIT LOGIC_IF LOGIC_IF_FINAL_ELSE

//`define STATE_ONEHOT
`define STATE_TWOBIT

//`define LOGIC_CASE
//`define LOGIC_CASE_DEFAULT
`define LOGIC_IF
`define LOGIC_IF_FINAL_ELSE

`ifdef STATE_ONEHOT
localparam STATE_IDLE = 4'b0001;
localparam STATE_WAIT = 4'b0010;
localparam STATE_BITS = 4'b0100;
localparam STATE_STOP = 4'b1000;
reg [3:0] state;
`endif
`ifdef STATE_TWOBIT
localparam STATE_IDLE = 2'b00;
localparam STATE_WAIT = 2'b01;
localparam STATE_BITS = 2'b10;
localparam STATE_STOP = 2'b11;
reg [1:0] state;
`endif

`ifdef LOGIC_CASE
always @(posedge clock)
	case (state)
		STATE_IDLE: begin
			if (!rx) begin
				state <= STATE_WAIT;
				baudcounter <= HALF_RESET_VALUE;
			end
		end
		STATE_WAIT: begin
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
		end
		STATE_BITS: begin
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
		end
		STATE_STOP: begin
			if (baudcounter == 0) begin
				state <= STATE_IDLE;
			end else begin
				baudcounter <= baudcounter - 1;
			end
		end
		`ifdef LOGIC_CASE_DEFAULT
		default: state <= STATE_IDLE;
		`endif
	endcase
`endif

`ifdef LOGIC_IF
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
	end
	`ifdef LOGIC_IF_FINAL_ELSE
	else state <= STATE_IDLE;
	`endif
`endif

assign valid_o = (state == STATE_STOP && baudcounter == RESET_VALUE);
assign data_o = data;

endmodule
