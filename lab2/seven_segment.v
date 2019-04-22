module seg(LEDR, SW);
	input [9:0] SW;
	output [9:0] LEDR;
	
	sev_seg s(
		.c0(SW[0]),
		.c1(SW[1]),
		.c2(SW[2]),
		.c3(SW[3]),
		.s0(LEDR[0]),
		.s1(LEDR[1]),
		.s2(LEDR[2]),
		.s3(LEDR[3]),
		.s4(LEDR[4]),
		.s5(LEDR[5]),
		.s6(LEDR[6])
		);
		
endmodule

module sev_seg(c0, c1, c2, c3, s0, s1, s2, s3, s4, s5, s6);
	input c0;
	input c1;
	input c2;
	input c3;
	output s0;
	output s1;
	output s2;
	output s3;
	output s4;
	output s5;
	output s6;
	
	assign s0 = ~c3 & ~c2 & ~c0 
		| ~c3 & ~c2 & c1 
		| c1 & ~c0
		| ~c3 & c2 & c0
		| c2 & c1
		| c3 & c2 & ~c0
		| c3 & ~c2 & ~c1;
		
	assign s1 = ~c2 & ~c1
		| ~c3 & ~c1 & ~c0
		| ~c3 & ~c2
		| ~c3 & c1 & c0
		| ~c2 & c1 & ~c0
		| c3 & ~c1 & c0;
		
	assign s2 = ~c3 & ~c1
		| ~c3 & c0
		| ~c1 & c0
		| ~c3 & c2
		| c3 & ~c2;
	
	assign s3 = ~c2 & ~c1 & ~c0
		| ~c3 & ~c2 & ~c0
		| ~c2 & c1 & c0
		| c2 & ~c1 & c0
		| c2 & c1 & ~c0
		| c3 & c2 & ~c1;
		
	assign s4 = ~c2 & ~c1 & ~c0
		| c1 & ~c0
		| c3 & c2
		| c3 & c1;
		
	assign s5 = ~c1 & ~c0
		| ~c3 & c2 & ~c1
		| c2 & c1 & ~c0
		| c3 & c1
		| c3 & ~c2;
	
	assign s6 = ~c3 & ~c2 & c1
		| ~c3 & c2 & ~c1
		| c1 & ~c0
		| c3 & c0
		| c3 & ~c2;

endmodule
