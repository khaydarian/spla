// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module fifo_dummy(
	inout [7:0] d,
	input rxf_n,
	input txe_n,
	output rd_n,
	output wr_n,
	output siwu,
	input clkout,
	output oe_n);

assign d = 8'bZ;
assign rd_n = 1'b1;
assign wr_n = 1'b1;
assign siwu = 1'b0;
assign oe_n = 1'b1;

endmodule
