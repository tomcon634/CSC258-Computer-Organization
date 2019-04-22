module ripple_adder(LEDR, SW);
	input [9:0] SW;
	output [9:0] LEDR;
	
	wire c1;
	wire c2;
	wire c3;
	
	full_adder a1(
		.a(SW[1]),
		.b(SW[5]),
		.cin(SW[0]),
		.s(LEDR[0]),
		.cout(c1));
	
	full_adder a2(
		.a(SW[2]),
		.b(SW[6]),
		.cin(c1),
		.s(LEDR[1]),
		.cout(c2));
	
	full_adder a3(
		.a(SW[3]),
		.b(SW[7]),
		.cin(c2),
		.s(LEDR[2]),
		.cout(c3));
		
	full_adder a4(
		.a(SW[4]),
		.b(SW[8]),
		.cin(c3),
		.s(LEDR[3]),
		.cout(LEDR[4]));
	
endmodule

module full_adder(a, b, cin, s, cout);
	input a;
	input b;
	input cin;
	output s;
	output cout;
	
	assign s = ~a & ~b & cin | ~a & b & ~cin | a & ~b & ~cin | a & b & cin;
	assign cout = a & b | cin & b | cin & a;
	
endmodule
