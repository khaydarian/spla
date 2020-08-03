// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module bringup_vram(
	// Clock input
	input  clock,

	// UART
	output uart_tx,
	input  uart_rx,

	// SNES reset
	output ppu1_reset_n,
	output ppu2_reset_n,

	// Direction pins
	output lvl_va_dir,
	output lvl_vd_dir,

	// VRAM pins
	output  vrd_n,
	output  vawr_n,
	output  vbwr_n,
	output  va14,
	output  [13:0] vaa,
	output  [13:0] vab,
	inout   [7:0] vda,
	inout   [7:0] vdb,
	
	// LEDs
	output  led7,
	output  led8);

wire reset;
unreset_by_uart unreset(.clock(clock), .uart_rx(uart_rx), .reset(reset));

// SNES chips held in reset.
assign ppu1_reset_n = 0;
assign ppu2_reset_n = 0;

// FPGA owns the VRAM address bus.
assign lvl_va_dir = LVL_DIR_OUTPUT;

// Bidirectional data pins.
wire vd_dir;
wire [7:0] vda_i;
wire [7:0] vdb_i;
wire [7:0] vda_o;
wire [7:0] vdb_o;

pin_bidir_8 pin_bidir_vda(.i(vda_i), .o(vda_o), .dir(vd_dir), .pin(vda));
pin_bidir_8 pin_bidir_vdb(.i(vdb_i), .o(vdb_o), .dir(vd_dir), .pin(vdb));

// UART RX/TX wiring.
wire [7:0] incoming_data;
wire incoming_valid;
wire [7:0] outgoing_data;
wire outgoing_valid;
wire tx_busy;

// UART RX.
uart_rx #(.CLOCKS_PER_BAUD(104)) // 115200 baud
	uart_rx0(
		.clock(clock),
		.reset(reset),
		.data_o(incoming_data),
		.valid_o(incoming_valid),
		.rx_i(uart_rx));

// Commands: opcode + argument
reg [7:0] opcode;
reg [7:0] arg;

localparam OPCODE_NOOP           = 8'h00;
localparam OPCODE_ECHO           = 8'h01;
localparam OPCODE_ECHO2          = 8'h02;
localparam OPCODE_RESET          = 8'h10;
localparam OPCODE_SET_VAA_LOW    = 8'h20;
localparam OPCODE_SET_VAA_HIGH   = 8'h21;
localparam OPCODE_SET_VAB_LOW    = 8'h30;
localparam OPCODE_SET_VAB_HIGH   = 8'h31;
localparam OPCODE_SET_VDA        = 8'h42;
localparam OPCODE_SET_VDB        = 8'h43;
localparam OPCODE_WRITE_DURATION = 8'h50;
localparam OPCODE_READ_DELAY     = 8'h51;
localparam OPCODE_WRITE          = 8'h80;
localparam OPCODE_READ           = 8'h90;

// flag: postincrement write address
// flag: postincrement read address
// flag: scramble vda / vdb per write

// Registers
reg reg_error_bad_state;
reg reg_error_bad_opcode;
reg reg_va14;
reg [13:0] reg_vaa;
reg [13:0] reg_vab;
reg [7:0] reg_vda;
reg [7:0] reg_vdb;
reg [5:0] reg_write_duration;
reg [5:0] reg_read_delay;
localparam MAX_DURATION = 6'b111111;
localparam MAX_DELAY    = 6'b111111;

// Output Buffer
reg [7:0] outbuf [1:0];
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
		reg_write_duration <= MAX_DURATION;
		reg_read_delay <= MAX_DELAY;
		state <= STATE_IDLE;
	end else case (state)
		STATE_IDLE: begin
			if (incoming_valid) begin
				opcode <= incoming_data;
				state <= STATE_WAIT_ARG;
			end
		end
		STATE_WAIT_ARG: begin
			if (incoming_valid) begin
				arg <= incoming_data;
				state <= STATE_EXECUTE;
			end
		end
		STATE_EXECUTE: begin
			case (opcode)
				OPCODE_NOOP: begin
					state <= STATE_IDLE;
				end
				OPCODE_ECHO: begin
					outbuf[0] <= arg;
					outcount <= 1;
					state <= STATE_OUTPUT;
				end
				OPCODE_ECHO2: begin
					outbuf[0] <= arg;
					outbuf[1] <= ~arg;
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
					reg_write_duration <= MAX_DURATION;
					reg_read_delay <= MAX_DELAY;
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
					reg_vda <= arg;
					state <= STATE_IDLE;
				end
				OPCODE_WRITE_DURATION: begin
					reg_write_duration <= arg;
					state <= STATE_IDLE;
				end
				OPCODE_READ_DELAY: begin
					reg_read_delay <= arg;
					state <= STATE_IDLE;
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
			end else if (outgoing_valid) begin
				outcount <= outcount - 1;
			end
		end
		default: begin
			reg_error_bad_state <= 1;
			state <= STATE_IDLE;
		end
	endcase

assign outgoing_data = outbuf[0];
assign outgoing_valid = (outcount != 0) && !tx_busy;

// UART TX.
uart_tx #(.CLOCKS_PER_BAUD(104)) // 115200 baud
	uart_tx0(
		.clock(clock),
		.write_i(outgoing_valid),
		.data_i(outgoing_data),
		.busy_o(tx_busy),
		.tx_o(uart_tx));

// LEDs.
//oneshot #(.CYCLES(600000)) // 50ms
//	oneshot_led7(.clock(clock), .in(incoming_valid), .out(led7));

assign led7 = reg_error_bad_state;
assign led8 = reg_error_bad_opcode;

// TEMP
assign lvl_va_dir = LVL_DIR_INPUT;
assign vrd_n = 1;
assign vawr_n = 1;
assign vbwr_n = 1;
assign va14 = 1;
assign vaa = 14'd0;
assign vab = 14'd0;

endmodule
