// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module vram_dummy(
	output vrd_n,
	output vawr_n,
	output vbwr_n,
	output lvl_va_dir,
	inout va14,
	inout [13:0] vaa,
	inout [13:0] vab,
	output lvl_vd_dir,
	inout [7:0] vda,
	inout [7:0] vdb);

assign vrd_n = 1'b1;
assign vawr_n = 1'b1;
assign vbwr_n = 1'b1;
assign lvl_va_dir = LVL_DIR_INPUT;
assign va14 = 1'bZ;
assign vaa = 14'bZ;
assign vab = 14'bZ;
assign lvl_vd_dir = LVL_DIR_INPUT;
assign vda = 8'bZ;
assign vdb = 8'bZ;

endmodule
