// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module sync2ff(
	input  clock,
	input  in_i,
	output out_o);

reg sync;
reg out;

always @(posedge clock) begin
	sync <= in_i;
	out <= sync;
end

assign out_o = out;

endmodule
