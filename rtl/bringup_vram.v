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
wire [7:0] vda_i;
wire [7:0] vdb_i;
wire [7:0] vda_o;
wire [7:0] vdb_o;

pin_bidir_8 pin_bidir_vda(.i(vda_i), .o(vda_o), .dir(lvl_vd_dir), .pin(vda));
pin_bidir_8 pin_bidir_vdb(.i(vdb_i), .o(vdb_o), .dir(lvl_vd_dir), .pin(vdb));

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

vram_control
	vram(
		.clock(clock),
		.reset(reset),
		// Control/Data interface
		.read_data_i(incoming_data),
		.read_valid_i(incoming_valid),
		.write_data_o(outgoing_data),
		.write_valid_o(outgoing_valid),
		.write_ready_i(!tx_busy),
		// VRAM bus
		.vrd_n_o(vrd_n),
		.vawr_n_o(vawr_n),
		.vbwr_n_o(vbwr_n),
		.va14_o(va14),
		.vaa_o(vaa),
		.vab_o(vab),
		.vd_dir_o(lvl_vd_dir),
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
	oneshot_led7(.clock(clock), .in(incoming_valid), .out(led7));

assign led8 = error_bad_state || error_bad_opcode;

endmodule
