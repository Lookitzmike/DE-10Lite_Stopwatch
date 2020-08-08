module comparator(count, compare_count, enable); //if value is reached, enable pulse goes high for one clock cycle
	input[N-1:0] count;				// Slow Counter
	input[N-1:0] compare_count;
	output reg enable;
	
	parameter N = 64;					// N for 64 bit
	
	always@(count) begin
		if(compare_count == count) // Compares count if count == compared count then enable = 1 
			enable = 1'b1;
		else
			enable = 1'b0;
	end
	
endmodule

module d_flip_flop(clk, reset, enable, Q, D);
	input D, clk, reset, enable;
	output reg Q;
	
	always@(negedge(clk), posedge(reset)) begin
		if(reset) begin
			Q = 1'b0; 
		end
		else if(enable) begin
			Q <= D; 					// Store value of D when at start
		end
	end
	
endmodule

module n_bit_counter (clk, enable, max_count, reset, count);
	input clk, enable, reset;
	input [N-1:0] max_count;
	output reg [N-1:0] count;
	
	parameter N = 64; 
	
	always@(posedge clk, posedge reset) begin
		if(reset) begin
			count <= 0;    
		end
		else if(count < max_count) begin
			if(enable)
				count <= count + 1; 
		end
		else begin
			count <= 0;        // If count is greater than or equal to max_count, reset to 0
		end	
	end
	
endmodule

module clock_divider(clk_In, divide_by, reset, clk_Out);
	input clk_In;
	input[N-1:0] divide_by;
	input reset;
	output clk_Out;
	parameter N = 64;

	wire[N-1:0] current_count;
	wire flipFlop_En;
	
	// Counter module to count input clock pulses 
	n_bit_counter #(N) COUNT32_DIV(clk_In, 1, divide_by, reset, current_count);
	
	// Comparator to check for flip value
	comparator #(N) COMPARE32_DIV(current_count, divide_by, flipFlop_En);
	
	// D flip flop with inverted feedback from output to toggle the previous state
	d_flip_flop DFF(~clk_Out, clk_In, reset, flipFlop_En, clk_Out);
	
endmodule
	
module up_timer(clock, en, stop, reset, start); // 1Khz clock
	input clock;
	input en;
	input[N-1:0] stop;
	input reset;
	output start;
	
	parameter N = 64;	// 64 bit 
	wire[N-1:0] current_count; 
	
	// Counter to count to stop value
	n_bit_counter #(N) timer32(.clk(clock), .enable(en), .max_count(stop), .reset(reset), .count(current_count));
	
	// Send signal when stop value is reached
	comparator #(N) compare32Timer(.count(current_count), .compare_count(stop), .enable(start));
	
endmodule
	
module shiftRegister(clk_In, enable, shift);
	input clk_In;
	input enable;
	output reg [6:0]shift;
	
	always@(posedge clk_In) begin
			if (enable) begin
			if (shift == 7'b0)					// If shift = 0 stop
				shift <=  7'b0011001;   		// Eliminates posibility that output will be 0
			else begin                       // Shift bits one to left and put XOR of MSB into LSB location
				shift[6] <= shift[5];
				shift[5] <= shift[4];
				shift[4] <= shift[3];
				shift[3] <= shift[2];
				shift[2] <= shift[1];
				shift[1] <= shift[0];
				shift[0] <= shift[6]^shift[5];
			end
		end
	end
	
endmodule 

