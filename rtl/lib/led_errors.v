// vim: set ts=4:sts=4:sw=4:noet
`default_nettype none

module led_errors(
	input  clock,
	input  reset,
	input  [7:0] error_word_i,
	input  led_a_value_i,
	input  led_b_value_i,
	input  led_c_value_i,
	input  led_d_value_i,
	output led_a_pin_o,
	output led_b_pin_o,
	output led_c_pin_o,
	output led_d_pin_o);

reg engaged;
initial engaged = 1;

always @(posedge clock) begin
	if (!reset) begin
		engaged <= 0;
	end else if (error_word_i == 0) begin
		engaged <= 0;
	end else begin
		engaged <= 1;
	end
end

wire step;
pulse #(.CLOCKS_PER_PULSE(3000000))  // 0.25Hz
	pulse0(.clock(clock), .pulse_o(step));

reg [1:0] phase;
initial phase = 0;
reg [2:0] count;
initial count = 0;
always @(posedge clock)
	if (step) begin
		if (count == 5) begin
			phase <= phase + 1;
			count <= 0;
		end else begin
			count <= count + 1;
		end
	end

// States
//     0 1 2 3 4 5 6 7 8 9 a b c d e f 0 1 2 3
// A = 1 0 1 0 0 a a a a 0 0 1 0 1 0 e e e e 0
// B = 0 1 0 1 0 b b b b 0 1 0 1 0 0 f f f f 0
// C = 1 0 1 0 0 c c c c 0 0 1 0 1 0 g g g g 0
// D = 0 1 0 1 0 d d d d 0 1 0 1 0 0 h h h h 0
reg led_a_flash;
reg led_b_flash;
reg led_c_flash;
reg led_d_flash;

always @(posedge clock) begin
	if (count == 5) begin
		led_a_flash <= 0;
		led_b_flash <= 0;
		led_c_flash <= 0;
		led_d_flash <= 0;
	end else case (phase)
		2'd0: begin
			led_a_flash <= ~count[0];
			led_b_flash <= count[0];
			led_c_flash <= ~count[0];
			led_d_flash <= count[0];
		end
		2'd1: begin
			led_a_flash <= error_word_i[0];
			led_b_flash <= error_word_i[1];
			led_c_flash <= error_word_i[2];
			led_d_flash <= error_word_i[3];
		end
		2'd2: begin
			led_a_flash <= count[0];
			led_b_flash <= ~count[0];
			led_c_flash <= count[0];
			led_d_flash <= ~count[0];
		end
		2'd1: begin
			led_a_flash <= error_word_i[4];
			led_b_flash <= error_word_i[5];
			led_c_flash <= error_word_i[6];
			led_d_flash <= error_word_i[7];
		end
	endcase
end

assign led_a_pin_o = (reset ? (engaged ? led_a_flash : led_a_value_i) : 0);
assign led_b_pin_o = (reset ? (engaged ? led_b_flash : led_b_value_i) : 0);
assign led_c_pin_o = (reset ? (engaged ? led_c_flash : led_c_value_i) : 0);
assign led_d_pin_o = (reset ? (engaged ? led_d_flash : led_d_value_i) : 0);

endmodule
