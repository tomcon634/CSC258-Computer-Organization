module mux7to1(LEDR, SW);
	input [9:0] SW;
	output [9:0] LEDR;
	
	mux7 m(
		.i0(SW[0]),
		.i1(SW[1]),
		.i2(SW[2]),
		.i3(SW[3]),
		.i4(SW[4]),
		.i5(SW[5]),
		.i6(SW[6]),
		.s0(SW[7]),
		.s1(SW[8]),
		.s2(SW[9]),
		.out(LEDR[0]));
		
endmodule

module mux7(i0, i1, i2, i3, i4, i5, i6, s0, s1, s2, out);
	input i0, i1, i2, i3, i4, i5, i6;
	input s0, s1, s2;
	output out;
	
	reg out;

	always @(*)
	begin
		case ({s2, s1, s0})
			3'b000: out = i0;
			3'b001: out = i1;
			3'b010: out = i2;
			3'b011: out = i3;
			3'b100: out = i4;
			3'b101: out = i5;
			3'b110: out = i6;
			default: out = i6;
		endcase
	end
endmodule
