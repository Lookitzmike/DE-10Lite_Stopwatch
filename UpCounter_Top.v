module UpCounter_Top(KEY, SW, clk_50M, Seg7, decimalPoint, reset, timerSW, LEDR);
	input [1:0] KEY;		// Button 1 and 0; 0 Start 1 Stop
	input reset;			// Switch 8 = Reset
	input SW;				// Switch 9 = Enable
	input timerSW;			// SWitch 0 = Enable Timer
	input clk_50M;			// 50Mhz Clock
	input LEDR;				// Start LED indicator, set led 4
	output [27:0] Seg7;	// 28 output to 4 7-segment displays
	output decimalPoint; // Decimal point on Segment #4 will always be on
	
	assign decimalPoint = 0;		// Set decimal point = 0 = Light on
	
	wire clock_1kHz, clock_10Hz, start;	
	wire [15:0] BCD_count;
	wire [15:0] Q;						// Counter bit output 
	wire [15:0] Display;				// Output decoder bit to display
	wire [6:0] stop;
	assign Display = Q;				// Display bit = counter
	
	// Instantiate Counter modules (4 counters for each decoder)	
	counter C0(																		// *Change Q to BCD_count for timer count rather than manual
		.enable(SW), .Q(Q[3:0]), .reset(reset), .clock(KEY[0]));		// Send Q bit to decoder 
	
	counter C1(	
		.enable(SW), .Q(Q[7:4]), .reset(reset), .clock(KEY[0]));	
	
	counter C2(	
		.enable(SW), .Q(Q[11:8]), .reset(reset), .clock(KEY[0]));	
	
	counter C3(	
		.enable(SW), .Q(Q[15:12]), .reset(reset), .clock(KEY[0]));	
	
	// Instantiate decoder modules (4 Displays)
	decoder D0(
		.DIG(Display[3:0]), .Seg7(Seg7[6:0]));								// Receive Q bit send to Display output to Seg7 
	
	decoder D1(
		.DIG(Display[7:4]), .Seg7(Seg7[13:7]));	
	
	decoder D2(
		.DIG(Display[11:8]), .Seg7(Seg7[20:14]));
		
	decoder D3(
		.DIG(Display[15:12]), .Seg7(Seg7[27:21]));
	
	// Instantiate 1kHz and 10Hz clock divider modules with a 32-bit counter size
	clock_divider #(32) clk_1k(.clk_In(clk_50M), .divide_by(24999), .reset(0), .clk_Out(clock_1kHz));		//50MHz/(2*1kHz)-1 = 24,999
	clock_divider #(32) clk_10(.clk_In(clk_50M), .divide_by(2499999), .reset(0), .clk_Out(clock_10Hz));	//50MHz/(2*10Hz)-1 = 2,499,999
	shiftRegister Shift(.clk_In(clock_1kHz), .enable(KEY[1]), .shift(stop));	// Using 1kHz clock, control using KEY1, function = stop
	
	up_timer #(32) T1(.clock(clock_10Hz), .en(timerSW), .stop(stop), .reset(reset), .start(start));		
	// BCD counter module 
	n_bit_counter #(4) BCD_0(.clk(clock_1kHz), .enable(SW), .max_count(0) , .reset(reset), .count(BCD_count));	// *Fix max_count rework counter and display						
	
endmodule
