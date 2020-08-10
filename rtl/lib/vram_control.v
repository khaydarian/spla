// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module vram_control(
	input  clock,

	// Control/Data interface
	input  [7:0] read_data_i,
	input  read_valid_i,
	output [7:0] write_data_o,
	output write_valid_o,

	// Busy
	output busy_o,

	// VRAM bus
	output vrd_n_o,
	output vawr_n_o,
	output vbwr_n_o,
	output va14_o,
	output [13:0] vaa_o,
	output [13:0] vab_o,
	output lvl_vd_dir_o,
	output vd_tristate_o,
	input  [7:0] vda_i,
	input  [7:0] vdb_i,
	output [7:0] vda_o,
	output [7:0] vdb_o,

	// Error output
	output error_bad_state_o,
	output error_bad_opcode_o);

// Commands: opcode + argument
reg [7:0] opcode;
reg [7:0] arg;

localparam OPCODE_NOOP               = 8'h00;
localparam OPCODE_ECHO               = 8'h01;
localparam OPCODE_RESET              = 8'h10;
localparam OPCODE_SET_VA_LOW         = 8'h20;
localparam OPCODE_SET_VA_HIGH        = 8'h21;
localparam OPCODE_SET_VAA_LOW        = 8'h30;
localparam OPCODE_SET_VAA_HIGH       = 8'h31;
localparam OPCODE_SET_VAB_LOW        = 8'h40;
localparam OPCODE_SET_VAB_HIGH       = 8'h41;
localparam OPCODE_SET_VDA            = 8'h50;
localparam OPCODE_SET_VDB            = 8'h51;
localparam OPCODE_SET_ASSERT_DELAY   = 8'h61;
localparam OPCODE_SET_SAMPLE_DELAY   = 8'h62;
localparam OPCODE_SET_RELEASE_DELAY  = 8'h64;
localparam OPCODE_SET_DURATION       = 8'h68;
localparam OPCODE_CYCLE_READ         = 8'h70;
localparam OPCODE_CYCLE_WRITE_A      = 8'h71;
localparam OPCODE_CYCLE_WRITE_B      = 8'h72;
localparam OPCODE_CYCLE_WRITE        = 8'h73;
localparam OPCODE_SET_DIRECT         = 8'h80;
localparam OPCODE_SAMPLE             = 8'h90;
localparam OPCODE_GET_VAA_LOW        = 8'hb0;
localparam OPCODE_GET_VAA_HIGH       = 8'hb1;
localparam OPCODE_GET_VAB_LOW        = 8'hc0;
localparam OPCODE_GET_VAB_HIGH       = 8'hc1;
localparam OPCODE_GET_VDA            = 8'hd0;
localparam OPCODE_GET_VDB            = 8'hd1;
localparam OPCODE_GET_ASSERT_DELAY   = 8'he1;
localparam OPCODE_GET_SAMPLE_DELAY   = 8'he2;
localparam OPCODE_GET_RELEASE_DELAY  = 8'he4;
localparam OPCODE_GET_DURATION       = 8'he8;
localparam OPCODE_SET_LVL_VD_DIR     = 8'hf0;
localparam OPCODE_SET_VRD_N          = 8'hf2;
localparam OPCODE_SET_VAWR_N         = 8'hf4;
localparam OPCODE_SET_VBWR_N         = 8'hf8;
localparam OPCODE_SET_VWR_N          = 8'hfc;

// Error Registers
reg reg_error_bad_state;
reg reg_error_bad_opcode;

initial reg_error_bad_state = 0;
initial reg_error_bad_opcode = 0;

// Address registers
reg reg_va14;
reg [13:0] reg_vaa;
reg [13:0] reg_vab;
reg [7:0] reg_vda;
reg [7:0] reg_vdb;

initial reg_va14 = 0;
initial reg_vaa = 14'd0;
initial reg_vab = 14'd0;
initial reg_vda = 8'd0;
initial reg_vdb = 8'd0;

// Cycle registers
localparam DURATION_BITS = 6;
localparam DEFAULT_ASSERT_DELAY = 6'd15;
localparam DEFAULT_SAMPLE_DELAY = 6'd31;
localparam DEFAULT_RELEASE_DELAY = 6'd47;
localparam DEFAULT_DURATION = 6'd63;
localparam PAD_TO_8_BITS = 2'b0;

reg [DURATION_BITS-1:0] reg_assert_delay;
reg [DURATION_BITS-1:0] reg_sample_delay;
reg [DURATION_BITS-1:0] reg_release_delay;
reg [DURATION_BITS-1:0] reg_duration;

initial reg_assert_delay = DEFAULT_ASSERT_DELAY;
initial reg_sample_delay = DEFAULT_SAMPLE_DELAY;
initial reg_release_delay = DEFAULT_RELEASE_DELAY;
initial reg_duration = DEFAULT_DURATION;

// Cycle machinery
reg [1:0] cycle_op;
localparam CYCLE_OP_READ    = 2'b0;
localparam CYCLE_OP_WRITE_A = 2'b01;
localparam CYCLE_OP_WRITE_B = 2'b10;
localparam CYCLE_OP_WRITE   = 2'b11;
wire cycle_op_is_read;
wire cycle_op_writes_a;
wire cycle_op_writes_b;
wire cycle_op_is_write;
assign cycle_op_is_read = (cycle_op == CYCLE_OP_READ);
assign cycle_op_writes_a = cycle_op[0];
assign cycle_op_writes_b = cycle_op[1];
assign cycle_op_is_write = |(cycle_op);

reg [DURATION_BITS-1:0] cycle_counter;
reg cycle_control_asserted;
wire cycle_control_vrd_n;
wire cycle_control_vawr_n;
wire cycle_control_vbwr_n;

assign cycle_control_vrd_n = ((cycle_op_is_read && cycle_control_asserted) ? 0 : 1);
assign cycle_control_vawr_n = ((cycle_op_writes_a && cycle_control_asserted) ? 0 : 1);
assign cycle_control_vbwr_n = ((cycle_op_writes_b && cycle_control_asserted) ? 0 : 1);

// Sample machinery
reg reg_direct; // If 1, drive from these registers.
reg reg_lvl_vd_dir;
reg reg_vrd_n;
reg reg_vawr_n;
reg reg_vbwr_n;

initial reg_direct = 0;
initial reg_lvl_vd_dir = 0;
initial reg_vrd_n = 1;
initial reg_vawr_n = 1;
initial reg_vbwr_n = 1;

// Output Buffer
reg [7:0] out_data;
initial out_data = 0;

// State Machine.
localparam STATE_IDLE     = 6'b000001;
localparam STATE_WAIT_ARG = 6'b000010;
localparam STATE_EXECUTE  = 6'b000100;
localparam STATE_CYCLE    = 6'b001000;
localparam STATE_OUTPUT   = 6'b010000;
localparam STATE_OUTWAIT  = 6'b100000;
reg [5:0] state;
initial state = STATE_IDLE;

always @(posedge clock)
	case (state)
		STATE_IDLE: begin
			if (read_valid_i) begin
				opcode <= read_data_i;
				state <= STATE_WAIT_ARG;
			end
		end
		STATE_WAIT_ARG: begin
			if (read_valid_i) begin
				arg <= read_data_i;
				state <= STATE_EXECUTE;
			end
		end
		STATE_EXECUTE: begin
			case (opcode)
				OPCODE_NOOP: begin
					state <= STATE_IDLE;
				end
				OPCODE_ECHO: begin
					out_data <= arg;
					state <= STATE_OUTPUT;
				end
				OPCODE_RESET: begin
					reg_error_bad_state <= 0;
					reg_error_bad_opcode <= 0;
					reg_va14 <= 0;
					reg_vaa <= 0;
					reg_vab <= 0;
					reg_vda <= 0;
					reg_vdb <= 0;
					reg_assert_delay <= DEFAULT_ASSERT_DELAY;
					reg_sample_delay <= DEFAULT_SAMPLE_DELAY;
					reg_release_delay  <= DEFAULT_RELEASE_DELAY;
					reg_duration <= DEFAULT_DURATION;
					reg_direct <= 0;
					reg_lvl_vd_dir <= 0;
					reg_vrd_n <= 1;
					reg_vawr_n <= 1;
					reg_vbwr_n <= 1;
					state <= STATE_IDLE;
				end
				OPCODE_SET_VA_LOW: begin
					reg_vaa[7:0] <= arg;
					reg_vab[7:0] <= arg;
					state <= STATE_IDLE;
				end
				OPCODE_SET_VA_HIGH: begin
					reg_va14 <= arg[6];
					reg_vaa[13:8] <= arg[5:0];
					reg_vab[13:8] <= arg[5:0];
					state <= STATE_IDLE;
				end
				OPCODE_SET_VAA_LOW: begin
					reg_vaa[7:0] <= arg;
					state <= STATE_IDLE;
				end
				OPCODE_SET_VAA_HIGH: begin
					reg_va14 <= arg[6];
					reg_vaa[13:8] <= arg[5:0];
					state <= STATE_IDLE;
				end
				OPCODE_SET_VAB_LOW: begin
					reg_vab[7:0] <= arg;
					state <= STATE_IDLE;
				end
				OPCODE_SET_VAB_HIGH: begin
					reg_va14 <= arg[6];
					reg_vab[13:8] <= arg[5:0];
					state <= STATE_IDLE;
				end
				OPCODE_SET_VDA: begin
					reg_vda <= arg;
					state <= STATE_IDLE;
				end
				OPCODE_SET_VDB: begin
					reg_vdb <= arg;
					state <= STATE_IDLE;
				end
				OPCODE_SET_ASSERT_DELAY: begin
					reg_assert_delay <= arg[DURATION_BITS-1:0];
					state <= STATE_IDLE;
				end
				OPCODE_SET_SAMPLE_DELAY: begin
					reg_sample_delay <= arg[DURATION_BITS-1:0];
					state <= STATE_IDLE;
				end
				OPCODE_SET_RELEASE_DELAY: begin
					reg_release_delay <= arg[DURATION_BITS-1:0];
					state <= STATE_IDLE;
				end
				OPCODE_SET_DURATION: begin
					reg_duration <= arg[DURATION_BITS-1:0];
					state <= STATE_IDLE;
				end
				OPCODE_CYCLE_READ: begin
					reg_direct <= 0;
					cycle_op <= CYCLE_OP_READ;
					cycle_counter <= 0;
					state <= STATE_CYCLE;
				end
				OPCODE_CYCLE_WRITE_A: begin
					reg_direct <= 0;
					cycle_op <= CYCLE_OP_WRITE_A;
					cycle_counter <= 0;
					state <= STATE_CYCLE;
				end
				OPCODE_CYCLE_WRITE_B: begin
					cycle_op <= CYCLE_OP_WRITE_B;
					cycle_counter <= 0;
					reg_direct <= 0;
					state <= STATE_CYCLE;
				end
				OPCODE_CYCLE_WRITE: begin
					cycle_op <= CYCLE_OP_WRITE;
					cycle_counter <= 0;
					reg_direct <= 0;
					state <= STATE_CYCLE;
				end
				OPCODE_SAMPLE: begin
					reg_vda <= vda_i;
					reg_vdb <= vdb_i;
					state <= STATE_IDLE;
				end
				OPCODE_GET_VAA_LOW: begin
					out_data <= reg_vaa[7:0];
					state <= STATE_OUTPUT;
				end
				OPCODE_GET_VAA_HIGH: begin
					out_data <= {1'b0, reg_va14, reg_vaa[13:8]};
					state <= STATE_OUTPUT;
				end
				OPCODE_GET_VAB_LOW: begin
					out_data <= reg_vab[7:0];
					state <= STATE_OUTPUT;
				end
				OPCODE_GET_VAB_HIGH: begin
					out_data <= {1'b0, reg_va14, reg_vab[13:8]};
					state <= STATE_OUTPUT;
				end
				OPCODE_GET_VDA: begin
					out_data <= reg_vda;
					state <= STATE_OUTPUT;
				end
				OPCODE_GET_VDB: begin
					out_data <= reg_vdb;
					state <= STATE_OUTPUT;
				end
				OPCODE_GET_ASSERT_DELAY: begin
					out_data <= {PAD_TO_8_BITS, reg_assert_delay};
					state <= STATE_OUTPUT;
				end
				OPCODE_GET_SAMPLE_DELAY: begin
					out_data <= {PAD_TO_8_BITS, reg_sample_delay};
					state <= STATE_OUTPUT;
				end
				OPCODE_GET_RELEASE_DELAY: begin
					out_data <= {PAD_TO_8_BITS, reg_release_delay};
					state <= STATE_OUTPUT;
				end
				OPCODE_GET_DURATION: begin
					out_data <= {PAD_TO_8_BITS, reg_duration};
					state <= STATE_OUTPUT;
				end
				OPCODE_SET_LVL_VD_DIR: begin
					reg_lvl_vd_dir <= arg[0];
					state <= STATE_IDLE;
				end
				OPCODE_SET_VRD_N: begin
					reg_vrd_n <= arg[0];
					if (!arg[0]) begin
						reg_vawr_n <= 1;
						reg_vbwr_n <= 1;
					end
					state <= STATE_IDLE;
				end
				OPCODE_SET_VAWR_N: begin
					reg_vawr_n <= arg[0];
					if (!arg[0]) begin
						reg_vrd_n <= 1;
					end
					state <= STATE_IDLE;
				end
				OPCODE_SET_VBWR_N: begin
					reg_vbwr_n <= arg[0];
					if (!arg[0]) begin
						reg_vrd_n <= 1;
					end
					state <= STATE_IDLE;
				end
				OPCODE_SET_VWR_N: begin
					reg_vawr_n <= arg[0];
					reg_vbwr_n <= arg[0];
					if (!arg[0]) begin
						reg_vrd_n <= 1;
					end
					state <= STATE_IDLE;
				end
				default: begin
					reg_error_bad_opcode <= 1;
					state <= STATE_IDLE;
				end
			endcase
		end
		STATE_CYCLE: begin
			cycle_counter <= cycle_counter + 1;
			if (cycle_counter == reg_assert_delay) begin
				cycle_control_asserted <= 1;
			end else if (cycle_counter == reg_sample_delay) begin
				if (cycle_op_is_read) begin
					reg_vda <= vda_i;
					reg_vdb <= vdb_i;
				end
			end else if (cycle_counter == reg_release_delay) begin
				cycle_control_asserted <= 0;
			end else if (cycle_counter == reg_duration) begin
				state <= STATE_IDLE;
			end
		end
		STATE_OUTPUT: begin
			state <= STATE_OUTWAIT;
		end
		STATE_OUTWAIT: begin
			state <= STATE_IDLE;
		end
		default: begin
			reg_error_bad_state <= 1;
			state <= STATE_IDLE;
		end
	endcase

// VRAM signals
wire should_drive_address = (state == STATE_CYCLE || reg_direct);
assign va14_o = should_drive_address ? reg_va14 : 0;
assign vaa_o = should_drive_address ? reg_vaa : 14'd0;
assign vab_o = should_drive_address ? reg_vab : 14'd0;

wire should_drive_data = (state == STATE_CYCLE || (reg_direct && reg_lvl_vd_dir));
assign vda_o = should_drive_data ? reg_vda : 8'd0;
assign vdb_o = should_drive_data ? reg_vdb : 8'd0;

assign lvl_vd_dir_o = (
	(state == STATE_CYCLE ? cycle_op_is_write :
	 (reg_direct ? reg_lvl_vd_dir : 0)));
assign vd_tristate_o = !lvl_vd_dir_o;

assign vrd_n_o =
	(state == STATE_CYCLE ? cycle_control_vrd_n :
	 (reg_direct ? reg_vrd_n : 1'b1));
assign vawr_n_o =
	(state == STATE_CYCLE ? cycle_control_vawr_n :
	 (reg_direct ? reg_vawr_n : 1'b1));
assign vbwr_n_o =
	(state == STATE_CYCLE ? cycle_control_vbwr_n :
	 (reg_direct ? reg_vbwr_n : 1'b1));

// Output signals
assign write_data_o = out_data;
assign write_valid_o = state == STATE_OUTWAIT;
assign busy_o = (state != STATE_IDLE);

// Error signals
assign error_bad_state_o = reg_error_bad_state;
assign error_bad_opcode_o = reg_error_bad_opcode;

endmodule
