// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module uart_tx(
	input clock_i,
	input write_i,
	input [7:0] data_i,
	output busy_o,
	output tx_o);

parameter CLOCKS_PER_BAUD = 4;
localparam CLOCKS_PER_BAUD_BITS = $clog2(CLOCKS_PER_BAUD);

reg [CLOCKS_PER_BAUD_BITS:0] baudcounter;
reg [3:0] bitcounter;
reg [8:0] data;

initial baudcounter = 0;
initial bitcounter = 0;
initial data = 9'h1ff;

assign busy_o = (bitcounter != 0 || baudcounter != 0);

always @(posedge clock_i)
	if (!busy_o && write_i) begin
		baudcounter <= CLOCKS_PER_BAUD - 1'd1;
		bitcounter <= 10;
		data <= {data_i, 1'b0};
	end else if (baudcounter != 0)
		baudcounter <= baudcounter - 1'd1;
	else if (bitcounter != 0) begin
		baudcounter <= CLOCKS_PER_BAUD - 1'd1;
		bitcounter <= bitcounter - 1'b1;
		data <= {1'b1, data[8:1]};
	end

assign tx_o = data[0];

endmodule
