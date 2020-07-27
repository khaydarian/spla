// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module bringup_levelshifter2(
	// Clock input
	input  clock,

	// Direction pins
	output lvl_pa_dir,
	output lvl_pd_dir,
	output lvl_va_dir,
	output lvl_vd_dir,
	output lvl_tst_dir,
	output lvl_tst_oe,

	// All output-only pins in standard order.
	output xin,
	output ppu1_reset_n,
	output ppu2_reset_n,
	output pard_n,
	output pawr_n,
	output ppu2_tst15,
	output ppu1_extsync_n,
	output ppu1_hvcmode,
	output ppu1_master_n,
	output ppu1_palmode,
	output ppu2_extlatch,
	output ppu2_hvcmode,
	output ppu2_palmode,
	output bodge1,
	output bodge2,
	output bodge3);

wire write_pulse;

pulse
	#(.CLOCKS_PER_PULSE(120000)) // 100 Hz
	pulse0(.clock(clock), .pulse_o(write_pulse));

// Drive all bidirectional level shifters as outputs.
assign lvl_pa_dir = LVL_DIR_OUTPUT;
assign lvl_pd_dir = LVL_DIR_OUTPUT;
assign lvl_va_dir = LVL_DIR_OUTPUT;
assign lvl_vd_dir = LVL_DIR_OUTPUT;
assign lvl_tst_dir = LVL_DIR_OUTPUT;
assign lvl_tst_oe = 1; // 1 == disabled

wire [7:0] data_xin;
wire [7:0] data_ppu1_reset_n;
wire [7:0] data_ppu2_reset_n;
wire [7:0] data_pard_n;
wire [7:0] data_pawr_n;
wire [7:0] data_ppu2_tst15;
wire [7:0] data_ppu1_extsync_n;
wire [7:0] data_ppu1_hvcmode;
wire [7:0] data_ppu1_master_n;
wire [7:0] data_ppu1_palmode;
wire [7:0] data_ppu2_extlatch;
wire [7:0] data_ppu2_hvcmode;
wire [7:0] data_ppu2_palmode;
wire [7:0] data_bodge1;
wire [7:0] data_bodge2;
wire [7:0] data_bodge3;

assign data_xin            = 8'b01000101;
assign data_ppu1_reset_n   = 8'b01001001;
assign data_ppu2_reset_n   = 8'b01001101;
assign data_pard_n         = 8'b01010001;
assign data_pawr_n         = 8'b01010101;
assign data_ppu2_tst15     = 8'b01011001;
assign data_ppu1_extsync_n = 8'b01011101;
assign data_ppu1_hvcmode   = 8'b01100001;
assign data_ppu1_master_n  = 8'b01100101;
assign data_ppu1_palmode   = 8'b01101001;
assign data_ppu2_extlatch  = 8'b01101101;
assign data_ppu2_hvcmode   = 8'b01110001;
assign data_ppu2_palmode   = 8'b01110101;
assign data_bodge1         = 8'b01111001;
assign data_bodge2         = 8'b01111101;
assign data_bodge3         = 8'b01000001;

uart_tx #(.CLOCKS_PER_BAUD(104)) // 115200 baud
	uart_xin(
		.clock_i(clock),
		.write_i(write_pulse),
		.data_i(data_xin),
		.tx_o(xin));

uart_tx #(.CLOCKS_PER_BAUD(104)) // 115200 baud
	uart_ppu1_reset_n(
		.clock_i(clock),
		.write_i(write_pulse),
		.data_i(data_ppu1_reset_n),
		.tx_o(ppu1_reset_n));

uart_tx #(.CLOCKS_PER_BAUD(104)) // 115200 baud
	uart_ppu2_reset_n(
		.clock_i(clock),
		.write_i(write_pulse),
		.data_i(data_ppu2_reset_n),
		.tx_o(ppu2_reset_n));

uart_tx #(.CLOCKS_PER_BAUD(104)) // 115200 baud
	uart_pard_n(
		.clock_i(clock),
		.write_i(write_pulse),
		.data_i(data_pard_n),
		.tx_o(pard_n));

uart_tx #(.CLOCKS_PER_BAUD(104)) // 115200 baud
	uart_pawr_n(
		.clock_i(clock),
		.write_i(write_pulse),
		.data_i(data_pawr_n),
		.tx_o(pawr_n));

uart_tx #(.CLOCKS_PER_BAUD(104)) // 115200 baud
	uart_ppu2_tst15(
		.clock_i(clock),
		.write_i(write_pulse),
		.data_i(data_ppu2_tst15),
		.tx_o(ppu2_tst15));

uart_tx #(.CLOCKS_PER_BAUD(104)) // 115200 baud
	uart_ppu1_extsync_n(
		.clock_i(clock),
		.write_i(write_pulse),
		.data_i(data_ppu1_extsync_n),
		.tx_o(ppu1_extsync_n));

uart_tx #(.CLOCKS_PER_BAUD(104)) // 115200 baud
	uart_ppu1_hvcmode(
		.clock_i(clock),
		.write_i(write_pulse),
		.data_i(data_ppu1_hvcmode),
		.tx_o(ppu1_hvcmode));

uart_tx #(.CLOCKS_PER_BAUD(104)) // 115200 baud
	uart_ppu1_master_n(
		.clock_i(clock),
		.write_i(write_pulse),
		.data_i(data_ppu1_master_n),
		.tx_o(ppu1_master_n));

uart_tx #(.CLOCKS_PER_BAUD(104)) // 115200 baud
	uart_ppu1_palmode(
		.clock_i(clock),
		.write_i(write_pulse),
		.data_i(data_ppu1_palmode),
		.tx_o(ppu1_palmode));

uart_tx #(.CLOCKS_PER_BAUD(104)) // 115200 baud
	uart_ppu2_extlatch(
		.clock_i(clock),
		.write_i(write_pulse),
		.data_i(data_ppu2_extlatch),
		.tx_o(ppu2_extlatch));

uart_tx #(.CLOCKS_PER_BAUD(104)) // 115200 baud
	uart_ppu2_hvcmode(
		.clock_i(clock),
		.write_i(write_pulse),
		.data_i(data_ppu2_hvcmode),
		.tx_o(ppu2_hvcmode));

uart_tx #(.CLOCKS_PER_BAUD(104)) // 115200 baud
	uart_ppu2_palmode(
		.clock_i(clock),
		.write_i(write_pulse),
		.data_i(data_ppu2_palmode),
		.tx_o(ppu2_palmode));

uart_tx #(.CLOCKS_PER_BAUD(104)) // 115200 baud
	uart_bodge1(
		.clock_i(clock),
		.write_i(write_pulse),
		.data_i(data_bodge1),
		.tx_o(bodge1));

uart_tx #(.CLOCKS_PER_BAUD(104)) // 115200 baud
	uart_bodge2(
		.clock_i(clock),
		.write_i(write_pulse),
		.data_i(data_bodge2),
		.tx_o(bodge2));

uart_tx #(.CLOCKS_PER_BAUD(104)) // 115200 baud
	uart_bodge3(
		.clock_i(clock),
		.write_i(write_pulse),
		.data_i(data_bodge3),
		.tx_o(bodge3));

endmodule
