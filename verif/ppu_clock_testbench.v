// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

`timescale 1ns/1ns

module ppu_clock_testbench;

initial begin
	$dumpfile("ppu_clock_testbench.vcd");
	$dumpvars(0, ppu_clock_testbench);
end

reg clock = 1;
always #5 clock = ~clock;

reg reset = 0;  // Start in reset
reg xin_stall = 1;  // Start stalled

initial begin
	#10 reset = 1;
	#50;
	xin_stall = 0; #400 xin_stall = 1; #100;
	#10 reset = 0; #10 reset = 1; #100;
	xin_stall = 0; #200 xin_stall = 1; #200;
	xin_stall = 0; #210 xin_stall = 1; #200;
	xin_stall = 0; #220 xin_stall = 1; #200;
	xin_stall = 0; #230 xin_stall = 1; #200;
	xin_stall = 0; #240 xin_stall = 1; #200;
	xin_stall = 0; #250 xin_stall = 1; #200;
	xin_stall = 0; #260 xin_stall = 1; #200;
	xin_stall = 0; #270 xin_stall = 1; #200;
	xin_stall = 0; #280 xin_stall = 1; #200;
	xin_stall = 0; #290 xin_stall = 1; #200;
	xin_stall = 0; #300 xin_stall = 1; #200;
	xin_stall = 0; #310 xin_stall = 1; #200;

	#50 $finish;
end

wire [31:0] xin_counter;
wire xin;

ppu_clock ppu_clock(
	.clock(clock),
	.reset(reset),
	.xin(xin),
	.xin_counter_o(xin_counter),
	.xin_stall_i(xin_stall));

endmodule
