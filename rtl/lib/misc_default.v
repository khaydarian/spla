// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module misc_default(
	output ppu1_extsync_n,
	output ppu1_hvcmode,
	output ppu1_master_n,
	output ppu1_palmode,
	output ppu2_extlatch,
	output ppu2_hvcmode,
	output ppu2_palmode);

assign ppu1_extsync_n = 1'b1;
assign ppu1_hvcmode = 1'b0;
assign ppu1_master_n = 1'b0;
assign ppu1_palmode = 1'b0;
assign ppu2_extlatch = 1'b0; // Note: Not sure if active-high
assign ppu2_hvcmode = 1'b0;
assign ppu2_palmode = 1'b0;

endmodule
