// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module bringup_uart(
	input  clk,
	output uart_tx,
	input  uart_rx,
	output led7,
	output led8);

assign led7 = 1'b1;
assign led8 = 1'b1;

localparam PULSE_RESET = 12000000;  // 1 Hz
localparam PULSE_BITS = $clog2(PULSE_RESET);
reg [PULSE_BITS-1:0] pulse_counter;
reg pulse;
always @(posedge clk) begin
	if (pulse_counter == 0) begin
		pulse_counter <= PULSE_RESET;
		pulse <= 1;
	end else begin
		pulse_counter <= pulse_counter - 1;
		pulse <= 0;
	end
end

reg [7:0] data;
always @(posedge clk) begin
	if (data == 0)
		data <= 65; // 'A'
	else if (pulse == 1) begin
		if (data == 90) // 'Z'
			data <= 65;
		else
			data <= data + 1;
	end
end

uart_tx #(.CLOCKS_PER_BAUD(104)) // 115200 baud
	utx(.clk_i(clk), .write_i(pulse), .data_i(data), .tx_o(uart_tx));

endmodule
