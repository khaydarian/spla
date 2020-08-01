// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module test_uart(
	input  clock,
	output uart_tx,
	input  uart_rx,
	output led7,
	output led8);

reg [7:0] incoming_data;
reg incoming_valid;

uart_rx #(.CLOCKS_PER_BAUD(104)) // 115200 baud
	uart_rx0(
		.clock(clock),
		.data_o(incoming_data),
		.valid_o(incoming_valid),
		.rx_i(uart_rx)
		);

uart_tx #(.CLOCKS_PER_BAUD(104)) // 115200 baud
	uart_tx0(
		.clock(clock),
		.write_i(incoming_valid),
		.data_i(incoming_data),
		.tx_o(uart_tx));

oneshot #(.CYCLES(600000)) // 50ms
	oneshot_led7(.clock(clock), .in(~uart_rx), .out(led7));

oneshot #(.CYCLES(600000)) // 50ms
	oneshot_led8(.clock(clock), .in(incoming_valid), .out(led8));

endmodule
