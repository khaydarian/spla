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
	output  led_b);

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

// VRAM.
wire error_bad_state;
wire error_bad_opcode;
wire vram_control_busy;

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

vram_control
	vram(
		.clock(clock),
		// Control/Data interface
		.read_data_i(incoming_data),
		.read_valid_i(incoming_valid),
		.write_data_o(outgoing_data),
		.write_valid_o(outgoing_valid),
		// Busy
		.busy_o(vram_control_busy),
		// VRAM bus
		.vrd_n_o(vrd_n),
		.vawr_n_o(vawr_n),
		.vbwr_n_o(vbwr_n),
		.va14_o(va14),
		.vaa_o(vaa),
		.vab_o(vab),
		.lvl_vd_dir_o(lvl_vd_dir),
		.vd_tristate_o(vd_tristate),
		.vda_i(vda_i),
		.vdb_i(vdb_i),
		.vda_o(vda_o),
		.vdb_o(vdb_o),
		// Error output
		.error_bad_state_o(error_bad_state),
		.error_bad_opcode_o(error_bad_opcode));

// UART TX.
uart_tx #(.CLOCKS_PER_BAUD(104)) // 115200 baud
	uart_tx0(
		.clock(clock),
		.write_i(outgoing_valid),
		.data_i(outgoing_data),
		.busy_o(tx_busy),
		.tx_o(uart_tx));

// LEDs.
oneshot #(.CYCLES(60000)) // 5ms
	oneshot_led_a(.clock(clock), .in(incoming_valid), .out(led_a));

assign led_b = error_bad_state || error_bad_opcode || vram_control_busy;

endmodule
