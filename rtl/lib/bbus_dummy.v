// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module bbus_dummy(
	output pard_n,
	output pawr_n,
	output lvl_pa_dir,
	input  [7:0] pa_in,
	output [7:0] pa_out,
	output pa_dir,
	output lvl_pd_dir,
	input  [7:0] pd_in,
	output [7:0] pd_out,
	output pd_dir);

assign pard_n = 1'b1;
assign pawr_n = 1'b1;
assign lvl_pa_dir = LVL_DIR_INPUT;
assign lvl_pd_dir = LVL_DIR_INPUT;
assign pa_out = 8'b0;
assign pa_dir = DIR_INPUT;
assign pd_out = 8'b0;
assign pd_dir = DIR_INPUT;

endmodule
