// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module ppu_interrupt(
	input  clock,
	input  reset,

	input  [7:0] int_enabled_i,
	input  int_clear_all_i,

	// bit 0: vblank rising edge
	// bit 1: vblank falling edge
	// bit 2: hblank rising edge
	// bit 3: hblank falling edge
	// bit 4: csync_n rising edge
	// bit 5: csync_n falling edge
	// bit 6: burst_n rising edge
	// bit 7: burst_n falling edge
	output [7:0] int_triggered_o,
	output int_any_triggered_o,

	input  burst_n,
	input  csync_n,
	input  hblank,
	input  vblank);

reg last_burst_n, mid_burst_n;
reg last_csync_n, mid_csync_n;
reg last_hblank, mid_hblank;
reg last_vblank, mid_vblank;
initial last_burst_n = 1;
initial mid_burst_n = 1;
initial last_csync_n = 1;
initial mid_csync_n = 1;
initial last_hblank = 0;
initial mid_hblank = 0;
initial last_vblank = 0;
initial mid_vblank = 0;

always @(posedge clock) begin
	last_burst_n <= mid_burst_n;
	last_csync_n <= mid_csync_n;
	last_hblank <= mid_hblank;
	last_vblank <= mid_vblank;
	mid_burst_n <= burst_n;
	mid_csync_n <= csync_n;
	mid_hblank <= hblank;
	mid_vblank <= vblank;
end

wire rising_burst_n;
wire falling_burst_n;
assign rising_burst_n = (burst_n & ~last_burst_n);
assign falling_burst_n = (~burst_n & last_burst_n);
wire rising_csync_n;
wire falling_csync_n;
assign rising_csync_n = (csync_n & ~last_csync_n);
assign falling_csync_n = (~csync_n & last_csync_n);
wire rising_hblank;
wire falling_hblank;
assign rising_hblank = (hblank & ~last_hblank);
assign falling_hblank = (~hblank & last_hblank);
wire rising_vblank;
wire falling_vblank;
assign rising_vblank = (vblank & ~last_vblank);
assign falling_vblank = (~vblank & last_vblank);

wire [7:0] int_immediate;
assign int_immediate = {
	falling_burst_n, rising_burst_n,
	falling_csync_n, rising_csync_n,
	falling_hblank, rising_hblank,
	falling_vblank, rising_vblank};

reg [7:0] int_triggered;
initial int_triggered = 0;
always @(posedge clock)
	if (!reset | int_clear_all_i)
		int_triggered <= 0;
	else
		int_triggered <= int_triggered | (int_enabled_i & int_immediate);

assign int_triggered_o = int_triggered;
assign int_any_triggered_o = (|int_triggered);

endmodule
