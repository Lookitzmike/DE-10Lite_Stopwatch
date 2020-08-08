module clock_divider(clk_50M,clk_1k);
	input clk_50M;					// 50Mhz
	output reg clk_1k;			// 1khz

	reg [14:0]count;
	
	always@(posedge clk_50M) begin
		count <= count + 1'b1;
		
		if (count == 25000) begin
				clk_1k <= clk_1k ^ 1'b1;
				count <= 1'b0;
		end
			//Alternate the output clock
			//every 25000 cycles.
	end
endmodule 