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

	// SNES
	output xin,
	output ppu1_reset_n,
	output ppu2_reset_n,
	input  ppu2_resout0_n,
	input  ppu2_resout1_n,
	input  burst_n,
	input  csync_n,
	input  hblank,
	input  vblank,

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
reg [1:0] args_count;
reg [23:0] args;

localparam OPCODE_NOOP               = 8'h00;
localparam OPCODE_ECHO1              = 8'h41;
localparam OPCODE_ECHO2              = 8'h81;
localparam OPCODE_ECHO3              = 8'hc1;
localparam OPCODE_ABSORB             = 8'h82;
localparam OPCODE_GENERATE           = 8'h83;
localparam OPCODE_SET_LEDS           = 8'h44;
localparam OPCODE_RESET              = 8'h05;
localparam OPCODE_READ_CONTROL       = 8'h07;
localparam OPCODE_SET_XIN_LO         = 8'h10;
localparam OPCODE_SET_XIN_HI         = 8'h11;
localparam OPCODE_PPU_RESET          = 8'h12;
localparam OPCODE_PPU_UNRESET        = 8'h13;

// Error registers
reg reg_error_bad_state;
initial reg_error_bad_state = 0;
assign error_bad_state_o = reg_error_bad_state;

reg reg_error_bad_opcode;
initial reg_error_bad_opcode = 0;
assign error_bad_opcode_o = reg_error_bad_opcode;

// State Machine.
localparam STATE_IDLE    = 6'b000001;
localparam STATE_ARGS    = 6'b000010;
localparam STATE_EXECUTE = 6'b000100;
localparam STATE_OUTPUT  = 6'b001000;
reg [5:0] state;
initial state = STATE_IDLE;

wire [1:0] read_data_i_args_count;
assign read_data_i_args_count = read_data_i[7:6];

always @(posedge clock)
	if (!reset) begin
		state <= STATE_IDLE;
		reg_error_bad_state <= 0;
		reg_error_bad_opcode <= 0;
	end else case (state)
		STATE_IDLE: begin
			if (read_valid_i) begin
				opcode <= read_data_i;
				args_count <= read_data_i_args_count - 1;
				if (read_data_i_args_count == 0)
					state <= STATE_EXECUTE;
				else
					state <= STATE_ARGS;
			end
		end
		STATE_ARGS: begin
			if (read_valid_i) begin
				args <= {args[15:0], read_data_i};
				if (args_count == 0)
					state <= STATE_EXECUTE;
				else
					args_count <= args_count - 1;
			end
		end
		STATE_EXECUTE: begin
			case (opcode)
				OPCODE_NOOP: begin
					state <= STATE_IDLE;
				end
				OPCODE_ECHO1: begin
					out_data[7:0] <= args[7:0];
					out_count <= 1;
					state <= STATE_OUTPUT;
				end
				OPCODE_ECHO2: begin
					out_data[7:0] <= args[15:8];
					out_data[15:8] <= args[7:0];
					out_count <= 2;
					state <= STATE_OUTPUT;
				end
				OPCODE_ECHO3: begin
					out_data[7:0] <= args[23:16];
					out_data[15:8] <= args[15:8];
					out_data[23:16] <= args[7:0];
					out_count <= 3;
					state <= STATE_OUTPUT;
				end
				OPCODE_SET_LEDS: begin
					leds <= args[3:0];
					state <= STATE_IDLE;
				end
				OPCODE_READ_CONTROL: begin
					out_data[7:0] <= {
						ppu2_reset_n,
						ppu1_reset_n,
						ppu2_resout1_n,
						ppu2_resout0_n,
						burst_n,
						csync_n,
						hblank,
						vblank};
					out_count <= 1;
					state <= STATE_OUTPUT;
				end
				OPCODE_SET_XIN_LO: begin
					// Side-effects done by assign statements below.
					state <= STATE_IDLE;
				end
				OPCODE_SET_XIN_HI: begin
					// Side-effects done by assign statements below.
					state <= STATE_IDLE;
				end
				OPCODE_PPU_RESET: begin
					// Side-effects done by assign statements below.
					state <= STATE_IDLE;
				end
				OPCODE_PPU_UNRESET: begin
					// Side-effects done by assign statements below.
					state <= STATE_IDLE;
				end
				default: begin
					reg_error_bad_opcode <= 1;
					state <= STATE_IDLE;
				end
			endcase
		end
		STATE_OUTPUT: begin
			if (write_ready_i) begin
				if (out_count == 0 || out_count == 1) begin
					out_count <= 0;
					state <= STATE_IDLE;
				end else begin
					out_count <= out_count - 1;
					out_data <= {8'b0, out_data[23:8]};
				end
			end
		end
		default: begin
			reg_error_bad_state <= 1;
			state <= STATE_IDLE;
		end
	endcase

// PPU control signals
ppu_control ppu_control(
	.clock(clock),
	.reset(reset),
	.xin_lo_i(xin_lo),
	.xin_hi_i(xin_hi),
	.set_ppu_reset_i(set_ppu_reset),
	.clr_ppu_reset_i(clr_ppu_reset),
	.xin(xin),
	.ppu1_reset_n(ppu1_reset_n),
	.ppu2_reset_n(ppu2_reset_n));

wire xin_lo;
wire xin_hi;
wire set_ppu_reset;
wire clr_ppu_reset;
assign xin_lo = (state == STATE_EXECUTE && opcode == OPCODE_SET_XIN_LO);
assign xin_hi = (state == STATE_EXECUTE && opcode == OPCODE_SET_XIN_HI);
assign set_ppu_reset = (state == STATE_EXECUTE && opcode == OPCODE_PPU_RESET);
assign clr_ppu_reset = (state == STATE_EXECUTE && opcode == OPCODE_PPU_UNRESET);

// Output registers
reg [23:0] out_data;
reg [1:0] out_count;

// Output signals
assign write_data_o = out_data[7:0];
assign write_valid_o = (state == STATE_OUTPUT);
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
