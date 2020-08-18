// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module bringup_uart(
	input  clock,
	output uart_tx,
	input  uart_rx,
	output led_a,
	output led_b,
	output tp7,
	output tp8,
	input  tp9);

wire char_pulse;

pulse #(.CLOCKS_PER_PULSE(120000)) // 100 Hz
	pulse0(.clock(clock), .pulse_o(char_pulse));

reg [7:0] data;
always @(posedge clock) begin
	if (data == 0)
		data <= 65; // 'A'
	else if (char_pulse == 1) begin
		if (data == 90) // 'Z'
			data <= 65;
		else
			data <= data + 1;
	end
end

uart_tx
	#(.CLOCKS_PER_BAUD(104)) // 115200 baud
	uart_tx0(
		.clock(clock),
		.write_i(char_pulse),
		.data_i(data),
		.tx_o(uart_tx));

assign tp7 = uart_tx;

bringup_driver bringup_driver0(.clock(clock), .pin_o(tp9));
bringup_sensor bringup_sensor0(.clock(clock), .pin_i(tp8), .sensed_o(led_a));

assign led_b = 1'b1;

endmodule
