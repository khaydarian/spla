// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module unreset_by_uart(
	input  clock,
	input  uart_rx,
	output reset);

parameter DELAY_BITS = 16;  // 12MHz / 65536 == ~5.46 ms
localparam DELAY_MAX = (1 << DELAY_BITS) - 1;

reg [DELAY_BITS-1:0] delay;
initial delay = 0;

reg reset; // active low
initial reset = 0;

always @(posedge clock)
	if (!reset) begin
		if (delay == DELAY_MAX)
			reset <= 1;
		else if (!uart_rx)
			delay <= 0;
		else
			delay <= delay + 1;
	end

endmodule
