module ShifterBit(LoadVal, Load_n, Shift, in, clk, reset_n, out);
	input LoadVal, Load_n, Shift, in, clk, reset_n;
	output out;
	
	wire w0, w1;
	
	mux2to1 M0(
		.x(out),
		.y(in),
		.s(Shift),
		.m(w0));
	
	mux2to1 M1(
		.x(LoadVal),
		.y(w0),
		.s(Load_n),
		.m(w1));
		
	flipflop F0(
		.d(w1),
		.q(out),
		.clock(clk),
		.reset_n(reset_n));
		
endmodule
