// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module bringup_vram_trivial(
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
	//output  [7:0] vda,
	//output  [7:0] vdb,
	input   [7:0] vda,
	input   [7:0] vdb,
	
	// LEDs
	output  led7,
	output  led8);

wire toggle;
clock_div #(.CYCLES(120))  // 100kHz
	clock_div0(.clock(clock), .div_o(toggle));

assign lvl_va_dir = 1;
assign lvl_vd_dir = 0;

assign led7 = toggle;  // LED7 == output mode
//assign led8 = ~toggle;  // LED8 == input mode

// Avoid confusing vram chips.
assign vrd_n = 0;
assign vawr_n = 1;
assign vbwr_n = 1;

assign va14 = toggle;
assign vaa = {14{toggle}};
assign vab = {14{toggle}};

// Bidirectional data pins.
//wire [7:0] vda_i;
//wire [7:0] vdb_i;
//wire [7:0] vda_o;
//wire [7:0] vdb_o;
//pin_bidir_8 pin_bidir_vda(.i(vda_i), .o(vda_o), .dir(lvl_vd_dir), .pin(vda));
//pin_bidir_8 pin_bidir_vdb(.i(vdb_i), .o(vdb_o), .dir(lvl_vd_dir), .pin(vdb));
//assign vda_o = {8{toggle}};
//assign vdb_o = {8{toggle}};

//assign vda = {8{toggle}};
//assign vdb = {8{toggle}};

assign led8 = ^{vda, vdb};

endmodule
