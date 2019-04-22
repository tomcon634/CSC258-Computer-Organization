module mux(LEDR, SW);
	input [9:0] SW;
	output [9:0] LEDR;
	
	mux4to1 m4(
		.u(SW[0]),
		.v(SW[1]),
		.w(SW[2]),
		.x(SW[3]),
		.s0(SW[8]),
		.s1(SW[9]),
		.m(LEDR[0])
		);
		
endmodule

module mux4to1(u, v, w, x, s0, s1, m);
	input u;
	input v;
	input w;
	input x;
	input s0;
	input s1;
	output m;
	
	wire c0;
	wire c1;
	
	mux2to1 u0(u, v, s0, c0);
	mux2to1 u1(w, x, s0, c1);
	mux2to1 u2(c0, c1, s1, m);
	
endmodule

module mux2to1(x, y, s, m);
	input x;
	input y;
	input s;
	output m;
	
	assign m = s & y | ~s & x;
	
endmodule
