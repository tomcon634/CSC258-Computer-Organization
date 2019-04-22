module counter(SW, KEY, HEX0, HEX1);
	input [1:0] SW;
	input [0:0] KEY;
	output [6:0] HEX0, HEX1;
	
	wire [7:0] out;
	
	count c0(SW[1], KEY[0], SW[0], out);
	hexdisplay h0(out[3:0], HEX0);
	hexdisplay h1(out[7:4], HEX1);
	
endmodule

module count(enable, clock, clear_b, q);
	input enable, clock, clear_b;
	output [7:0] q;
	
	wire w6, w5, w4, w3, w2, w1, w0;
	
	assign w1 = enable & q[0];
	assign w2 = w1 & q[1];
	assign w3 = w2 & q[2];
	assign w4 = w3 & q[3];
	assign w5 = w4 & q[4];
	assign w6 = w5 & q[5];
	assign w7 = w6 & q[6];
	
	t_flipflop t0(enable, clock, clear_b, q[0]);
	t_flipflop t1(w1, clock, clear_b, q[1]);
	t_flipflop t2(w2, clock, clear_b, q[2]);
	t_flipflop t3(w3, clock, clear_b, q[3]);
	t_flipflop t4(w4, clock, clear_b, q[4]);
	t_flipflop t5(w5, clock, clear_b, q[5]);
	t_flipflop t6(w6, clock, clear_b, q[6]);
	t_flipflop t7(w7, clock, clear_b, q[7]);
	
endmodule

module t_flipflop(t, clock, reset, q);
	input t, clock, reset;
	output q;
	reg q;
	
	always @(posedge clock, negedge reset)
	begin
		if (reset == 1'b0)
			q <= 0;
		else if (t == 1'b0)
			q <= q;
		else
			q <= ~q;
	end
	
endmodule

module hexdisplay(c, out);
	input [3:0] c;		// binary representation of the character to be shown
	output [6:0] out; // each segment in the 7-seg display
	
	//setting each segment to on/off individually
	assign out[0] = ~c[3] & ~c[2] & ~c[1] & c[0] |
						~c[3] & c[2] & ~c[1] & ~c[0] |
						c[3] & ~c[2] & c[1] & c[0] |
						c[3] & c[2] & ~c[1] & c[0];
						
	assign out[1] = ~c[3] & c[2] & ~c[1] & c[0] |
						 c[3] & c[2] & ~c[0] |
						 c[2] & c[1] & ~c[0] |
						 c[3] & c[1] & c[0];
						 
	assign out[2] = ~c[3] & ~c[2] & c[1] & ~c[0] |
						 c[3] & c[2] & ~c[0] |
						 c[3] & c[2] & c[1];
	
	assign out[3] = ~c[3] & c[2] & ~c[1] & ~c[0] |
						 c[3] & ~c[2] & c[1] & ~c[0] |
						 c[2] & c[1] & c[0] |
						 ~c[2] & ~c[1] & c[0];
	
	assign out[4] = ~c[3] & c[0] |
						 ~c[3] & c[2] & ~c[1] |
						 ~c[2] & ~c[1] & c[0]; 
	
	assign out[5] = ~c[3] & ~c[2] & c[0] |
						 ~c[3] & c[1] & c[0] |
						 ~c[3] & ~c[2] & c[1] |
						 c[3] & c[2] & ~c[1] & c[0];
	
	assign out[6] = ~c[3] & ~c[2] & ~c[1] |
						 c[3] & c[2] & ~c[1] & ~c[0] |
				       ~c[3] & c[2] & c[1] & c[0];
						 
endmodule
