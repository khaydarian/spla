// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module lowspeed_core(
	input  clock,
	input  reset,

	// Control/Data interface
	input  [7:0] read_data_i,
	input  read_valid_i,
	output read_ready_o,
	output [7:0] write_data_o,
	output write_valid_o,
	input  write_ready_i,

	// Error signals
	output error_bad_state_o,
	output error_bad_opcode_o,

	// Output LEDs
	output led_a,
	output led_b,
	output led_c,
	output led_d,
	);

// Commands
reg [7:0] opcode;

localparam OPCODE_NOOP               = 8'h00;
localparam OPCODE_ECHO               = 8'h01;
localparam OPCODE_ABSORB             = 8'h02;
localparam OPCODE_GENERATE           = 8'h03;
localparam OPCODE_SET_LEDS           = 8'h0e;
localparam OPCODE_RESET              = 8'h0f;

// Error registers
reg reg_error_bad_state;
initial reg_error_bad_state = 0;
assign error_bad_state_o = reg_error_bad_state;

reg reg_error_bad_opcode;
initial reg_error_bad_opcode = 0;
assign error_bad_opcode_o = reg_error_bad_opcode;

// State Machine.
localparam STATE_IDLE    = 6'b001;
localparam STATE_EXECUTE = 6'b010;
localparam STATE_OUTPUT  = 6'b100;
reg [2:0] state;
initial state = STATE_IDLE;

always @(posedge clock)
	if (!reset)
		state <= STATE_IDLE;
	else case (state)
		STATE_IDLE: begin
			if (read_valid_i) begin
				opcode <= read_data_i;
				state <= STATE_EXECUTE;
			end
		end
		STATE_EXECUTE: begin
			case (opcode)
				OPCODE_NOOP: begin
					state <= STATE_IDLE;
				end
				OPCODE_ECHO: begin
					if (read_valid_i) begin
						out_data <= read_data_i;
						state <= STATE_OUTPUT;
					end
				end
				OPCODE_SET_LEDS: begin
					if (read_valid_i) begin
						leds <= read_data_i[3:0];
						state = STATE_IDLE;
					end
				end
				default: begin
					reg_error_bad_opcode <= 1;
					state <= STATE_IDLE;
				end
			endcase
		end
		STATE_OUTPUT: begin
			if (write_ready_i) begin
				state <= STATE_IDLE;
			end
		end
		default: begin
			reg_error_bad_state <= 1;
			state <= STATE_IDLE;
		end
	endcase

reg [7:0] out_data;

// Output Signals
assign write_data_o = out_data[7:0];
assign write_valid_o = write_ready_i & (state == STATE_OUTPUT);
assign read_ready_o = (state == STATE_IDLE);

// LEDs
reg [3:0] leds;
assign led_a = leds[0];
assign led_b = leds[1];
assign led_c = leds[2];
assign led_d = leds[3];

endmodule


// Noop
// Echo
// Reset
// Read Error
// Clear Errors (?)
// Read Weirds
// Clear Weirds
// Pulse clock (1-256)
// Pulse clock x256 (256 * n)
// Pulse clock until triggered
// Set trigger on (hblank / vblank / csync / burst + rising / falling)
// Read triggered bits
// Clear triggered bits
// Read frame counter
// Read cycle counter
// Read cycle counter max
// Read resout0 rising edge counter
// Read resout1 rising edge counter

// (Ignore PA/PD for now.)
// (Ignore VRAM for now.)
// (Ignore interppu for now.)
// (Ignore TST pins for now.)
// (Ignore misc pins for now.)
// (Ignore analog for now.)

// Errors
//   input overflow
//   bad opcode
// Weirds
//   resout0 multiple edges
//   resout1 multiple edges
