// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module test_uart(
	input  clock,
	output uart_tx,
	input  uart_rx);

reg output_blocked;

wire [7:0] incoming_data;
wire [7:0] outgoing_data;
wire incoming_valid;
wire fifo_has_space;
wire can_tx;
wire tx_busy;
wire fifo_available;

always @(posedge clock) begin
	if (incoming_valid) begin
		if (incoming_data == "Z")
			output_blocked <= 1;
		if (incoming_data == "z")
			output_blocked <= 0;
	end
end

assign can_tx = fifo_available && !output_blocked;

uart_rx #(.CLOCKS_PER_BAUD(104)) // 115200 baud
	uart_rx0(
		.clock(clock),
		.data_o(incoming_data),
		.valid_o(incoming_valid),
		.rx_i(uart_rx));

sync_fifo #(.DEPTH_BITS(4))
	uart_fifo(
		.clock(clock),
		.write_i(incoming_data),
		.write_data_i(incoming_valid),
		.write_ready_o(fifo_has_space),
		.read_i(can_tx),
		.read_data_o(outgoing_data),
		.read_ready_o(fifo_available));

uart_tx #(.CLOCKS_PER_BAUD(104)) // 115200 baud
	uart_tx0(
		.clock(clock),
		.write_i(can_tx),
		.data_i(outgoing_data),
		.busy_o(tx_busy),
		.tx_o(uart_tx));

endmodule
