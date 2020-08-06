// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module pin_bidir(
	input i, // Input from pin (when dir == 0)
	output o, // Output to pin (when dir == 1)
	input dir, // Direction (0 == input, 1 == output)
	input pin // Actual pin
	);

BB bb(.I(o), .O(i), .T(dir), .B(pin));

endmodule

module pin_bidir_8(
	input [7:0] i,
	output [7:0] o,
	input dir,
	input [7:0] pin);

pin_bidir p0(i[0], o[0], dir, pin[0]);
pin_bidir p1(i[1], o[1], dir, pin[1]);
pin_bidir p2(i[2], o[2], dir, pin[2]);
pin_bidir p3(i[3], o[3], dir, pin[3]);
pin_bidir p4(i[4], o[4], dir, pin[4]);
pin_bidir p5(i[5], o[5], dir, pin[5]);
pin_bidir p6(i[6], o[6], dir, pin[6]);
pin_bidir p7(i[7], o[7], dir, pin[7]);

endmodule

module pin_bidir_14(
	input [13:0] i,
	output [13:0] o,
	input dir,
	input [13:0] pin);

pin_bidir p0(i[0], o[0], dir, pin[0]);
pin_bidir p1(i[1], o[1], dir, pin[1]);
pin_bidir p2(i[2], o[2], dir, pin[2]);
pin_bidir p3(i[3], o[3], dir, pin[3]);
pin_bidir p4(i[4], o[4], dir, pin[4]);
pin_bidir p5(i[5], o[5], dir, pin[5]);
pin_bidir p6(i[6], o[6], dir, pin[6]);
pin_bidir p7(i[7], o[7], dir, pin[7]);
pin_bidir p8(i[8], o[8], dir, pin[8]);
pin_bidir p9(i[9], o[9], dir, pin[9]);
pin_bidir p10(i[10], o[10], dir, pin[10]);
pin_bidir p11(i[11], o[11], dir, pin[11]);
pin_bidir p12(i[12], o[12], dir, pin[12]);
pin_bidir p13(i[13], o[13], dir, pin[13]);

endmodule
