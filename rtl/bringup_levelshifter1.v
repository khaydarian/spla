// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module bringup_levelshifter1(
	// Clock input
	input  clock,

	output bodge1,
	output bodge2,
	output bodge3,
	output xin,
	
	input ppu2_vblank,
	input ppu2_hblank,
	output led7,
	output led8);

wire clock_slow;

clock_div #(.CYCLES(1200))  // 100 kHz
	clock_div(.clock(clock), .div_o(clock_slow));

assign bodge1 = clock_slow;
assign bodge2 = clock_slow;
assign bodge3 = clock_slow;
assign xin = clock_slow;

assign led7 = ppu2_vblank;
assign led8 = ppu2_hblank;

endmodule
