// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

`timescale 1ns/1ns

module ppu_interrupt_testbench;

initial begin
	$dumpfile("ppu_interrupt_testbench.vcd");
	$dumpvars(0, ppu_interrupt_testbench);
end

reg clock = 1;
always #5 clock = ~clock;
reg reset = 0;  // Start in reset

reg [7:0] int_enabled = 8'b0;
reg int_clear_all = 0;

reg burst_n = 1;
reg csync_n = 1;
reg vblank = 0;
reg hblank = 0;

initial begin
	#9 reset = 1;
	#10;

	#20 burst_n = 0; #30 burst_n = 1;
	#20 csync_n = 0; #30 csync_n = 1;
	#20 hblank = 1; #30 hblank = 0;
	#20 vblank = 1; #30 vblank = 0;
	#50;

	#10; int_enabled = 8'hff;
	#50;

	#20 burst_n = 0; #30 burst_n = 1;
	#20 csync_n = 0; #30 csync_n = 1;
	#20 hblank = 1; #30 hblank = 0;
	#20 vblank = 1; #30 vblank = 0;
	#50;

	#10; int_clear_all = 1;
	#10; int_clear_all = 0;
	#50;

	#20 burst_n = 0; #30 burst_n = 1;
	#20 csync_n = 0; #30 csync_n = 1;
	#20 hblank = 1; #30 hblank = 0;
	#20 vblank = 1; #30 vblank = 0;

	#50 $finish;
end

wire [7:0] int_enabled_o;
wire [7:0] int_triggered_o;
wire int_any_triggered_o;

ppu_interrupt ppu_interrupt(
	.clock(clock),
	.reset(reset),
	.int_enabled_i(int_enabled),
	.int_clear_all_i(int_clear_all),
	.int_triggered_o(int_triggered_o),
	.int_any_triggered_o(int_any_triggered_o),
	.burst_n(burst_n),
	.csync_n(csync_n),
	.hblank(hblank),
	.vblank(vblank));

endmodule
