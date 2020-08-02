// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module fifo(
	input  clock,
	input  reset,
	input  write_i,
	input  [DATA_BITS-1:0] write_data_i,
	output write_ready_o,
	input  read_i,
	output [DATA_BITS-1:0] read_data_o,
	output read_ready_o);

parameter DATA_BITS = 8;
parameter DEPTH_BITS = 2;

localparam MEMORY_SIZE = (1<<DEPTH_BITS);

reg [DEPTH_BITS:0] read_addr;
reg [DEPTH_BITS:0] write_addr;

initial read_addr = 0;
initial write_addr = 0;

wire empty = (read_addr == write_addr);
wire full = (
	read_addr[DEPTH_BITS] != write_addr[DEPTH_BITS] &&
	read_addr[DEPTH_BITS-1:0] == write_addr[DEPTH_BITS-1:0]);

assign read_ready_o = ~empty;
assign write_ready_o = ~full;

wire do_read;
wire do_write;
assign do_read = read_i & ~empty;
assign do_write = write_i & ~full;

reg [DATA_BITS-1:0] memory [0:MEMORY_SIZE-1];

always @(posedge clock)
	if (!reset)
		read_addr <= 0;
	else if (do_read)
		read_addr <= read_addr + 1;

assign read_data_o =
	(do_read && do_write && empty)
	? write_data_i : memory[read_addr[DEPTH_BITS-1:0]];

always @(posedge clock)
	if (!reset)
		write_addr <= 0;
	else if (do_write) begin
		write_addr <= write_addr + 1;
		memory[write_addr[DEPTH_BITS-1:0]] <= write_data_i;
	end

endmodule
