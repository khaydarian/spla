// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module bringup_vram_steps(
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
	output vrd_n,
	output vawr_n,
	output vbwr_n,
	output va14,
	output [13:0] vaa,
	output [13:0] vab,
	inout  [7:0] vda,
	inout  [7:0] vdb,

	// LEDs
	output  led_a,
	output  led_b,
	output  bodge1);

wire reset;
unreset_by_uart unreset(.clock(clock), .uart_rx(uart_rx), .reset(reset));

// SNES chips held in reset.
assign ppu1_reset_n = 0;
assign ppu2_reset_n = 0;

// FPGA owns the VRAM address bus.
assign lvl_va_dir = 1'b1;

// UART RX/TX wiring.
wire [7:0] incoming_data;
wire incoming_valid;
reg [7:0] outgoing_data;
reg outgoing_valid;

// UART RX.
uart_rx #(.CLOCKS_PER_BAUD(104)) // 115200 baud
	uart_rx0(
		.clock(clock),
		.reset(reset),
		.data_o(incoming_data),
		.valid_o(incoming_valid),
		.rx_i(uart_rx));

// VRAM.
wire [7:0] vda_i;
wire [7:0] vdb_i;
wire [7:0] vda_o;
wire [7:0] vdb_o;
wire vd_tristate;
BB vda0(.I(vda_o[0]), .O(vda_i[0]), .T(vd_tristate), .B(vda[0]));
BB vda1(.I(vda_o[1]), .O(vda_i[1]), .T(vd_tristate), .B(vda[1]));
BB vda2(.I(vda_o[2]), .O(vda_i[2]), .T(vd_tristate), .B(vda[2]));
BB vda3(.I(vda_o[3]), .O(vda_i[3]), .T(vd_tristate), .B(vda[3]));
BB vda4(.I(vda_o[4]), .O(vda_i[4]), .T(vd_tristate), .B(vda[4]));
BB vda5(.I(vda_o[5]), .O(vda_i[5]), .T(vd_tristate), .B(vda[5]));
BB vda6(.I(vda_o[6]), .O(vda_i[6]), .T(vd_tristate), .B(vda[6]));
BB vda7(.I(vda_o[7]), .O(vda_i[7]), .T(vd_tristate), .B(vda[7]));
BB vdb0(.I(vdb_o[0]), .O(vdb_i[0]), .T(vd_tristate), .B(vdb[0]));
BB vdb1(.I(vdb_o[1]), .O(vdb_i[1]), .T(vd_tristate), .B(vdb[1]));
BB vdb2(.I(vdb_o[2]), .O(vdb_i[2]), .T(vd_tristate), .B(vdb[2]));
BB vdb3(.I(vdb_o[3]), .O(vdb_i[3]), .T(vd_tristate), .B(vdb[3]));
BB vdb4(.I(vdb_o[4]), .O(vdb_i[4]), .T(vd_tristate), .B(vdb[4]));
BB vdb5(.I(vdb_o[5]), .O(vdb_i[5]), .T(vd_tristate), .B(vdb[5]));
BB vdb6(.I(vdb_o[6]), .O(vdb_i[6]), .T(vd_tristate), .B(vdb[6]));
BB vdb7(.I(vdb_o[7]), .O(vdb_i[7]), .T(vd_tristate), .B(vdb[7]));

// VRAM registers.
reg reg_lvl_vd_dir;
reg reg_vrd_n;
reg reg_vawr_n;
reg reg_vbwr_n;
reg reg_va14;
reg [13:0] reg_vaa;
reg [13:0] reg_vab;
reg reg_vd_tristate;
reg [8:0] reg_vda_o;
reg [8:0] reg_vdb_o;

initial reg_lvl_vd_dir = 1'b0;
initial reg_vrd_n = 1'b1;
initial reg_vawr_n = 1'b1;
initial reg_vbwr_n = 1'b1;
initial reg_va14 = 1'b0;
initial reg_vaa = 13'd0;
initial reg_vab = 13'd0;
initial reg_vd_tristate = 1'b1;
initial reg_vda_o = 8'd0;
initial reg_vdb_o = 8'd0;

assign lvl_vd_dir = reg_lvl_vd_dir;
assign vrd_n = reg_vrd_n;
assign vawr_n = reg_vawr_n;
assign vbwr_n = reg_vbwr_n;
assign va14 = reg_va14;
assign vaa = reg_vaa;
assign vab = reg_vab;
assign vd_tristate = reg_vd_tristate;
assign vda_o = reg_vda_o;
assign vdb_o = reg_vdb_o;

// Keep these signals from getting optimized out.
assign bodge1 = ^{vda_i, vdb_i};

// State machine.
reg [3:0] state;
reg state_changed;
initial state = 0;
initial state_changed = 0;
always @(posedge clock) begin
	if (!reset) begin
		state <= 0;
	end else if (incoming_valid) begin
		state <= state + 1;
		outgoing_data <= state + 1;
		outgoing_valid <= 1;
		state_changed <= 1;
	end else begin
		outgoing_valid <= 0;
		state_changed <= 0;
	end
end

assign led_a = ~state[1];
assign led_b = ~state[0];

// State output drivers.
always @(posedge clock) begin
	if (state_changed) case (state)
		0: begin
			// No read / write
			reg_vrd_n <= 1;
			reg_vawr_n <= 1;
			reg_vbwr_n <= 1;
			// All address pins low
			reg_va14 <= 0;
			reg_vaa <= {13{1'b0}};
			reg_vab <= {13{1'b0}};
			// Data pins input (actually floating on chips)
			reg_lvl_vd_dir <= 0;
			reg_vd_tristate <= 1;
			reg_vda_o <= {8{1'b0}};
			reg_vdb_o <= {8{1'b0}};
		end
		1: begin
			// All address pins high
			reg_va14 <= 1;
			reg_vaa <= {13{1'b1}};
			reg_vab <= {13{1'b1}};
			// Data pins output high
			reg_lvl_vd_dir <= 1;
			reg_vd_tristate <= 0;
			reg_vda_o <= {8{1'b1}};
			reg_vdb_o <= {8{1'b1}};
		end
		2: begin
			// Set data to known values
			reg_vda_o <= 8'ha1;
			reg_vdb_o <= 8'hb2;
		end
		3: begin
			// Write cycle, both chips
			reg_vawr_n <= 0;
			reg_vbwr_n <= 0;
		end
		4: begin
			// End write cycle
			reg_vawr_n <= 1;
			reg_vbwr_n <= 1;
		end
		5: begin
			// Turn around data bus
			reg_lvl_vd_dir <= 0;
			reg_vd_tristate <= 1;
		end
		6: begin
			// Read cycle, both chips.
			reg_vrd_n <= 0;
		end
	endcase
end

// UART TX.
uart_tx #(.CLOCKS_PER_BAUD(104)) // 115200 baud
	uart_tx0(
		.clock(clock),
		.write_i(outgoing_valid),
		.data_i(outgoing_data),
		//.busy_o(tx_busy),
		.tx_o(uart_tx));

// LEDs.
//oneshot #(.CYCLES(60000)) // 5ms
//	oneshot_led_a(.clock(clock), .in(incoming_valid), .out(led_a));

endmodule
