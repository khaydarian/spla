// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module test_uart(
	input  clock,
	output uart_tx,
	input  uart_rx,
	output led7,
	output led8);

wire [7:0] incoming_data;
wire incoming_valid;
wire [7:0] outgoing_data;
wire fifo_has_space;
wire fifo_available;
wire tx_busy;

reg fifo_corked;
always @(posedge clock)
	if (incoming_valid) begin
		if (incoming_data == "e")
			fifo_corked <= 1;
		if (incoming_data == "z")
			fifo_corked <= 0;
	end

wire do_tx;
assign do_tx = fifo_available && !tx_busy && !fifo_corked;

uart_rx #(.CLOCKS_PER_BAUD(104)) // 115200 baud
	uart_rx0(
		.clock(clock),
		.data_o(incoming_data),
		.valid_o(incoming_valid),
		.rx_i(uart_rx));

fifo #(.DEPTH_BITS(5))  // 32 elements
	uart_fifo(
		.clock(clock),
		.reset(0),
		.write_i(incoming_valid),
		.write_data_i(incoming_data),
		.write_ready_o(fifo_has_space),
		.read_i(do_tx),
		.read_data_o(outgoing_data),
		.read_ready_o(fifo_available));

uart_tx #(.CLOCKS_PER_BAUD(104)) // 115200 baud
	uart_tx0(
		.clock(clock),
		.write_i(do_tx),
		.data_i(outgoing_data),
		.busy_o(tx_busy),
		.tx_o(uart_tx));

oneshot #(.CYCLES(600000)) // 50ms
	oneshot_led7(.clock(clock), .in(~uart_rx), .out(led7));

oneshot #(.CYCLES(600000)) // 50ms
	oneshot_led8(.clock(clock), .in(do_tx), .out(led8));

endmodule
