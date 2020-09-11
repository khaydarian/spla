// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module lowspeed(
	// 12MHz Clock input
	input  clock,

	// UART
	output uart_tx,
	input  uart_rx,

	// SNES Master clock
	output xin,

	// SNES reset
	output ppu1_reset_n,
	output ppu2_reset_n,

	// Direction pins
	output lvl_va_dir,
	output lvl_vd_dir,
	output lvl_pa_dir,
	output lvl_pd_dir,
	output lvl_tst_dir,
	output lvl_tst_oe,

	// LEDs
	output led_a,
	output led_b,
	output led_c,
	output led_d);

wire reset;
unreset_by_uart unreset(.clock(clock), .uart_rx(uart_rx), .reset(reset));

// UART RX/TX wiring.
wire [7:0] incoming_data;
wire incoming_valid;
wire [7:0] outgoing_data;
wire outgoing_valid;
wire tx_busy;

// UART RX
uart_rx #(.CLOCKS_PER_BAUD(104)) // 115200 baud
	uart_rx0(
		.clock(clock),
		.reset(reset),
		.data_o(incoming_data),
		.valid_o(incoming_valid),
		.rx_i(uart_rx));

// UART TX
uart_tx #(.CLOCKS_PER_BAUD(104)) // 115200 baud
	uart_tx0(
		.clock(clock),
		.write_i(outgoing_valid),
		.data_i(outgoing_data),
		.busy_o(tx_busy),
		.tx_o(uart_tx));

wire core_ready;

// Core state machine
lowspeed_core lowspeed_core0(
	.clock(clock),
	.reset(reset),
	.read_data_i(incoming_data),
	.read_valid_i(incoming_valid),
	.read_ready_o(core_ready),
	.write_data_o(outgoing_data),
	.write_valid_o(outgoing_valid),
	.write_ready_i(~tx_busy),

	.error_bad_state_o(error_bad_state),
	.error_bad_opcode_o(error_bad_opcode),

	.led_a(led_a_value),
	.led_b(led_b_value),
	.led_c(led_c_value),
	.led_d(led_d_value),
	);

// Temporary; hold SNES in reset
assign ppu1_reset_n = 0;
assign ppu2_reset_n = 0;
assign lvl_va_dir = 1'b0; // input
assign lvl_vd_dir = 1'b0; // input
assign lvl_pa_dir = 1'b0; // input
assign lvl_pd_dir = 1'b0; // input
assign lvl_tst_dir = 1'b0; // input
assign lvl_tst_oe = 1'b1; // disabled

wire error_overrun;
assign error_overrun = incoming_valid & ~core_ready;

wire error_bad_state;
wire error_bad_opcode;

wire led_a_value;
wire led_b_value;
wire led_c_value;
wire led_d_value;

// LED driver, with error override
led_errors led_errors0(
	.clock(clock),
	.reset(reset),
	.error_word_i(error_word),
	.led_a_value_i(led_a_value),
	.led_b_value_i(led_b_value),
	.led_c_value_i(led_c_value),
	.led_d_value_i(led_d_value),
	.led_a_pin_o(led_a),
	.led_b_pin_o(led_b),
	.led_c_pin_o(led_c),
	.led_d_pin_o(led_d));

wire [7:0] error_word = {
	5'd0,
	error_overrun,
	error_bad_opcode,
	error_bad_state};

endmodule
