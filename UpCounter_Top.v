module UpCounter_Top(KEY, SW, clk_50M, Seg7, decimalPoint, reset);
	input [1:0] KEY;		// Button 1 and 0
	input reset;			// Switch 8 = Reset
	input SW;				// Switch 9 = Enable
	input clk_50M;			// 50Mhz Clock
	output [27:0] Seg7;	// 28 output to 4 7-segment displays
	output decimalPoint; // decimal point on Segment #4 will always be on
	
	assign decimalPoint = 0;
	
	wire clk_1k;
	wire [15:0] Q;		
	wire [15:0] Display;
	assign Display = Q;
	
	counter C0(	
		.enable(SW), .Q(Q[3:0]), .reset(reset), .clock(KEY[0])
	);	
	
	counter C1(	
		.enable(SW), .Q(Q[7:4]), .reset(reset), .clock(KEY[0])
	);	
	
	counter C2(	
		.enable(SW), .Q(Q[11:8]), .reset(reset), .clock(KEY[0])
	);	
	
	counter C3(	
		.enable(SW), .Q(Q[15:12]), .reset(reset), .clock(KEY[0])
	);	
	
	decoder D0(
		.DIG(Display[3:0]), .Seg7(Seg7[6:0])
	);
	
	decoder D1(
		.DIG(Display[7:4]), .Seg7(Seg7[13:7])
	);	
	
	decoder D2(
		.DIG(Display[11:8]), .Seg7(Seg7[20:14])
	);
		
	decoder D3(
		.DIG(Display[15:12]), .Seg7(Seg7[27:21])
	);
	
	clock_divider U0(clk_50M, clk_1k);

endmodule
