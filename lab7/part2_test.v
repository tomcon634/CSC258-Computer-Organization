// Part 2 skeleton

module part2_test
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		  x,
		  y,
		  colour
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;
	output [7:0] x;
	output [6:0] y;
	output [2:0] colour;
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	//wire [2:0] colour;
	//wire [7:0] x;
	//wire [6:0] y;
	wire writeEn;
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.
	wire ld_x, ld_y;
	wire alu_op_x, alu_op_y;
    
    // Instansiate datapath
	datapath d0(resetn, CLOCK_50, SW[9:7], SW[6:0], ld_x, ld_y, alu_op_x, alu_op_y, x, y, colour);

    // Instansiate FSM control
   control c0(KEY[3], resetn, CLOCK_50, ld_x, ld_y, alu_op_x, alu_op_y, writeEn);
    
endmodule

module datapath(reset, clock, colour, pos, ld_x, ld_y, alu_op_x, alu_op_y, out_x, out_y, out_c);
	input reset, clock;
	input [6:0] pos;
	input [2:0] colour;
	input ld_x, ld_y;
	input alu_op_x, alu_op_y;
	output [7:0] out_x;
	output [6:0] out_y;
	output [2:0] out_c;
	
	reg [7:0] x;
	reg [6:0] y;
	reg [2:0] c;
	
	always @(posedge clock)
	begin
		if (!reset)
		begin
			x <= 8'd0;
			y <= 7'd0;
			c <= 3'd0;
		end
		else
		begin
			c <= colour;
			if (ld_x)
				x <= pos;
			if (ld_y)
				y <= pos;
		end
	end
	alu8 ax(x, alu_op_x, out_x);
	alu7 ay(y, alu_op_y, out_y);
	assign out_c = c;
	
endmodule

module alu7(inp, alu_op, out);
	input [6:0] inp;
	input alu_op;
	output reg [6:0] out;
	
	always @(*)
	begin
		case (alu_op)
			1'b0: out = inp;
			1'b1: out = inp + 1'b1;
		endcase
	end
endmodule

module alu8(inp, alu_op, out);
	input [7:0] inp;
	input alu_op;
	output reg [7:0] out;
	
	always @(*)
	begin
		case (alu_op)
			1'b0: out = inp;
			1'b1: out = inp + 1'b1;
		endcase
	end
endmodule

module control(go, reset, clock, ld_x, ld_y, alu_op_x, alu_op_y, plot);
	input go, reset, clock;
	output reg ld_x, ld_y;
	output reg alu_op_x, alu_op_y;
	output reg plot;
	
	reg [2:0] current_state, next_state;
	localparam load_xc = 3'd0, load_y = 3'd1, output_xy = 3'd2, output_x1y = 3'd3, output_xy1 = 3'd4, output_x1y1 = 3'd5;
	
	always @(*)
	begin
		case (current_state)
			load_xc: next_state = go ? load_y : load_xc;
			load_y: next_state = go ? output_xy : load_y;
			output_xy: next_state = go ? output_x1y : output_xy;
			output_x1y: next_state = go ? output_xy1 : output_x1y;
			output_xy1: next_state = go ? output_x1y1 : output_xy1;
			output_x1y1: next_state = go ? load_xc : output_x1y1;
			default: next_state = load_xc;
		endcase
	end
	
	always @(*)
	begin
		ld_x = 1'b0; ld_y = 1'b0;
		alu_op_x = 1'b0; alu_op_y = 1'b0;
		plot = 1'b0;
		
		case (current_state)
			load_xc:
			begin
				ld_x = 1'b1;
				plot = 1'b0;
			end
			load_y:
			begin
				ld_x = 1'b0; ld_y = 1'b1;
				plot = 1'b0;
			end
			output_xy:
			begin
				ld_x = 1'b0; ld_y = 1'b0;
				alu_op_x = 1'b0; alu_op_y = 1'b0;
				plot = 1'b1;
			end
			output_x1y:
			begin
				ld_x = 1'b0; ld_y = 1'b0;
				alu_op_x = 1'b1; alu_op_y = 1'b0;
				plot = 1'b1;
			end
			output_xy1:
			begin
				ld_x = 1'b0; ld_y = 1'b0;
				alu_op_x = 1'b0; alu_op_y = 1'b1;
				plot = 1'b1;
			end
			output_x1y1:
			begin
				ld_x = 1'b0; ld_y = 1'b0;
				alu_op_x = 1'b1; alu_op_y = 1'b1;
				plot = 1'b1;
			end
		endcase
	end
	
	always @(posedge clock)
	begin
		if (!reset)
			current_state <= load_xc;
		else
			current_state <= next_state;
	end
endmodule