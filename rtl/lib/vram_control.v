// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module vram_control(
	input  clock,
	input  reset,

	// Control/Data interface
	input  [7:0] read_data_i,
	input  read_valid_i,
	output [7:0] write_data_o,
	output write_valid_o,
	input  write_ready_i,

	// VRAM bus
	output vrd_n_o,
	output vawr_n_o,
	output vbwr_n_o,
	output va14_o,
	output [13:0] vaa_o,
	output [13:0] vab_o,
	output vd_dir_o,
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
localparam OPCODE_ECHO2              = 8'h02;
localparam OPCODE_RESET              = 8'h10;
localparam OPCODE_SET_VA_LOW         = 8'h20;
localparam OPCODE_SET_VA_HIGH        = 8'h21;
localparam OPCODE_SET_VAA_LOW        = 8'h30;
localparam OPCODE_SET_VAA_HIGH       = 8'h31;
localparam OPCODE_SET_VAB_LOW        = 8'h40;
localparam OPCODE_SET_VAB_HIGH       = 8'h41;
localparam OPCODE_SET_VDA            = 8'h50;
localparam OPCODE_SET_VDB            = 8'h51;
localparam OPCODE_SET_CYCLE_DURATION = 8'h60;
localparam OPCODE_WRITE              = 8'h80;
localparam OPCODE_READ               = 8'h90;

// Registers
reg reg_error_bad_state;
reg reg_error_bad_opcode;
reg reg_va14;
reg [13:0] reg_vaa;
reg [13:0] reg_vab;
reg [7:0] reg_vda;
reg [7:0] reg_vdb;

localparam CYCLE_DURATION_BITS = 6;
reg [CYCLE_DURATION_BITS-1:0] reg_cycle_duration;
localparam MAX_CYCLE_DURATION = (1 << CYCLE_DURATION_BITS) - 1;

reg cycle_op;
localparam CYCLE_OP_READ = 1'b0;
localparam CYCLE_OP_WRITE = 1'b1;
wire cycle_op_is_read;
wire cycle_op_is_write;
assign cycle_op_is_read = (cycle_op == CYCLE_OP_READ);
assign cycle_op_is_write = (cycle_op == CYCLE_OP_WRITE);

reg [CYCLE_DURATION_BITS-1:0] cycle_counter;

// Output Buffer
reg [7:0] out_first;
reg [7:0] out_second;
reg [1:0] outcount;

// State Machine.
localparam STATE_IDLE     = 5'b00001;
localparam STATE_WAIT_ARG = 5'b00010;
localparam STATE_EXECUTE  = 5'b00100;
localparam STATE_CYCLE    = 5'b01000;
localparam STATE_OUTPUT   = 5'b10000;
reg [4:0] state;

always @(posedge clock)
	if (!reset) begin
		reg_error_bad_state <= 0;
		reg_error_bad_opcode <= 0;
		reg_va14 <= 0;
		reg_vaa <= 0;
		reg_vab <= 0;
		reg_vda <= 0;
		reg_vdb <= 0;
		reg_cycle_duration <= MAX_CYCLE_DURATION;
		state <= STATE_IDLE;
	end else case (state)
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
					out_first <= arg;
					outcount <= 1;
					state <= STATE_OUTPUT;
				end
				OPCODE_ECHO2: begin
					out_first <= arg;
					out_second <= ~arg;
					outcount <= 2;
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
					reg_cycle_duration <= MAX_CYCLE_DURATION;
					state <= STATE_IDLE;
				end
				OPCODE_SET_VA_LOW: begin
					reg_vaa <= {reg_vaa[13:8], arg};
					reg_vab <= {reg_vab[13:8], arg};
					state <= STATE_IDLE;
				end
				OPCODE_SET_VA_HIGH: begin
					reg_va14 <= arg[6];
					reg_vaa <= {arg[5:0], reg_vaa[7:0]};
					reg_vab <= {arg[5:0], reg_vab[7:0]};
					state <= STATE_IDLE;
				end
				OPCODE_SET_VAA_LOW: begin
					reg_vaa <= {reg_vaa[13:8], arg};
					state <= STATE_IDLE;
				end
				OPCODE_SET_VAA_HIGH: begin
					reg_va14 <= arg[6];
					reg_vaa <= {arg[5:0], reg_vaa[7:0]};
					state <= STATE_IDLE;
				end
				OPCODE_SET_VAB_LOW: begin
					reg_vab <= {reg_vab[13:8], arg};
					state <= STATE_IDLE;
				end
				OPCODE_SET_VAB_HIGH: begin
					reg_va14 <= arg[6];
					reg_vab <= {arg[5:0], reg_vab[7:0]};
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
				OPCODE_SET_CYCLE_DURATION: begin
					reg_cycle_duration <= arg[CYCLE_DURATION_BITS-1:0];
					state <= STATE_IDLE;
				end
				OPCODE_WRITE: begin
					cycle_op <= CYCLE_OP_WRITE;
					cycle_counter <= 0;
					state <= STATE_CYCLE;
				end
				OPCODE_READ: begin
					cycle_op <= CYCLE_OP_READ;
					cycle_counter <= 0;
					state <= STATE_CYCLE;
				end
				default: begin
					reg_error_bad_opcode <= 1;
					state <= STATE_IDLE;
				end
			endcase
		end
		STATE_CYCLE: begin
			if (cycle_counter == reg_cycle_duration) begin
				if (cycle_op_is_read) begin
					reg_vda <= vda_i;
					reg_vdb <= vdb_i;
					out_first <= vda_i;
					out_second <= vdb_i;
					outcount <= 2;
				end
				state <= STATE_OUTPUT;
			end else begin
				cycle_counter <= cycle_counter + 1;
			end
		end
		STATE_OUTPUT: begin
			if (outcount == 0) begin
				state <= STATE_IDLE;
			end else if (write_valid_o) begin
				out_first <= out_second;
				outcount <= outcount - 1;
			end
		end
		default: begin
			reg_error_bad_state <= 1;
			state <= STATE_IDLE;
		end
	endcase

// Cycle signals
assign vrd_n_o = (state == STATE_CYCLE ? ~cycle_op_is_read : 1);
assign vawr_n_o = (state == STATE_CYCLE ? ~cycle_op_is_write : 1);
assign vbwr_n_o = (state == STATE_CYCLE ? ~cycle_op_is_write : 1);
assign va14_o = (state == STATE_CYCLE ? reg_va14 : 0);
assign vaa_o = (state == STATE_CYCLE ? reg_vaa : 14'd0);
assign vab_o = (state == STATE_CYCLE ? reg_vab : 14'd0);
assign vd_dir_o = (
	state == STATE_CYCLE ?
		(cycle_op_is_write ? LVL_DIR_OUTPUT : LVL_DIR_INPUT)
		: LVL_DIR_INPUT);
assign vda_o = (state == STATE_CYCLE ? reg_vda : 8'd0);
assign vdb_o = (state == STATE_CYCLE ? reg_vdb : 8'd0);

// Output signals
assign write_data_o = out_first;
assign write_valid_o = (outcount != 0) && write_ready_i;

// Error signals
assign error_bad_state_o = reg_error_bad_state;
assign error_bad_opcode_o = reg_error_bad_opcode;

endmodule

