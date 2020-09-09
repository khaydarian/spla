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
	output read_ready_o,
	output error_overflow_o,
	output error_underflow_o);

parameter DATA_BITS = 8;
parameter DEPTH_BITS = 2;

localparam MEMORY_SIZE = (1<<DEPTH_BITS);

reg [DEPTH_BITS:0] read_ptr;
reg [DEPTH_BITS:0] write_ptr;
initial read_ptr = 0;
initial write_ptr = 0;
wire [DEPTH_BITS-1:0] read_addr;
wire [DEPTH_BITS-1:0] write_addr;
assign read_addr = read_ptr[DEPTH_BITS-1:0];
assign write_addr = write_ptr[DEPTH_BITS-1:0];

wire [DEPTH_BITS:0] size;
assign size = write_ptr - read_ptr;

wire empty;
assign empty = (read_ptr == write_ptr);

wire full;
assign full = (
	read_ptr[DEPTH_BITS] != write_ptr[DEPTH_BITS] &&
	read_ptr[DEPTH_BITS-1:0] == write_ptr[DEPTH_BITS-1:0]);

reg read_ready_o;
initial read_ready_o = 0;
always @(posedge clock)
	if (!reset)
		read_ready_o <= 0;
	else
		read_ready_o <= ~empty;

reg write_ready_o;
initial write_ready_o = 1;
always @(posedge clock)
	if (!reset)
		write_ready_o <= 1;
	else
		write_ready_o <= ~full;

assign error_underflow_o = read_i & ~read_ready_o;
assign error_overflow_o = write_i & ~read_i & ~write_ready_o;

reg [DATA_BITS-1:0] memory [0:MEMORY_SIZE-1];

always @(posedge clock)
	if (!reset)
		read_ptr <= 0;
	else if (read_i & ~empty)
		read_ptr <= read_ptr + 1;

reg [DATA_BITS-1:0] read_data_o;
always @(posedge clock)
	if (empty & read_i & write_i)
		read_data_o <= write_data_i;
	else
		read_data_o <= memory[read_addr];

always @(posedge clock)
	if (!reset)
		write_ptr <= 0;
	else if (write_i & read_i & full) begin
		write_ptr <= write_ptr + 1;
		memory[write_addr] <= write_data_i;
	end else if (write_i & ~full) begin
		write_ptr <= write_ptr + 1;
		memory[write_addr] <= write_data_i;
	end

endmodule
