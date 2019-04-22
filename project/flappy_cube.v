module flappy_cube (CLOCK_50, KEY, PS2_CLK, PS2_DAT, VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_R, VGA_G, VGA_B, HEX0, HEX1, HEX2);
	input			CLOCK_50;
	input   [1:0]   KEY;
	inout PS2_CLK, PS2_DAT;
	output			VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N;
	output	[9:0]	VGA_R, VGA_G, VGA_B; 
	output [6:0] HEX0, HEX1, HEX2;
	
	/*vga_adapter VGA(.resetn(KEY[0]), .clock(CLOCK_50), .colour(colour), .x(x), .y(y), .plot(WriteEn), .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B), .VGA_HS(VGA_HS),
	.VGA_VS(VGA_VS),.VGA_BLANK(VGA_BLANK_N),.VGA_SYNC(VGA_SYNC_N),.VGA_CLK(VGA_CLK));
	defparam VGA.RESOLUTION = "160x120";
	defparam VGA.MONOCHROME = "FALSE";
	defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
	defparam VGA.BACKGROUND_IMAGE = "black.mif";*/
	
	reg [2:0] colour;
	reg [7:0] x;
	reg [6:0] y;
	reg [6:0] line_gap;
	wire [7:0] x_start_0, x_start_1, x_start_2, x_start_3, x_start_4, x_start_5, erase_x, x_start_p;
	wire [6:0] erase_y, y_start_p;
	wire [6:0] line_gap_0, line_gap_1, line_gap_2, line_gap_3, line_gap_4, line_gap_5, random_gap;
	wire frame_enable, update_enable, erase_enable, draw_enable, game_over_count_enable, time_enable;
	wire f_overflow, c_overflow, l_overflow, e_overflow, g_overflow, t_overflow;
	wire WriteEn, reset_all, reset_next_cycle, collision, collision_check_en;
	wire [3:0] c_count;
	wire [6:0] l_count;
	wire [2:0] coord_select;
	wire [1:0] colour_select;
	wire up, left, down, right;
	wire speed;
	wire null_wire;
	wire [19:0] start_count;
	 
	always @(*)
	begin
	case (colour_select)
		2'd0: colour = 3'b111;
		2'd1: colour = 3'b000;
		2'd2: colour = 3'b100;
		default: colour = 3'b010;
	endcase
	end
	
	always @(*)
	begin
		case (coord_select)
			3'd0: begin 
				x = x_start_0 + c_count[3:2];
				y = l_count + c_count[1:0];
				line_gap = line_gap_0;
				end
			3'd1: begin 
				x = x_start_1 + c_count[3:2];
				y = l_count + c_count[1:0];
				line_gap = line_gap_1;
				end
			3'd2: begin 
				x = x_start_2 + c_count[3:2];
				y = l_count + c_count[1:0];
				line_gap = line_gap_2;
				end
			3'd3: begin 
				x = x_start_3 + c_count[3:2];
				y = l_count + c_count[1:0];
				line_gap = line_gap_3;
				end
			3'd4: begin 
				x = x_start_4 + c_count[3:2];
				y = l_count + c_count[1:0];
				line_gap = line_gap_4;
				end
			3'd5: begin
				x = x_start_5 + c_count[3:2];
				y = l_count + c_count[1:0];
				line_gap = line_gap_5;
				end
			3'd6: begin
				x = x_start_p + c_count[3:2];
				y = y_start_p + c_count[1:0];
				line_gap = 0;
				end
			3'd7: begin
				x = erase_x;
				y = erase_y;
				line_gap = 0;
				end
			default: begin
				x = 0;
				y = 0;
				line_gap = 0;
				end
		endcase
	end
	
	timer tim0 (
		.clk(CLOCK_50),
		.resetn(reset_all),
		.enable(t_overflow),
		.start_count(start_count),
		.HEX0(HEX0),
		.HEX1(HEX1),
		.HEX2(HEX2)
	);
	
	 keyboard_tracker #(.PULSE_OR_HOLD(0)) tester(
	  .clock(CLOCK_50),
	  .reset(KEY[0]),
	  .PS2_CLK(PS2_CLK),
	  .PS2_DAT(PS2_DAT),
	  .w(up),
	  .a(left),
	  .s(down),
	  .d(right),
	  .left(null_wire),
	  .right(null_wire),
	  .up(null_wire),
	  .down(null_wire),
	  .space(speed),
	  .enter(null_wire)
	  );
	  
	 CubeMover cm0 (
		.clk(CLOCK_50),
		.resetn(reset_all),
		.enable(update_enable),
		.up(up),
		.left(left),
		.down(down),
		.right(right),
		.speed(speed),
		.x_start(x_start_p),
		.y_start(y_start_p)
		);
	
	GameOverCounter goc0 (
		.clk(CLOCK_50),
		.resetn(reset_all),
		.enable(game_over_count_enable),
		.g_overflow(g_overflow)
		);
		
	SecondCounter sc0 (
		.clk(CLOCK_50),
		.resetn(reset_all),
		.enable(time_enable),
		.t_overflow(t_overflow)
		);
	
	CollisionChecker cc0 (
		.clk(CLOCK_50),
		.resetn(reset_all),
		.enable(collision_check_en),
		.current_x(x),
		.current_y(y),
		.player_x(x_start_p),
		.player_y(y_start_p),
		.collision(collision)
		);
	
	RandNumGen rng0 (
		.clk(CLOCK_50),
		.resetn(reset_all),
		.enable(l_overflow),
		.line_gap(random_gap)
	);
	
	CubeDrawer dr0 (
		.clk(CLOCK_50),
		.resetn(reset_next_cycle),
		.enable(draw_enable),
		.stop(l_overflow),
		.c_count(c_count),
		.c_overflow(c_overflow)
		);
	
	LineDrawer ld0 (
		.clk(CLOCK_50),
		.resetn(reset_next_cycle),
		.enable(c_overflow),
		.line_gap(line_gap),
		.l_count(l_count),
		.l_overflow(l_overflow)
		);
		
	XCounter x0 (
		.clk(CLOCK_50),
		.resetn(reset_all),
		.enable(update_enable),
		.starting_gap(7'd60),
		.random_gap(random_gap),
		.original_x(8'd35),
		.line_gap(line_gap_0),
		.x(x_start_0)
		);
		
	XCounter x1 (
		.clk(CLOCK_50),
		.resetn(reset_all),
		.enable(update_enable),
		.starting_gap(7'd105),
		.random_gap(random_gap),
		.original_x(8'd75),
		.line_gap(line_gap_1),
		.x(x_start_1)
		);
	
	XCounter x2 (
		.clk(CLOCK_50),
		.resetn(reset_all),
		.enable(update_enable),
		.starting_gap(7'd25),
		.random_gap(random_gap),
		.original_x(8'd115),
		.line_gap(line_gap_2),
		.x(x_start_2)
		);
		
	XCounter x3 (
		.clk(CLOCK_50),
		.resetn(reset_all),
		.enable(update_enable),
		.starting_gap(7'd40),
		.random_gap(random_gap),
		.original_x(8'd155),
		.line_gap(line_gap_3),
		.x(x_start_3)
		);
		
	XCounter x4 (
		.clk(CLOCK_50),
		.resetn(reset_all),
		.enable(update_enable),
		.starting_gap(7'd100),
		.random_gap(random_gap),
		.original_x(8'd195),
		.line_gap(line_gap_4),
		.x(x_start_4)
		);
		
	XCounter x5 (
		.clk(CLOCK_50),
		.resetn(reset_all),
		.enable(update_enable),
		.starting_gap(7'd10),
		.random_gap(random_gap),
		.original_x(8'd235),
		.line_gap(line_gap_5),
		.x(x_start_5)
		);

	 FrameCounter f0 (
		.clk(CLOCK_50),
		.resetn(reset_next_cycle),
		.enable(frame_enable),
		.start_count(start_count),
		.f_overflow(f_overflow)
	 );
	 
	 Eraser e0 (
		.clk(CLOCK_50),
		.resetn(reset_next_cycle),
		.enable(erase_enable),
		.erase_x(erase_x),
		.erase_y(erase_y),
		.e_overflow(e_overflow)
	 );
	 
	 control c0 (
		.clk(CLOCK_50),
		.resetn(KEY[0]),
		.x(x), .y(y),
		.f_overflow(f_overflow),
		.l_overflow(l_overflow),
		.c_overflow(c_overflow),
		.e_overflow(e_overflow),
		.g_overflow(g_overflow),
		.collision(collision),
		.start(~KEY[1]),
		.coord_select(coord_select),
		.colour_select(colour_select),
		.WriteEn(WriteEn),
		.reset_next_cycle(reset_next_cycle),
		.reset_all(reset_all),
		.collision_check_en(collision_check_en),
		.frame_enable(frame_enable),
		.update_enable(update_enable),
		.erase_enable(erase_enable),
		.draw_enable(draw_enable),
		.game_over_count_enable(game_over_count_enable),
		.time_enable(time_enable)
	);
    
endmodule

module control(
	input clk,
	input resetn,
	input [7:0] x,
	input [6:0] y,
	input f_overflow, l_overflow, c_overflow, e_overflow, g_overflow, collision, start,
	output reg [2:0] coord_select,
	output reg [1:0] colour_select,
	output reg WriteEn,reset_next_cycle, reset_all, collision_check_en,
	output reg frame_enable, update_enable, erase_enable, draw_enable, game_over_count_enable, time_enable
	);

	reg [3:0] current_state, next_state;
	
	localparam  IDLE			= 4'd0,
					IDLE_WAIT   = 4'd1,
					DRAW_LINE_0 = 4'd2,
					DRAW_LINE_1 = 4'd3,
					DRAW_LINE_2 = 4'd4,
					DRAW_LINE_3 = 4'd5,
					DRAW_LINE_4 = 4'd6,
					DRAW_LINE_5 = 4'd7,
					DRAW_PLAYER = 4'd8,
					COUNT			= 4'd9,
					ERASE			= 4'd10,
					UPDATE		= 4'd11,
					GAME_OVER_DRAW_PLAYER = 4'd12,
					GAME_OVER_COUNT = 4'd13,
					GAME_OVER_ERASE = 4'd14,
					GAME_OVER_UPDATE = 4'd15;
					
    always@(*)
    begin: state_table
			case (current_state)
				IDLE: next_state = start ? IDLE_WAIT : IDLE;
				IDLE_WAIT: next_state = start ? IDLE_WAIT : DRAW_LINE_0;
				DRAW_LINE_0: next_state = l_overflow ? DRAW_LINE_1 : DRAW_LINE_0;
				DRAW_LINE_1: next_state = l_overflow ? DRAW_LINE_2 : DRAW_LINE_1;
				DRAW_LINE_2: next_state = l_overflow ? DRAW_LINE_3 : DRAW_LINE_2;
				DRAW_LINE_3: next_state = l_overflow ? DRAW_LINE_4 : DRAW_LINE_3;
				DRAW_LINE_4: next_state = l_overflow ? DRAW_LINE_5 : DRAW_LINE_4;
				DRAW_LINE_5: begin
					if (l_overflow) begin
						if (collision) 
							next_state = GAME_OVER_DRAW_PLAYER;
						else
							next_state = DRAW_PLAYER;
						end
					else 
						next_state = DRAW_LINE_5;
				end
				DRAW_PLAYER: next_state = c_overflow ? COUNT : DRAW_PLAYER;
				COUNT: next_state = f_overflow ? ERASE : COUNT;
				ERASE: next_state = e_overflow ? UPDATE : ERASE;
				UPDATE: next_state = DRAW_LINE_0;
				GAME_OVER_DRAW_PLAYER: next_state = c_overflow ? GAME_OVER_COUNT : GAME_OVER_DRAW_PLAYER;
				GAME_OVER_COUNT: next_state = g_overflow ? GAME_OVER_ERASE : GAME_OVER_COUNT;
				GAME_OVER_ERASE: next_state = e_overflow ? GAME_OVER_UPDATE : GAME_OVER_ERASE;
				GAME_OVER_UPDATE: next_state = DRAW_LINE_0;
            default:     next_state = IDLE;
        endcase
    end
	 
    always @(*)
    begin: enable_signals
		  reset_next_cycle = 1'b1;
		  reset_all = 1'b1;
		  WriteEn = 1'b0;
		  frame_enable = 1'b0;
		  update_enable = 1'b0;
		  erase_enable = 1'b0;
		  draw_enable = 1'b0;
		  game_over_count_enable = 1'b0;
		  collision_check_en = 1'b0;
		  coord_select = 3'd0;
		  colour_select = 2'd0;
		  time_enable = 1'd1;
		  
        case (current_state)
				IDLE: begin
					reset_next_cycle = 1'b0;
					reset_all = 1'b0;
					time_enable = 1'd0;
					end
            DRAW_LINE_0: begin
					 WriteEn = 1'b1;
					 draw_enable = 1'b1;
					 coord_select = 3'd0;
					 collision_check_en = 1'b1;
                end
				DRAW_LINE_1: begin
					WriteEn = 1'b1;
					draw_enable = 1'b1;
					coord_select = 3'd1;
					collision_check_en = 1'b1;
					end
				DRAW_LINE_2: begin
					WriteEn = 1'b1;
					draw_enable = 1'b1;
					coord_select = 3'd2;
					collision_check_en = 1'b1;
					end
				DRAW_LINE_3: begin
					WriteEn = 1'b1;
					draw_enable = 1'b1;
					coord_select = 3'd3;
					collision_check_en = 1'b1;
					end
				DRAW_LINE_4: begin
					WriteEn = 1'b1;
					draw_enable = 1'b1;
					coord_select = 3'd4;
					collision_check_en = 1'b1;
					end
				DRAW_LINE_5: begin
					WriteEn = 1'b1;
					draw_enable = 1'b1;
					coord_select = 3'd5;
					collision_check_en = 1'b1;
					end
				DRAW_PLAYER: begin
					WriteEn = 1'b1;
					draw_enable = 1'b1;
					coord_select = 3'd6;
					end
            COUNT: begin
                frame_enable = 1'b1;
                end
				ERASE: begin
					erase_enable = 1'b1;
					colour_select = 1'd1;
					WriteEn = 1'b1;
					coord_select = 3'd7;
					end
				UPDATE: begin
					update_enable = 1'b1;
					reset_next_cycle = 1'b0;
					end
				GAME_OVER_DRAW_PLAYER: begin
					WriteEn = 1'b1;
					draw_enable = 1'b1;
					coord_select = 3'd6;
					colour_select = 2'd2;
					time_enable = 1'd0;
					end
				GAME_OVER_COUNT: begin
					game_over_count_enable = 1'b1;
					time_enable = 1'd0;
					end
				GAME_OVER_ERASE: begin
					erase_enable = 1'b1;
					colour_select = 1'd1;
					WriteEn = 1'b1;
					coord_select = 3'd7;
					time_enable = 1'd0;
					end
				GAME_OVER_UPDATE: begin
					reset_next_cycle = 1'b0;
					reset_all = 1'b0;
					end
        endcase
    end 
   
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end 

endmodule

module CubeMover (
		input clk, resetn, enable,
		input up, left, down, right,
		input speed,
		output reg [7:0] x_start,
		output reg [6:0] y_start);
	
	always@(posedge clk)
	begin
		if(!resetn)
		begin
			x_start <= 8'd0;
			y_start <= 7'd60;
		end
		else if (enable) begin
			if (speed) begin
				if (up)
					y_start <= y_start - 7'd2;
				else if (down)
					y_start <= y_start + 7'd2;
				if (left)
					x_start <= x_start - 8'd2;
				else if (right)
					x_start <= x_start + 8'd2;
				end
			else begin
				if (up)
					y_start <= y_start - 7'd1;
				else if (down)
					y_start <= y_start + 7'd1;
				if (left)
					x_start <= x_start - 8'd1;
				else if (right)
					x_start <= x_start + 8'd1;
				end
			end
	end
endmodule

module CollisionChecker (
		input clk,
		input resetn,
		input enable,
		input [7:0] current_x,
		input [6:0] current_y,
		input [7:0] player_x,
		input [6:0] player_y,
		output reg collision
	);
	
	always@(posedge clk, negedge resetn) begin
		if (!resetn)
			collision <= 1'b0;
		else if (enable && (current_x >= player_x && current_x <= (player_x + 8'd3)) && (current_y >= player_y && current_y <= (player_y + 7'd3)))
			collision <= 1'b1;
		else if (player_x < 8'd0 || player_x > 8'd156 || player_y < 7'd0 || player_y > 7'd116)
			collision <= 1'b1;
	end

endmodule

module RandNumGen (
		input clk,
		input resetn,
		input enable,
		output reg [6:0] line_gap
	);
	
	reg [15:0] shift_reg;
	 
	wire next_bit;
	assign next_bit = ((shift_reg[0] ^ shift_reg[2]) ^ shift_reg[3]) ^ shift_reg[5];

	always @(posedge clk)
	begin
	if (!resetn)
		shift_reg = 16'b1010110011100001;
	else if (enable) begin
		shift_reg <= shift_reg >> 1;
		shift_reg[15] <= next_bit;
		end
	end

	always@(posedge clk)
	begin
	if (shift_reg[6:0] <= 7'd102)
		line_gap <= shift_reg[6:0];
	else
		line_gap <= shift_reg[6:0] - 7'd50;
	end
	

endmodule

module LineDrawer (
		input clk,
		input resetn,
		input enable,
		input [6:0] line_gap,
		output reg [6:0] l_count,
		output l_overflow
		);
		
		always @(posedge clk, negedge resetn)
		begin
			if (!resetn)
				l_count <= 7'd0;
			else if (enable) begin
				if (l_count >= (line_gap - 7'd2) && l_count <= (line_gap + 7'd2))
					l_count <= l_count + 7'd20;
				else
					l_count <= l_count + 7'd4;
				end
			else if (l_overflow)
				l_count <= 7'd0;
		end
		
		assign l_overflow = (l_count >= 7'd120) ? 1'b1 : 1'b0;
		
endmodule

module Eraser (
		input clk,
		input resetn,
		input enable,
		output reg [7:0] erase_x,
		output reg [6:0] erase_y,
		output e_overflow
	);
	
	always@(posedge clk, negedge resetn)
	begin
		if(!resetn) begin
			erase_x <= 1'b0;
			erase_y <= 1'b0;
			end
		else if (enable) begin
			if (erase_y == 7'd119) begin
				erase_y <= 1'b0;
				erase_x <= erase_x + 1'b1;
				end
			else
				erase_y <= erase_y + 1'b1;
			end
		else begin
			erase_x <= 1'b0;
			erase_y <= 1'b0;
			end
	end
	
	assign e_overflow = (erase_x == 8'd160) ? 1'b1 : 1'b0;

endmodule


module CubeDrawer (
		input clk,
		input resetn,
		input enable,
		input stop,
		output reg [3:0] c_count,
		output c_overflow
		);

	always@(posedge clk, negedge resetn)
	begin
	  if(!resetn)
			c_count <= 4'b0000;
	  else if (enable == 1'b1) begin
			if (!stop)
				c_count <= c_count + 4'b0001;
			end
	end
	 
	assign c_overflow = (c_count == 4'b1111) ? 1'b1 : 1'b0;
	 
endmodule

module XCounter (
		input clk,
		input resetn,
		input enable,
		input [6:0] starting_gap,
		input [6:0] random_gap,
		input [7:0] original_x,
		output reg [6:0] line_gap,
		output reg [7:0] x
		);
		
	always @(posedge clk)
	begin
		if (!resetn) begin
			line_gap <= starting_gap;
			x <= original_x;
			end
		else if (enable)
			if (x == 0) begin
				line_gap <= random_gap;
				x <= 8'd235;
				end
			else
				x <= x - 1'b1;
	end
		
endmodule

module FrameCounter (
		input clk,
		input resetn,
		input enable,
		input [19:0] start_count,
		output f_overflow
		);
		
	wire count;
	wire d_overflow;
	DelayCounter d0 (clk, resetn, enable, start_count, d_overflow);
		
	reg [3:0] q;

	always @(posedge clk)
	begin
		if (!resetn)
			q <= 4'b1111;
		else if (d_overflow)
			if (q == 0)
				q <= 4'b1111;
			else
				q <= q - 4'b0001;
	end
	
	assign f_overflow = (q == 4'd0) ? 1'b1 : 1'b0;

endmodule

module DelayCounter (
		input clk,
		input resetn,
		input enable,
		input [19:0] start_count,
		output d_overflow
		);
		
		reg [19:0] q; 

	always @(posedge clk)
	begin
		if (!resetn)
			q <= start_count;
			//q <= 20'd2;
		else if (enable)
			if (q == 0)
				q <= start_count;
				//q <= 20'd2;
			else
				q <= q - 1'b1;
	end
	
	assign d_overflow = (q == 20'd0) ? 1'b1 : 1'b0;
		
endmodule

module GameOverCounter (
		input clk,
		input resetn,
		input enable,
		output g_overflow
		);
		
	reg [26:0] q;
	
	always @(posedge clk)
	begin
		if (!resetn)
			q <= 27'd100000000;
		else if (enable)
			q <= q - 27'd1;
	end
	
	assign g_overflow = (q == 27'd0) ? 1'b1 : 1'b0;
	
endmodule

module SecondCounter (
		input clk,
		input resetn,
		input enable,
		output t_overflow
		);
		
	reg [26:0] q;
	
	always @(posedge clk)
	begin
		if (!resetn)
			q <= 27'd50000000;
			//q <= 27'd500;
		else if (enable)
			q <= q - 27'd1;
	end
	
	assign t_overflow = (q == 27'd0) ? 1'b1 : 1'b0;
	
endmodule

module timer (clk, resetn, enable, start_count, HEX0, HEX1, HEX2);
		input clk, resetn, enable;
		output reg [19:0] start_count;
		output [6:0] HEX0, HEX1, HEX2;
	
	reg [3:0] time_reg_0, time_reg_1, time_reg_2;
	wire reg_0_overflow, reg_1_overflow;
	
	hex_decoder h0(time_reg_0, HEX0);
	hex_decoder h1(time_reg_1, HEX1);
	hex_decoder h2(time_reg_2, HEX2);
	
	always@(posedge clk)
	begin
		if (!resetn)
			start_count <= 20'd400000;
		else
			if (enable)
				start_count <= start_count - 20'd10000;
	end
	
	always@(posedge clk, negedge resetn)
	begin
		if (!resetn)
			time_reg_0 <= 4'd0;
		else if (enable) begin
			if (time_reg_0 == 4'd9)
				time_reg_0 <= 4'd0;
			else
				time_reg_0 <= time_reg_0 + 4'd1;
			end
	end
	
	assign reg_0_overflow = (time_reg_0 == 4'd9) ? 1'b1 : 1'b0;
	
	
	always@(posedge clk, negedge resetn)
	begin
		if (!resetn)
			time_reg_1 <= 4'd0;
		else if (enable && reg_0_overflow) begin
			if (time_reg_1 == 4'd9)
				time_reg_1 <= 4'd0;
			else
				time_reg_1 <= time_reg_1 + 4'd1;
			end
	end
	
	assign reg_1_overflow = (time_reg_1 == 4'd9) ? 1'b1 : 1'b0;
	
	always@(posedge clk, negedge resetn)
	begin
		if (!resetn)
			time_reg_2 <= 4'd0;
		else if (enable && reg_1_overflow && reg_0_overflow) begin
			if (time_reg_2 == 4'd9)
				time_reg_2 <= 4'd0;
			else
				time_reg_2 <= time_reg_2 + 4'd1;
			end
	end
	
endmodule

module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            /*4'd0: segments = 7'b100_0000;//load number0.mif
            4'd1: segments = 7'b111_1001;
            4'd2: segments = 7'b010_0100;
            4'd3: segments = 7'b011_0000;
            4'd4: segments = 7'b001_1001;
            4'd5: segments = 7'b001_0010;
            4'd6: segments = 7'b000_0010;
            4'd7: segments = 7'b111_1000;
            4'd8: segments = 7'b000_0000;
            4'd9: segments = 7'b001_1000;  
            default: segments = 7'b100_0000;*/
				4'd0: load "number0.mif";
            4'd1: load "number1.mif";
            4'd2: load "number2.mif";
            4'd3: load "number3.mif";
            4'd4: load "number4.mif";
            4'd5: load "number5.mif";
            4'd6: load "number6.mif";
            4'd7: load "number7.mif";
            4'd8: load "number8.mif";
            4'd9: load "number9.mif";  
            default: load "number0.mif";
        endcase
		  
endmodule