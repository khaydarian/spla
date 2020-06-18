// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module bringup(
	input  clk_12mhz,
	output led7,
	output led8,
	output [7:0] fifo_d,
	output fifo_rxf_n,
	output fifo_txe_n,
	output fifo_rd_n,
	output fifo_wr_n,
	output fifo_siwu,
	output fifo_clkout,
	output fifo_oe_n,
	input  usb_pwren_n,
	input  usb_suspend_n,
	output xin,
	output ppu1_reset_n,
	output ppu2_reset_n,
	output ppu2_resout0_n,
	output ppu2_resout1_n,
	output burst_n,
	output csync_n,
	output ppu2_hblank,
	output ppu2_vblank,
	output pard_n,
	output pawr_n,
	output lvl_pa_dir,
	output [7:0] pa,
	output lvl_pd_dir,
	output [7:0] pd,
	output lvl_va_dir,
	output vrd_n,
	output vawr_n,
	output vbwr_n,
	output va14,
	output [13:0] vaa,
	output [13:0] vab,
	output lvl_vd_dir,
	output [7:0] vda,
	output [7:0] vdb,
	output field,
	output over_n,
	output ppu_5m,
	output hcld_n,
	output vcld_n,
	output [2:0] color,
	output [1:0] prio,
	output [3:0] chr,
	output ppu2_tst15,
	output lvl_tst_dir,
	output lvl_tst_oe,
	output [14:0] ppu2_tst,
	output ppu1_extsync_n,
	output ppu1_hvcmode,
	output ppu1_master_n,
	output ppu1_palmode,
	output ppu2_3p58m,
	output ppu2_ped_n,
	output ppu2_5mout_n,
	output ppu2_toumei_n,
	output ppu2_extlatch,
	output ppu2_hvcmode,
	output ppu2_palmode,
	output extra1,
	output extra2,
	output extra3,
	output bodge1,
	output bodge2,
	output bodge3,
	output analog_clk,
	output analog_r_oe,
	output [7:0] analog_r,
	output analog_g_oe,
	output [7:0] analog_g,
	output analog_b_oe,
	output [7:0] analog_b);

wire clock;
OSCG oscg(.OSC(clock));

reg [15:0] counter_internal;
always @(posedge clock) begin
	counter_internal <= counter_internal + 1;
end
wire int = counter_internal[15];

reg [15:0] counter_external;
always @(posedge clk_12mhz) begin
	counter_external <= counter_external + 1;
end
wire ext = counter_external[15];

assign led7 = int;
assign led8 = ext;
assign fifo_d[0] = int;
assign fifo_d[1] = ~int;
assign fifo_d[2] = ext;
assign fifo_d[3] = ~ext;
assign fifo_d[4] = int;
assign fifo_d[5] = ~int;
assign fifo_d[6] = ext;
assign fifo_d[7] = ~ext;
assign fifo_rxf_n = int;
assign fifo_txe_n = int;
assign fifo_rd_n = int;
assign fifo_wr_n = int;
assign fifo_siwu = int;
assign fifo_clkout = int;
assign fifo_oe_n = int;
assign xin = int;
assign ppu1_reset_n = int;
assign ppu2_reset_n = int;
assign ppu2_resout0_n = int;
assign ppu2_resout1_n = int;
assign burst_n = int;
assign csync_n = int;
assign ppu2_hblank = int;
assign ppu2_vblank = int;
assign pard_n = int;
assign pawr_n = int;
assign lvl_pa_dir = int;
assign pa[0] = int;
assign pa[1] = int;
assign pa[2] = int;
assign pa[3] = int;
assign pa[4] = int;
assign pa[5] = int;
assign pa[6] = int;
assign pa[7] = int;
assign lvl_pd_dir = int;
assign pd[0] = int;
assign pd[1] = int;
assign pd[2] = int;
assign pd[3] = int;
assign pd[4] = int;
assign pd[5] = int;
assign pd[6] = int;
assign pd[7] = int;
assign lvl_va_dir = int;
assign vrd_n = int;
assign vawr_n = int;
assign vbwr_n = int;
assign va14 = int;
assign vaa[0] = int;
assign vaa[1] = int;
assign vaa[2] = int;
assign vaa[3] = int;
assign vaa[4] = int;
assign vaa[5] = int;
assign vaa[6] = int;
assign vaa[7] = int;
assign vaa[8] = int;
assign vaa[9] = int;
assign vaa[10] = int;
assign vaa[11] = int;
assign vaa[12] = int;
assign vaa[13] = int;
assign vab[0] = int;
assign vab[1] = int;
assign vab[2] = int;
assign vab[3] = int;
assign vab[4] = int;
assign vab[5] = int;
assign vab[6] = int;
assign vab[7] = int;
assign vab[8] = int;
assign vab[9] = int;
assign vab[10] = int;
assign vab[11] = int;
assign vab[12] = int;
assign vab[13] = int;
assign lvl_vd_dir = int;
assign vda[0] = int;
assign vda[1] = int;
assign vda[2] = int;
assign vda[3] = int;
assign vda[4] = int;
assign vda[5] = int;
assign vda[6] = int;
assign vda[7] = int;
assign vdb[0] = int;
assign vdb[1] = int;
assign vdb[2] = int;
assign vdb[3] = int;
assign vdb[4] = int;
assign vdb[5] = int;
assign vdb[6] = int;
assign vdb[7] = int;
assign field = int;
assign over_n = int;
assign ppu_5m = int;
assign hcld_n = int;
assign vcld_n = int;
assign color[0] = int;
assign color[1] = int;
assign color[2] = int;
assign prio[0] = int;
assign prio[1] = int;
assign chr[0] = int;
assign chr[1] = int;
assign chr[2] = int;
assign chr[3] = int;
assign ppu2_tst15 = int;
assign lvl_tst_dir = int;
assign lvl_tst_oe = int;
assign ppu2_tst[0] = int;
assign ppu2_tst[1] = int;
assign ppu2_tst[2] = int;
assign ppu2_tst[3] = int;
assign ppu2_tst[4] = int;
assign ppu2_tst[5] = int;
assign ppu2_tst[6] = int;
assign ppu2_tst[7] = int;
assign ppu2_tst[8] = int;
assign ppu2_tst[9] = int;
assign ppu2_tst[10] = int;
assign ppu2_tst[11] = int;
assign ppu2_tst[12] = int;
assign ppu2_tst[13] = int;
assign ppu2_tst[14] = int;
assign ppu1_extsync_n = int;
assign ppu1_hvcmode = int;
assign ppu1_master_n = int;
assign ppu1_palmode = int;
assign ppu2_3p58m = int;
assign ppu2_ped_n = int;
assign ppu2_5mout_n = int;
assign ppu2_toumei_n = int;
assign ppu2_extlatch = int;
assign ppu2_hvcmode = int;
assign ppu2_palmode = int;
assign extra1 = int;
assign extra2 = int;
assign extra3 = int;
assign bodge1 = int;
assign bodge2 = int;
assign bodge3 = int;
assign analog_clk = int;
assign analog_r_oe = int;
assign analog_r[0] = int;
assign analog_r[1] = int;
assign analog_r[2] = int;
assign analog_r[3] = int;
assign analog_r[4] = int;
assign analog_r[5] = int;
assign analog_r[6] = int;
assign analog_r[7] = int;
assign analog_g_oe = int;
assign analog_g[0] = int;
assign analog_g[1] = int;
assign analog_g[2] = int;
assign analog_g[3] = int;
assign analog_g[4] = int;
assign analog_g[5] = int;
assign analog_g[6] = int;
assign analog_g[7] = int;
assign analog_b_oe = int;
assign analog_b[0] = int;
assign analog_b[1] = int;
assign analog_b[2] = int;
assign analog_b[3] = int;
assign analog_b[4] = int;
assign analog_b[5] = int;
assign analog_b[6] = int;
assign analog_b[7] = int;

endmodule
