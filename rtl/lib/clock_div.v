// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module clock_div(
	input  clock,
	output div_o);

parameter CYCLES = 12000000;
localparam RESET_VAL = CYCLES / 2;
localparam BITS = $clog2(RESET_VAL);

reg [BITS-1:0] counter;
reg divided;

always @(posedge clock) begin
	if (counter == 0) begin
		counter <= RESET_VAL;
		divided <= ~divided;
	end else begin
		counter <= counter - 1;
	end
end

assign div_o = divided;

endmodule
