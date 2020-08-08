module counter(clock, enable, reset, Q, Q_out);
	input clock, enable, reset;
	output reg Q_out;				// send bit to Hex1 (7seg1)
	output reg[3:0] Q; 			// output reg for Hex0 (7seg 0)

	always @( posedge clock) begin
		if(reset)
			Q  <= 4'b0;  
		else		
			if (enable == 1) begin
				if (Q == 4'b1001) begin
					Q <= 1'b0000;	// Reset to 0 restart count so it doesn't go to Hex A
					Q_out <= 1'b1;
				end
				else
					Q <= Q + 1'b1;	// If Q is not 9 increment 1 bit
			end
			else
				Q = Q;				// if enable = 0 hold the current number to display
	end
	
endmodule
