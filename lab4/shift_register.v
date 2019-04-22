module shift_register(SW, KEY, LEDR);
	input [9:0] SW;
	input [3:0] KEY;
	output [7:0] LEDR;
	
	wire w7, w6, w5, w4, w3, w2, w1;
	wire c;
	
	mux2to1 m0(1'b0, SW[7], KEY[3], c);
	
	shifter_bit sb7(SW[7], KEY[1], KEY[2], c, KEY[0], SW[9], w7);
	shifter_bit sb6(SW[6], KEY[1], KEY[2], w7, KEY[0], SW[9], w6);
	shifter_bit sb5(SW[5], KEY[1], KEY[2], w6, KEY[0], SW[9], w5);
	shifter_bit sb4(SW[4], KEY[1], KEY[2], w5, KEY[0], SW[9], w4);
	shifter_bit sb3(SW[3], KEY[1], KEY[2], w4, KEY[0], SW[9], w3);
	shifter_bit sb2(SW[2], KEY[1], KEY[2], w3, KEY[0], SW[9], w2);
	shifter_bit sb1(SW[1], KEY[1], KEY[2], w2, KEY[0], SW[9], w1);
	shifter_bit sb0(SW[0], KEY[1], KEY[2], w1, KEY[0], SW[9], LEDR[0]);
	
	assign LEDR[7] = w7;
	assign LEDR[6] = w6;
	assign LEDR[5] = w5;
	assign LEDR[4] = w4;
	assign LEDR[3] = w3;
	assign LEDR[2] = w2;
	assign LEDR[1] = w1;
	
endmodule

module shifter_bit(load_val, load_n, shift, in, clk, reset_n, out);
	input load_val, load_n, shift, in, clk, reset_n;
	output out;
	
	wire w0, w1, w2;
	
	mux2to1 m0(w2, in, shift, w0);
	mux2to1 m1(load_val, w0, load_n, w1);
	flipflop f0(w1, clk, reset_n, w2);
	assign out = w2;
		
endmodule

module flipflop(d, clock, reset_n, q);
	input d, clock, reset_n;
	output q;
	reg q;
	
	always @(posedge clock)
	begin
		if (reset_n == 1'b0)
			q <= 0;
		else
			q <= d;
	end
endmodule

module mux2to1 (x, y, s, m);
	input x; //selected when s is 0
	input y; //selected when s is 1
	input s; //select signal
	output m; //output
	assign m = s & y | ~s & x;
	
endmodule