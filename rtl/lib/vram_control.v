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
localparam OPCODE_SET_VAA_LOW        = 8'h30;
localparam OPCODE_SET_VAA_HIGH       = 8'h31;
localparam OPCODE_SET_VAB_LOW        = 8'h40;
localparam OPCODE_SET_VAB_HIGH       = 8'h41;
localparam OPCODE_SET_VDA            = 8'h50;
localparam OPCODE_SET_VDB            = 8'h51;
localparam OPCODE_SET_VD_DIR         = 8'h61;
localparam OPCODE_SET_VRD_N          = 8'h62;
localparam OPCODE_SET_VAWR_N         = 8'h64;
localparam OPCODE_SET_VBWR_N         = 8'h68;
localparam OPCODE_SAMPLE_VDA         = 8'h70;
localparam OPCODE_SAMPLE_VDB         = 8'h71;
localparam OPCODE_GET_VAA            = 8'hb0;
localparam OPCODE_GET_VAB            = 8'hc0;
localparam OPCODE_GET_VDAB           = 8'hd0;
localparam OPCODE_GET_VD_DIR         = 8'he1;
localparam OPCODE_GET_VRD_N          = 8'he2;
localparam OPCODE_GET_VAWR_N         = 8'he4;
localparam OPCODE_GET_VBWR_N         = 8'he8;

// Registers
reg reg_error_bad_state;
reg reg_error_bad_opcode;
reg reg_va14;
reg [13:0] reg_vaa;
reg [13:0] reg_vab;
reg [7:0] reg_vda;
reg [7:0] reg_vdb;
reg reg_vd_dir;
reg reg_vrd_n;
reg reg_vawr_n;
reg reg_vbwr_n;

// Output Buffer
reg [7:0] out_first;
reg [7:0] out_second;
reg [1:0] outcount;

// State Machine.
localparam STATE_IDLE     = 4'b0001;
localparam STATE_WAIT_ARG = 4'b0010;
localparam STATE_EXECUTE  = 4'b0100;
localparam STATE_OUTPUT   = 4'b1000;
reg [3:0] state;

always @(posedge clock)
	if (!reset) begin
		reg_error_bad_state <= 0;
		reg_error_bad_opcode <= 0;
		reg_va14 <= 0;
		reg_vaa <= 0;
		reg_vab <= 0;
		reg_vda <= 0;
		reg_vdb <= 0;
		reg_vd_dir <= 0;
		reg_vrd_n <= 0;
		reg_vawr_n <= 0;
		reg_vbwr_n <= 0;
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
					reg_vd_dir <= 0;
					reg_vrd_n <= 0;
					reg_vawr_n <= 0;
					reg_vbwr_n <= 0;
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
				OPCODE_SET_VD_DIR: begin
					reg_vd_dir <= arg[0];
					state <= STATE_IDLE;
				end
				OPCODE_SET_VRD_N: begin
					reg_vrd_n <= arg[0];
					state <= STATE_IDLE;
				end
				OPCODE_SET_VAWR_N: begin
					reg_vawr_n <= arg[0];
					state <= STATE_IDLE;
				end
				OPCODE_SET_VBWR_N: begin
					reg_vbwr_n <= arg[0];
					state <= STATE_IDLE;
				end
				OPCODE_SAMPLE_VDA: begin
					reg_vda <= vda_i;
					state <= STATE_IDLE;
				end
				OPCODE_SAMPLE_VDB: begin
					reg_vdb <= vdb_i;
					state <= STATE_IDLE;
				end
				OPCODE_GET_VAA: begin
					out_first <= {1'b0, reg_va14, reg_vaa[13:8]};
					out_second <= reg_vaa[7:0];
					outcount <= 2;
					state <= STATE_OUTPUT;
				end
				OPCODE_GET_VAB: begin
					out_first <= {1'b0, reg_va14, reg_vab[13:8]};
					out_second <= reg_vab[7:0];
					outcount <= 2;
					state <= STATE_OUTPUT;
				end
				OPCODE_GET_VDAB: begin
					out_first <= reg_vda;
					out_second <= reg_vdb;
					outcount <= 2;
					state <= STATE_OUTPUT;
				end
				OPCODE_GET_VD_DIR: begin
					out_first <= {7'b0, reg_vd_dir};
					outcount <= 1;
					state <= STATE_OUTPUT;
				end
				OPCODE_GET_VRD_N: begin
					out_first <= {7'b0, reg_vrd_n};
					outcount <= 1;
					state <= STATE_OUTPUT;
				end
				OPCODE_GET_VAWR_N: begin
					out_first <= {7'b0, reg_vawr_n};
					outcount <= 1;
					state <= STATE_OUTPUT;
				end
				OPCODE_GET_VBWR_N: begin
					out_first <= {7'b0, reg_vbwr_n};
					outcount <= 1;
					state <= STATE_OUTPUT;
				end
				default: begin
					reg_error_bad_opcode <= 1;
					state <= STATE_IDLE;
				end
			endcase
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

// Signals
assign va14_o = reg_va14;
assign vaa_o = reg_vaa;
assign vab_o = reg_vab;
assign vda_o = reg_vda;
assign vdb_o = reg_vdb;
assign vd_dir_o = reg_vd_dir;
assign vrd_n_o = reg_vrd_n;
assign vawr_n_o = reg_vawr_n;
assign vbwr_n_o = reg_vbwr_n;

// Output signals
assign write_data_o = out_first;
assign write_valid_o = (outcount != 0) && write_ready_i;

// Error signals
assign error_bad_state_o = reg_error_bad_state;
assign error_bad_opcode_o = reg_error_bad_opcode;

endmodule
