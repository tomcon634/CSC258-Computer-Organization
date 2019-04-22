module ALU_register(SW, KEY, LEDR, HEX0, HEX4, HEX5);
	input [9:0] SW;
	input [3:0] KEY;
	output [9:0] LEDR;
	output [6:0] HEX0, HEX4, HEX5;
	
	wire [3:0] b;
	wire [7:0] out0;
	
	ALU alu(SW[3:0], b[3:0], SW[7:5], LEDR[7:0]);
	hexdisplay h0(SW[3:0], HEX0);
	register r(LEDR[7:0], KEY[0], out0);
	assign b[3:0] = out0[3:0];
	hexdisplay h4(out0[3:0], HEX4);
	hexdisplay h5(out0[7:4], HEX5);
	
endmodule

module register(d, clock, q);
	input [7:0] d;
	input clock;
	output [7:0] q;
	reg [7:0] q;
	
	always @(posedge clock)
	begin
		q <= d;
		/*if (reset_n == 1'b0)
			q <= 0;
		else
			q <= d;*/
	end
endmodule

module ALU(a, b, inp_fun, out);
	input [3:0] a;
	input [3:0] b;
	input [2:0] inp_fun;
	output [7:0] out;
	
	// wires going into multiplexer
	wire [7:0] w0;
	wire [7:0] w1;
	wire [7:0] w2;
	wire [7:0] w3;
	wire [7:0] w4;
	wire [7:0] w5;
	wire [7:0] w6;
	wire [7:0] w7;
	
	wire dummy;
	
	// determining output for each key and placing it in its corresponding wire
	rippleadder r0 (a[3:0], 4'b0001, 1'b0, dummy, w0[3:0]);
	rippleadder r1 (a[3:0], b[3:0], 1'b0, dummy, w1[3:0]);
	assign w0[7:4] = 4'b0000;
	assign w1[7:4] = 4'b0000;
	assign w2 = {4'b0000, a[3:0] + b[3:0]}; 
	assign w3 = {a[3] | b[3], a[2] | b[2], a[1] | b[1], a[0] | b[0],
						a[3] ^ b[3], a[2] ^ b[2], a[1] ^ b[1], a[0] ^ b[0]};
	assign w4 = {7'b000_0000, | (a[3:0] & b[3:0])};
	assign w5[7:0] = b[3:0] << a[3:0];
	assign w6[7:0] = b[3:0] >> a[3:0];
	assign w7[7:0] = b[3:0] * a[3:0];
	
	// choosing which outp ut to display
	reg [7:0] Out;
	always @(*)
	begin
		case (inp_fun[2:0])
			3'b000: Out = w0;
			3'b001: Out = w1;
			3'b010: Out = w2;
			3'b011: Out = w3;
			3'b100: Out = w4;
			3'b101: Out = w5;
			3'b110: Out = w6;
			3'b111: Out = w7;
			default: Out = 0;
		endcase
	end
	
	assign out[7:0] = Out[7:0];
	
endmodule

module rippleadder(A, B, cin, cout, s);
	input [7:4] A;
	input [3:0] B;
	input cin;
	output cout;
	output [3:0] s;
	
	// wires going between each full_add instance
	wire [2:0] w;
	
	fulladd f1 (A[4], B[0], cin, w[0], s[0]);
	fulladd f2 (A[5], B[1], w[0], w[1], s[1]);
	fulladd f3 (A[6], B[2], w[1], w[2], s[2]);
	fulladd f4 (A[7], B[3], w[2], cout, s[3]);

endmodule

module fulladd(A, B, cin, cout, S);
	// incoming bits to add, including a carry
	input A;
	input B;
	input cin;
	// carry and sum digits as a result of addition
	output cout;
	output S;
	
	wire w;
	
	assign w = A & ~B | ~A & B;
	mux2to1 m1(B, cin, w, cout);
	assign S = cin & ~w | ~cin & w;
	
endmodule

module mux2to1 (x, y, s, m);
	input x; //selected when s is 0
	input y; //selected when s is 1
	input s; //select signal
	output m; //output
	assign m = s & y | ~s & x;
	
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