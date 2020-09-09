// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

`timescale 1ns/1ns

module fifo_testbench;

initial begin
	$dumpfile("fifo_testbench.vcd");
	$dumpvars(0, fifo_testbench);
end

reg clock = 1;
always #5 clock = ~clock;

reg reset = 0;  // Start in reset
reg [7:0] write_data = 8'bz;
reg write_strobe = 0;
reg read_strobe = 0;
reg [7:0] expect_read_data = 8'bz;
reg expect_overflow = 0;
reg expect_underflow = 0;

initial begin
	#10 reset = 1;
	#30;
	#10 write_strobe = 1; write_data = 8'd65;
	#10 write_strobe = 0; write_data = 8'bz;
	#30;
	#10 read_strobe = 1; expect_read_data = 8'd65;
	#10 read_strobe = 0; expect_read_data = 8'bz;
	#30;
	#10 write_strobe = 1; write_data = 8'd65;
	#10 write_strobe = 0; write_data = 8'bz;
	#10 write_strobe = 1; write_data = 8'd66;
	#10 write_strobe = 1; write_data = 8'd67;
	#10 write_strobe = 1; write_data = 8'd68;
	#10 write_strobe = 0; write_data = 8'bz;
	#10 write_strobe = 1; write_data = 8'd88; expect_overflow = 1;
	#10 write_strobe = 0; write_data = 8'bz; expect_overflow = 0;
	#40;
	#10 read_strobe = 1; expect_read_data = 8'd65;
	#10 read_strobe = 0; expect_read_data = 8'bz;
	#10 read_strobe = 1; expect_read_data = 8'd66;
	#10 read_strobe = 1; expect_read_data = 8'd67;
	#10 read_strobe = 1; expect_read_data = 8'd68;
	#10 read_strobe = 0; expect_read_data = 8'bz;
	#10 read_strobe = 1; expect_read_data = 8'bx; expect_underflow = 1;
	#10 read_strobe = 0; expect_read_data = 8'bz; expect_underflow = 0;
	#40;
	#10 write_strobe = 1; write_data = 8'd65; read_strobe = 0; expect_read_data = 8'bz;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 1; expect_read_data = 8'd65;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 0; expect_read_data = 8'bz;
	#10 write_strobe = 1; write_data = 8'd66; read_strobe = 0; expect_read_data = 8'bz;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 0; expect_read_data = 8'bz;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 1; expect_read_data = 8'd66;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 0; expect_read_data = 8'bz;
	#10 write_strobe = 1; write_data = 8'd67; read_strobe = 0; expect_read_data = 8'bz;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 0; expect_read_data = 8'bz;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 0; expect_read_data = 8'bz;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 1; expect_read_data = 8'd67;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 0; expect_read_data = 8'bz;
	#40;
	#10 write_strobe = 1; write_data = 8'd65; read_strobe = 0; expect_read_data = 8'bz;
	#10 write_strobe = 1; write_data = 8'd66; read_strobe = 1; expect_read_data = 8'd65;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 1; expect_read_data = 8'd66;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 0; expect_read_data = 8'bz;
	#40;
	#10 write_strobe = 1; write_data = 8'd65; read_strobe = 0; expect_read_data = 8'bz;
	#10 write_strobe = 1; write_data = 8'd66; read_strobe = 1; expect_read_data = 8'd65;
	#10 write_strobe = 1; write_data = 8'd67; read_strobe = 1; expect_read_data = 8'd66;
	#10 write_strobe = 1; write_data = 8'd68; read_strobe = 1; expect_read_data = 8'd67;
	#10 write_strobe = 1; write_data = 8'd69; read_strobe = 1; expect_read_data = 8'd68;
	#10 write_strobe = 1; write_data = 8'd70; read_strobe = 1; expect_read_data = 8'd69;
	#10 write_strobe = 1; write_data = 8'd71; read_strobe = 1; expect_read_data = 8'd70;
	#10 write_strobe = 1; write_data = 8'd72; read_strobe = 1; expect_read_data = 8'd71;
	#10 write_strobe = 1; write_data = 8'd73; read_strobe = 1; expect_read_data = 8'd72;
	#10 write_strobe = 1; write_data = 8'd74; read_strobe = 1; expect_read_data = 8'd73;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 1; expect_read_data = 8'd74;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 0; expect_read_data = 8'bz;
	#40;
	#10 write_strobe = 1; write_data = 8'd65; read_strobe = 0; expect_read_data = 8'bz;
	#10 write_strobe = 1; write_data = 8'd66; read_strobe = 0; expect_read_data = 8'bz;
	#10 write_strobe = 1; write_data = 8'd67; read_strobe = 1; expect_read_data = 8'd65;
	#10 write_strobe = 1; write_data = 8'd68; read_strobe = 1; expect_read_data = 8'd66;
	#10 write_strobe = 1; write_data = 8'd69; read_strobe = 1; expect_read_data = 8'd67;
	#10 write_strobe = 1; write_data = 8'd70; read_strobe = 1; expect_read_data = 8'd68;
	#10 write_strobe = 1; write_data = 8'd71; read_strobe = 1; expect_read_data = 8'd69;
	#10 write_strobe = 1; write_data = 8'd72; read_strobe = 1; expect_read_data = 8'd70;
	#10 write_strobe = 1; write_data = 8'd73; read_strobe = 1; expect_read_data = 8'd71;
	#10 write_strobe = 1; write_data = 8'd74; read_strobe = 1; expect_read_data = 8'd72;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 1; expect_read_data = 8'd73;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 1; expect_read_data = 8'd74;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 0; expect_read_data = 8'bz;
	#40;
	#10 write_strobe = 1; write_data = 8'd65; read_strobe = 0; expect_read_data = 8'bz;
	#10 write_strobe = 1; write_data = 8'd66; read_strobe = 0; expect_read_data = 8'bz;
	#10 write_strobe = 1; write_data = 8'd67; read_strobe = 0; expect_read_data = 8'bz;
	#10 write_strobe = 1; write_data = 8'd68; read_strobe = 1; expect_read_data = 8'd65;
	#10 write_strobe = 1; write_data = 8'd69; read_strobe = 1; expect_read_data = 8'd66;
	#10 write_strobe = 1; write_data = 8'd70; read_strobe = 1; expect_read_data = 8'd67;
	#10 write_strobe = 1; write_data = 8'd71; read_strobe = 1; expect_read_data = 8'd68;
	#10 write_strobe = 1; write_data = 8'd72; read_strobe = 1; expect_read_data = 8'd69;
	#10 write_strobe = 1; write_data = 8'd73; read_strobe = 1; expect_read_data = 8'd70;
	#10 write_strobe = 1; write_data = 8'd74; read_strobe = 1; expect_read_data = 8'd71;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 1; expect_read_data = 8'd72;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 1; expect_read_data = 8'd73;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 1; expect_read_data = 8'd74;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 0; expect_read_data = 8'bz;
	#40;
	#10 write_strobe = 1; write_data = 8'd65; read_strobe = 0; expect_read_data = 8'bz;
	#10 write_strobe = 1; write_data = 8'd66; read_strobe = 0; expect_read_data = 8'bz;
	#10 write_strobe = 1; write_data = 8'd67; read_strobe = 0; expect_read_data = 8'bz;
	#10 write_strobe = 1; write_data = 8'd68; read_strobe = 0; expect_read_data = 8'bz;
	#10 write_strobe = 1; write_data = 8'd69; read_strobe = 1; expect_read_data = 8'd65;
	#10 write_strobe = 1; write_data = 8'd70; read_strobe = 1; expect_read_data = 8'd66;
	#10 write_strobe = 1; write_data = 8'd71; read_strobe = 1; expect_read_data = 8'd67;
	#10 write_strobe = 1; write_data = 8'd72; read_strobe = 1; expect_read_data = 8'd68;
	#10 write_strobe = 1; write_data = 8'd73; read_strobe = 1; expect_read_data = 8'd69;
	#10 write_strobe = 1; write_data = 8'd74; read_strobe = 1; expect_read_data = 8'd70;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 1; expect_read_data = 8'd71;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 1; expect_read_data = 8'd72;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 1; expect_read_data = 8'd73;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 1; expect_read_data = 8'd74;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 0; expect_read_data = 8'bz;
	#40;
	#10 write_strobe = 1; write_data = 8'd65; read_strobe = 0; expect_read_data = 8'bz;
	#10 write_strobe = 1; write_data = 8'd66; read_strobe = 0; expect_read_data = 8'bz;
	#10 write_strobe = 1; write_data = 8'd67; read_strobe = 0; expect_read_data = 8'bz;
	#10 write_strobe = 1; write_data = 8'd68; read_strobe = 0; expect_read_data = 8'bz;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 0; expect_read_data = 8'bz;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 1; expect_read_data = 8'd65;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 0; expect_read_data = 8'bz;
	#10 write_strobe = 1; write_data = 8'd69; read_strobe = 0; expect_read_data = 8'bz;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 0; expect_read_data = 8'bz;
	#10 write_strobe = 1; write_data = 8'd70; read_strobe = 1; expect_read_data = 8'd66;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 1; expect_read_data = 8'd67;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 1; expect_read_data = 8'd68;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 1; expect_read_data = 8'd69;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 1; expect_read_data = 8'd70;
	#10 write_strobe = 0; write_data = 8'bz;  read_strobe = 0; expect_read_data = 8'bz;

	#50 $finish;
end

wire tb_read_PASS;
assign tb_read_PASS = (
	(expect_read_data === 8'bz) ||
	(read_data === expect_read_data) ||
	(expect_read_data === 8'bx && ~read_ready)) ? 1'bz : 1'bx;
wire tb_overflow_PASS = (expect_overflow == error_overflow) ? 1'bz : 1'bx;
wire tb_underflow_PASS = (expect_underflow == error_underflow) ? 1'bz : 1'bx;

wire write_ready;
wire [7:0] read_data;
wire read_ready;

wire error_overflow;
wire error_underflow;

fifo #(.DATA_BITS(8), .DEPTH_BITS(2))
	fx_fifo(
		.clock(clock),
		.reset(reset),
		.write_i(write_strobe),
		.write_data_i(write_data),
		.write_ready_o(write_ready),
		.read_i(read_strobe),
		.read_data_o(read_data),
		.read_ready_o(read_ready),
		.error_underflow_o(error_underflow),
		.error_overflow_o(error_overflow));

endmodule
