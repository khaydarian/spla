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
	output usb_pwren_n,
	output usb_suspend_n,
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

reg [15:0] counter;
wire clock;

OSCG oscg(.OSC(clock));

always @(posedge clock) begin
	counter <= counter + 1;
end

wire flash = counter[15];

assign led7 = flash;
assign led8 = ~flash;
assign fifo_d[0] = flash;
assign fifo_d[1] = flash;
assign fifo_d[2] = flash;
assign fifo_d[3] = flash;
assign fifo_d[4] = flash;
assign fifo_d[5] = flash;
assign fifo_d[6] = flash;
assign fifo_d[7] = flash;
assign fifo_rxf_n = flash;
assign fifo_txe_n = flash;
assign fifo_rd_n = flash;
assign fifo_wr_n = flash;
assign fifo_siwu = flash;
assign fifo_clkout = flash;
assign fifo_oe_n = flash;
assign usb_pwren_n = flash;
assign usb_suspend_n = flash;
assign xin = flash;
assign ppu1_reset_n = flash;
assign ppu2_reset_n = flash;
assign ppu2_resout0_n = flash;
assign ppu2_resout1_n = flash;
assign burst_n = flash;
assign csync_n = flash;
assign ppu2_hblank = flash;
assign ppu2_vblank = flash;
assign pard_n = flash;
assign pawr_n = flash;
assign lvl_pa_dir = flash;
assign pa[0] = flash;
assign pa[1] = flash;
assign pa[2] = flash;
assign pa[3] = flash;
assign pa[4] = flash;
assign pa[5] = flash;
assign pa[6] = flash;
assign pa[7] = flash;
assign lvl_pd_dir = flash;
assign pd[0] = flash;
assign pd[1] = flash;
assign pd[2] = flash;
assign pd[3] = flash;
assign pd[4] = flash;
assign pd[5] = flash;
assign pd[6] = flash;
assign pd[7] = flash;
assign lvl_va_dir = flash;
assign vrd_n = flash;
assign vawr_n = flash;
assign vbwr_n = flash;
assign va14 = flash;
assign vaa[0] = flash;
assign vaa[1] = flash;
assign vaa[2] = flash;
assign vaa[3] = flash;
assign vaa[4] = flash;
assign vaa[5] = flash;
assign vaa[6] = flash;
assign vaa[7] = flash;
assign vaa[8] = flash;
assign vaa[9] = flash;
assign vaa[10] = flash;
assign vaa[11] = flash;
assign vaa[12] = flash;
assign vaa[13] = flash;
assign vab[0] = flash;
assign vab[1] = flash;
assign vab[2] = flash;
assign vab[3] = flash;
assign vab[4] = flash;
assign vab[5] = flash;
assign vab[6] = flash;
assign vab[7] = flash;
assign vab[8] = flash;
assign vab[9] = flash;
assign vab[10] = flash;
assign vab[11] = flash;
assign vab[12] = flash;
assign vab[13] = flash;
assign lvl_vd_dir = flash;
assign vda[0] = flash;
assign vda[1] = flash;
assign vda[2] = flash;
assign vda[3] = flash;
assign vda[4] = flash;
assign vda[5] = flash;
assign vda[6] = flash;
assign vda[7] = flash;
assign vdb[0] = flash;
assign vdb[1] = flash;
assign vdb[2] = flash;
assign vdb[3] = flash;
assign vdb[4] = flash;
assign vdb[5] = flash;
assign vdb[6] = flash;
assign vdb[7] = flash;
assign field = flash;
assign over_n = flash;
assign ppu_5m = flash;
assign hcld_n = flash;
assign vcld_n = flash;
assign color[0] = flash;
assign color[1] = flash;
assign color[2] = flash;
assign prio[0] = flash;
assign prio[1] = flash;
assign chr[0] = flash;
assign chr[1] = flash;
assign chr[2] = flash;
assign chr[3] = flash;
assign ppu2_tst15 = flash;
assign lvl_tst_dir = flash;
assign lvl_tst_oe = flash;
assign ppu2_tst[0] = flash;
assign ppu2_tst[1] = flash;
assign ppu2_tst[2] = flash;
assign ppu2_tst[3] = flash;
assign ppu2_tst[4] = flash;
assign ppu2_tst[5] = flash;
assign ppu2_tst[6] = flash;
assign ppu2_tst[7] = flash;
assign ppu2_tst[8] = flash;
assign ppu2_tst[9] = flash;
assign ppu2_tst[10] = flash;
assign ppu2_tst[11] = flash;
assign ppu2_tst[12] = flash;
assign ppu2_tst[13] = flash;
assign ppu2_tst[14] = flash;
assign ppu1_extsync_n = flash;
assign ppu1_hvcmode = flash;
assign ppu1_master_n = flash;
assign ppu1_palmode = flash;
assign ppu2_3p58m = flash;
assign ppu2_ped_n = flash;
assign ppu2_5mout_n = flash;
assign ppu2_toumei_n = flash;
assign ppu2_extlatch = flash;
assign ppu2_hvcmode = flash;
assign ppu2_palmode = flash;
assign extra1 = flash;
assign extra2 = flash;
assign extra3 = flash;
assign bodge1 = flash;
assign bodge2 = flash;
assign bodge3 = flash;
assign analog_clk = flash;
assign analog_r_oe = flash;
assign analog_r[0] = flash;
assign analog_r[1] = flash;
assign analog_r[2] = flash;
assign analog_r[3] = flash;
assign analog_r[4] = flash;
assign analog_r[5] = flash;
assign analog_r[6] = flash;
assign analog_r[7] = flash;
assign analog_g_oe = flash;
assign analog_g[0] = flash;
assign analog_g[1] = flash;
assign analog_g[2] = flash;
assign analog_g[3] = flash;
assign analog_g[4] = flash;
assign analog_g[5] = flash;
assign analog_g[6] = flash;
assign analog_g[7] = flash;
assign analog_b_oe = flash;
assign analog_b[0] = flash;
assign analog_b[1] = flash;
assign analog_b[2] = flash;
assign analog_b[3] = flash;
assign analog_b[4] = flash;
assign analog_b[5] = flash;
assign analog_b[6] = flash;
assign analog_b[7] = flash;

endmodule
