// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module vram_dummy(
	output lvl_va_dir,
	input  vrd_n_in,
	output vrd_n_out,
	output vrd_n_dir,
	input  vawr_n_in,
	output vawr_n_out,
	output vawr_n_dir,
	input  vbwr_n_in,
	output vbwr_n_out,
	output vbwr_n_dir,
	input  va14_in,
	output va14_out,
	input  va14_dir,
	input  [13:0] vaa_in,
	output [13:0] vaa_out,
	input  vaa_dir,
	input  [13:0] vab_in,
	output [13:0] vab_out,
	input  vab_dir,
	output lvl_vd_dir,
	input  [7:0] vda_in,
	output [7:0] vda_out,
	input  vda_dir,
	input  [7:0] vdb_in,
	output [7:0] vdb_out,
	input  vdb_dir,
	);

assign lvl_va_dir = LVL_DIR_INPUT;
assign vrd_n_out = 1'b1;
assign vrd_n_dir = DIR_INPUT;
assign vawr_n_out= 1'b1;
assign vawr_n_dir= DIR_INPUT;
assign vbwr_n_out = 1'b1;
assign vbwr_n_dir = DIR_INPUT;
assign va14_out = 1'b0;
assign va14_dir = DIR_INPUT;
assign vaa_out = 14'b0;
assign vaa_dir = DIR_INPUT;
assign vab_out = 14'b0;
assign vab_dir = DIR_INPUT;
assign lvl_vd_dir = LVL_DIR_INPUT;
assign vda_out = 8'b0;
assign vda_dir = DIR_INPUT;
assign vdb_out = 8'b0;
assign vdb_dir = DIR_INPUT;

endmodule
