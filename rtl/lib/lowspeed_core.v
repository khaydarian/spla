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

localparam OPCODE_NOOP               = 8'h00; // 0 -> 0
localparam OPCODE_RESET              = 8'h01; // 0 -> 0
localparam OPCODE_ECHO1              = 8'h42; // 1 -> 1
localparam OPCODE_ECHO2              = 8'h83; // 2 -> 2
localparam OPCODE_ECHO3              = 8'hc4; // 3 -> 3
localparam OPCODE_READ_CONTROL       = 8'h06; // 0 -> 1
localparam OPCODE_XIN_ENABLE         = 8'h07; // 0 -> 0
localparam OPCODE_XIN_DISABLE        = 8'h08; // 0 -> 1
localparam OPCODE_XIN_READ_COUNTER   = 8'h09; // 0 -> 3
localparam OPCODE_INT_WAIT           = 8'h0a; // 0 -> ... -> 1
localparam OPCODE_INT_ENABLED        = 8'h0b; // 0 -> 1
localparam OPCODE_INT_SET_ENABLED    = 8'h4c; // 1 -> 0
localparam OPCODE_INT_TRIGGERED      = 8'h0d; // 0 -> 1
localparam OPCODE_INT_CLEAR          = 8'h0e; // 0 -> 0
localparam OPCODE_PPU_RESET          = 8'h0f; // 0 -> 0
localparam OPCODE_PPU_UNRESET        = 8'h10; // 0 -> 0

wire [1:0] read_data_i_args_count;
assign read_data_i_args_count = read_data_i[7:6];

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
				OPCODE_RESET: begin
					state <= STATE_IDLE;
					led_b <= 0;
					xin_enabled <= 0;
					int_enabled <= 0;
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
				OPCODE_XIN_ENABLE: begin
					state <= STATE_IDLE;
					xin_enabled <= 1;
				end
				OPCODE_XIN_DISABLE: begin
					state <= STATE_IDLE;
					xin_enabled <= 0;
				end
				OPCODE_XIN_READ_COUNTER: begin
					out_data <= xin_counter[23:0];
					out_count <= 3;
					state <= STATE_OUTPUT;
				end
				OPCODE_INT_WAIT: begin
					if (int_any_triggered) begin
						out_data[7:0] <= int_triggered;
						out_count <= 1;
						state <= STATE_OUTPUT;
						led_b <= 0;
					end else begin
						led_b <= 1;
					end
				end
				OPCODE_INT_ENABLED: begin
					out_data[7:0] <= int_enabled;
					out_count <= 1;
					state <= STATE_OUTPUT;
				end
				OPCODE_INT_SET_ENABLED: begin
					int_enabled <= args[7:0];
					state <= STATE_IDLE;
				end
				OPCODE_INT_TRIGGERED: begin
					out_data[7:0] <= int_triggered;
					out_count <= 1;
					state <= STATE_OUTPUT;
				end
				OPCODE_INT_CLEAR: begin
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
					out_data <= {8'b0, out_data[31:8]};
				end
			end
		end
		default: begin
			reg_error_bad_state <= 1;
			state <= STATE_IDLE;
		end
	endcase

assign led_a = xin;

reg led_b;
initial led_b = 0;

// PPU control signals
wire ppu_control_reset;
assign ppu_control_reset = (!reset | !(state == STATE_EXECUTE && opcode == OPCODE_RESET));

reg xin_enabled;
initial xin_enabled = 0;
assign led_d = xin_enabled;
wire xin_stalled;
assign led_c = xin_stalled;
wire [31:0] xin_counter;

reg [7:0] int_enabled;
initial int_enabled = 8'h0;
wire [7:0] int_triggered;
wire int_any_triggered;

wire int_clear_all;
assign int_clear_all = (state == STATE_EXECUTE && opcode == OPCODE_INT_CLEAR);

wire set_ppu_reset;
wire clr_ppu_reset;
assign set_ppu_reset = (state == STATE_EXECUTE && opcode == OPCODE_PPU_RESET);
assign clr_ppu_reset = (state == STATE_EXECUTE && opcode == OPCODE_PPU_UNRESET);

ppu_control ppu_control(
	.clock(clock),
	.reset(ppu_control_reset),
	.xin_enabled_i(xin_enabled),
	.xin_stalled_o(xin_stalled),
	.xin_counter_o(xin_counter),
	.set_ppu_reset_i(set_ppu_reset),
	.clr_ppu_reset_i(clr_ppu_reset),
	.int_enabled_i(int_enabled),
	.int_clear_all_i(int_clear_all),
	.int_triggered_o(int_triggered),
	.int_any_triggered_o(int_any_triggered),
	.xin(xin),
	.ppu1_reset_n(ppu1_reset_n),
	.ppu2_reset_n(ppu2_reset_n),
	.burst_n(burst_n),
	.csync_n(csync_n),
	.hblank(hblank),
	.vblank(vblank));

// Output registers
reg [31:0] out_data;
reg [2:0] out_count;

// Output signals
assign write_data_o = out_data[7:0];
assign write_valid_o = (state == STATE_OUTPUT);
assign read_ready_o = (state == STATE_IDLE);

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
