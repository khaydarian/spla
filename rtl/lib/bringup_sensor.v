// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module bringup_sensor(
	input  clock,
	input  pin_i,
	output sensed_o);

`ifdef VERILATOR
parameter CLOCKS_PER_DECREMENT = 10;
parameter COUNTER_BITS = 3;
`else
parameter CLOCKS_PER_DECREMENT = 12000; // 1 kHz
parameter COUNTER_BITS = 6;
`endif

// 2-flip-flop synchronizer, to avoid metastability problems.
reg pin_sync_mid;
reg pin_sync;
always @(posedge clock) begin
	pin_sync_mid <= pin_i;
	pin_sync <= pin_sync_mid;
end

// Detect transitions on the incoming signal.
reg pin_last;
always @(posedge clock)
	pin_last <= pin_sync;
wire inc;
assign inc = pin_sync ^ pin_last;

// Generate pulses on a regular frequency, but slower than bringup_driver.
localparam PULSE_RESET = CLOCKS_PER_DECREMENT - 1;
localparam PULSE_BITS = $clog2(PULSE_RESET);
reg [PULSE_BITS-1:0] pulse_counter;
reg dec;
always @(posedge clock)
	if (pulse_counter == 0) begin
		pulse_counter <= PULSE_RESET;
		dec <= 1;
	end else begin
		pulse_counter <= pulse_counter - 1;
		dec <= 0;
	end

// Counter: Count up for transition, down on regular schedule.
// Counter saturates at min and max values.
localparam COUNTER_MAX_VALUE = (1<<COUNTER_BITS)-1;
localparam COUNTER_MIN_VALUE = 0;
reg [COUNTER_BITS-1:0] counter;
always @(posedge clock) begin
	if (inc && !dec && counter != COUNTER_MAX_VALUE)
		counter <= counter + 1;
	if (!inc && dec && counter != COUNTER_MIN_VALUE)
		counter <= counter - 1;
end

// Detect when we hit the ends of the counter range, and toggle output.
// This provides hysteresis on the sensor value.
reg sensed;
always @(posedge clock) begin
	if (counter == COUNTER_MAX_VALUE)
		sensed <= 1;
	if (counter == COUNTER_MIN_VALUE)
		sensed <= 0;
end

assign sensed_o = sensed;

endmodule
