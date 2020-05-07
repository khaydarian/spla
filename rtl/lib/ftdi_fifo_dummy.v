// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module ftdi_fifo_dummy(
	input  [7:0] d_in,
	output [7:0] d_out,
	output d_dir,
	input  rxf_n,
	input  txe_n,
	output rd_n,
	output wr_n,
	output siwu,
	input  clkout,
	output oe_n);

assign d_out = 8'b0;
assign d_dir = DIR_INPUT;
assign rd_n = 1'b1;
assign wr_n = 1'b1;
assign siwu = 1'b0;
assign oe_n = 1'b1;

endmodule
