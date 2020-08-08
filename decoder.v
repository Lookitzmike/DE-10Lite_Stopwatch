module decoder(DIG,Seg7);	

	input [3:0] DIG;
	output reg [6:0] Seg7;
	
	always@(DIG) begin
		case(DIG)
			4'b0000 : Seg7[6:0] = 7'b1000000; // 0
			4'b0001 : Seg7[6:0] = 7'b1111001; // 1
			4'b0010 : Seg7[6:0] = 7'b0100100; // 2
			4'b0011 : Seg7[6:0] = 7'b0110000; // 3
			4'b0100 : Seg7[6:0] = 7'b0011001; // 4
			4'b0101 : Seg7[6:0] = 7'b0010010; // 5
			4'b0110 : Seg7[6:0] = 7'b0000010; // 6
			4'b0111 : Seg7[6:0] = 7'b1111000; // 7
			4'b1000 : Seg7[6:0] = 7'b0000000; // 8
			4'b1001 : Seg7[6:0] = 7'b0010000; // 9
			default : Seg7[6:0] = 7'b1000000; // 0
		endcase	
	end
endmodule 