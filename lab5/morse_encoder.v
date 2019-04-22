module morse_encoder(SW, KEY, CLOCK_50, LEDR, w);
	input [2:0] SW;
	input [1:0] KEY;
	input CLOCK_50;
	output [1:0] LEDR;
	
	input [13:0] w;
	
	wire [13:0] mux_out;
	wire enable;
	
	mux8to14 mux0(SW[2:0], mux_out);
	rate_divider d0(CLOCK_50, KEY[0], enable, KEY[1]);
	shift_register sr0(mux_out[13:0], KEY[0], CLOCK_50, KEY[1], enable, 1'b0, LEDR[0], w);
	
endmodule

module mux8to14(in, out);
	input [2:0] in;
	output [13:0] out;
	
	reg [13:0] out;
	always @(*)
	begin
		case (in[2:0])
			3'b000: out = 14'b00000000010101;
			3'b001: out = 14'b00000000000111;
			3'b010: out = 14'b00000001110101;
			3'b011: out = 14'b00000111010101;
			3'b100: out = 14'b00000111011101;
			3'b101: out = 14'b00011101010111;
			3'b110: out = 14'b01110111010111;
			3'b111: out = 14'b00010101110111;
			default: out = 0;
		endcase
	end
endmodule

module rate_divider(clock, reset_n, enable, start);
	input clock, reset_n;
	input start;
	output enable;
	
	reg [26:0] n;
	reg enable;
	
	always @(posedge clock, negedge reset_n, negedge start)
	begin
		if (reset_n == 1'b0 || start == 1'b0)
			n <= 0;
		else if (n == 3'd001)
			begin
				enable <= 1'b1;
				n <= 0;
			end
		else
			begin
				enable <= 0;
				n <= n + 1'b1;
			end
	end
endmodule

module shift_register(load_val, reset, clock, load, shift, ASR, out, w);
	input [13:0] load_val;
	input reset;
	input clock, load, shift, ASR;
	output out;
	
	output [13:0] w;
	//wire [13:0] w;
	
	mux2to1 m0(1'b0, load_val[13], 1'b0, c);
	
	shifter_bit sb13(load_val[13], load, shift, 1'b0, clock, reset, w[13]);
	shifter_bit sb12(load_val[12], load, shift, w[13], clock, reset, w[12]);
	shifter_bit sb11(load_val[11], load, shift, w[12], clock, reset, w[11]);
	shifter_bit sb10(load_val[10], load, shift, w[11], clock, reset, w[10]);
	shifter_bit sb9(load_val[9], load, shift, w[10], clock, reset, w[9]);
	shifter_bit sb8(load_val[8], load, shift, w[9], clock, reset, w[8]);
	shifter_bit sb7(load_val[7], load, shift, w[8], clock, reset, w[7]);
	shifter_bit sb6(load_val[6], load, shift, w[7], clock, reset, w[6]);
	shifter_bit sb5(load_val[5], load, shift, w[6], clock, reset, w[5]);
	shifter_bit sb4(load_val[4], load, shift, w[5], clock, reset, w[4]);
	shifter_bit sb3(load_val[3], load, shift, w[4], clock, reset, w[3]);
	shifter_bit sb2(load_val[2], load, shift, w[3], clock, reset, w[2]);
	shifter_bit sb1(load_val[1], load, shift, w[2], clock, reset, w[1]);
	shifter_bit sb0(load_val[0], load, shift, w[1], clock, reset, w[0]);
	
	assign out = w[0];
	
endmodule

module shifter_bit(load_val, load_n, shift, in, clk, reset_n, out);
	input load_val, load_n, shift, in, clk, reset_n;
	output out;
	
	wire w0, w1, w2;
	
	mux2to1 m0(w2, in, shift, w0);
	mux2to1 m1(load_val, w0, load_n, w1);
	flipflop f0(w1, clk, reset_n, w2, load_n);
	assign out = w2;
		
endmodule

module flipflop(d, clock, reset_n, q, start);
	input d, clock, reset_n, start;
	output q;
	reg q;
	
	always @(posedge clock, negedge reset_n)
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