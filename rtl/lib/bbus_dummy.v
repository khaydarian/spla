// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module bbus_dummy(
	output pard_n,
	output pawr_n,
	output lvl_pa_dir,
	inout [7:0] pa,
	output lvl_pd_dir,
	inout [7:0] pd);

assign pard_n = 1'b1;
assign pawr_n = 1'b1;
assign lvl_pa_dir = LVL_DIR_INPUT;
assign lvl_pd_dir = LVL_DIR_INPUT;
assign pa = 8'bZ;
assign pd = 8'bZ;

endmodule
