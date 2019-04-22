module counter2(SW, CLOCK_50, HEX0);
	input [3:0] SW;
	input CLOCK_50;
	output [6:0] HEX0;
	
	wire en;
	wire [3:0] hex;
	
	rate_divider r0(SW[1:0], CLOCK_50, SW[3], en);
	count c0(CLOCK_50, SW[3], en, hex);
	hexdisplay h0(hex, HEX0);
	
endmodule

module count(clock, reset_n, enable, q);
	input clock, reset_n, enable;
	output [3:0] q;
	reg [3:0] q;
	
	always @(posedge clock)
	begin
		if (reset_n == 1'b0)
			q <= 0;
		else if (enable == 1'b1)
			q <= q + 1'b1;
	end
endmodule

module rate_divider(speed_func, clock, reset_n, enable);
	input [1:0] speed_func;
	input clock, reset_n;
	output enable;
	
	reg [25:0] n;
	reg enable;
	reg [25:0] max;
	
	always @(*)
	begin
		case (speed_func[1:0])
			2'b00: max <= 28'b0000000000000000000000000000;
			2'b01: max <= 28'b0010111110101111000010000000;
			2'b10: max <= 28'b0101111101011110000100000000;
			2'b11: max <= 28'b1011111010111100001000000000;
			default: max <= 0;
		endcase
	end
	
	always @(posedge clock)
	begin
		if (reset_n == 1'b0)
			n <= 0;
		else
		begin
			if (n == max)
			begin
				enable <= 1'b1;
				n <= 0;
			end
			else
				enable <= 0;
				n <= n + 1'b1;
		end
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
