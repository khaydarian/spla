// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module bringup_vram_scan(
	// Clock input
	input  clock,

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

reg [15:0] counter;
initial counter = 15'd0;

wire step;
pulse #(.CLOCKS_PER_PULSE(12000))
	pulse_step(.clock(clock), .pulse_o(step));
always @(posedge clock)
	if (step)
		counter <= counter + 1;

wire operation;
assign operation = counter[15];

wire op_is_read;
wire op_is_write;
assign op_is_read = (operation == 1);
assign op_is_write = (operation == 0);

assign led7 = op_is_read;

// Always output address.
assign lvl_va_dir = 1;

// Output data only if writing.
assign lvl_vd_dir = op_is_write;

// Drive active-low control signals.
assign vrd_n = ~op_is_read;
assign vawr_n = ~op_is_write;
assign vbwr_n = ~op_is_write;

assign va14 = counter[14];
assign vaa = counter[13:0];
assign vab = counter[13:0];

// Bidirectional data pins.
wire [7:0] vda_i;
wire [7:0] vdb_i;
wire [7:0] vda_o;
wire [7:0] vdb_o;
pin_bidir_8 pin_bidir_vda(.i(vda_i), .o(vda_o), .dir(lvl_vd_dir), .pin(vda));
pin_bidir_8 pin_bidir_vdb(.i(vdb_i), .o(vdb_o), .dir(lvl_vd_dir), .pin(vdb));

assign vda_o = counter[7:0];
assign vdb_o = counter[7:0];

//assign led8 = (op_is_read ? (vda_o == vda_i && vdb_o == vdb_i) : 0);
assign led8 = (op_is_read ? vda_i[7] : 0);

endmodule
