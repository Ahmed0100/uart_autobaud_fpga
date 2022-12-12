`timescale 1ns / 1ps

module disp_hex_mux
	#(parameter N=18) //last 2 bits will be used as output. Frequency=50MHz/(2^(N-2)). So N=19 will have 763Hz
(
	input clk,reset_n,
	input[5:0] in_0,in_1,in_2,in_3, //format: {dp,char[4:0]} , dp is active high
	output reg[7:0] sseg,
	output reg[3:0] sel
 );
	 
	 reg[N-1:0] r_reg=0;
	 reg[5:0] hex_out=0;
	 wire[N-1:0] r_nxt;
	 wire[1:0] out_counter; //last 3 bits to be used as output signal
	 
	 
	 //N-bit counter
	 always @(posedge clk,negedge reset_n)
		if(!reset_n) 
			r_reg<=0;
		else 
			r_reg<=r_nxt;
	 
	 assign r_nxt=(r_reg=={2'd3,{(N-2){1'b1}}})?18'd0:r_reg+1'b1; //last 2 bits counts from 0 to 5(6 turns) then wraps around
	 assign out_counter=r_reg[N-1:N-2];
	 
	 
	 //sel output logic
	 always @(out_counter) begin
		 sel=6'b111_111;    //active low
		 sel[out_counter]=1'b0;
	 end

	 //hex_out output logic
	 always @* begin
		 hex_out=0;
			 casez(out_counter)
			 3'b000: hex_out=in_0;
			 3'b001: hex_out=in_1;
			 3'b010: hex_out=in_2;
			 3'b011: hex_out=in_3;
			 endcase
	 end
	 	 
	 //hex-to-seg decoder
	 always @* begin
		 sseg=0;
			 case(hex_out[4:0])
			 5'd0: sseg[6:0]=7'b0000_001;
			 5'd1: sseg[6:0]=7'b1001_111;
			 5'd2: sseg[6:0]=7'b0010_010;
			 5'd3: sseg[6:0]=7'b0000_110;
			 5'd4: sseg[6:0]=7'b1001_100;
			 5'd5: sseg[6:0]=7'b0100_100;
			 5'd6: sseg[6:0]=7'b0100_000;
			 5'd7: sseg[6:0]=7'b0001_111;
			 5'd8: sseg[6:0]=7'b0000_000;
			 5'd9: sseg[6:0]=7'b0001_100;
	  /*A*/5'd10: sseg[6:0]=7'b0001_000; 
	  /*b*/5'd11: sseg[6:0]=7'b1100_000;
	  /*C*/5'd12: sseg[6:0]=7'b0110_001;
	  /*d*/5'd13: sseg[6:0]=7'b1000_010;
	  /*E*/5'd14: sseg[6:0]=7'b0110_000;
	  /*F*/5'd15: sseg[6:0]=7'b0111_000;
	  /*G*/5'd16: sseg[6:0]=7'b0100_000;
	  /*H*/5'd17: sseg[6:0]=7'b1001_000;
	  /*I*/5'd18: sseg[6:0]=7'b1111_001;
	  /*J*/5'd19: sseg[6:0]=7'b1000_011;
	  /*L*/5'd20: sseg[6:0]=7'b1110_001;
	  /*N*/5'd21: sseg[6:0]=7'b0001_001;
	  /*O*/5'd22: sseg[6:0]=7'b0000_001;
	  /*P*/5'd23: sseg[6:0]=7'b0011_000; 
	  /*R*/5'd24: sseg[6:0]=7'b0001_000;
	  /*S*/5'd25: sseg[6:0]=7'b0100_100;
	  /*U*/5'd26: sseg[6:0]=7'b1000_001;
	  /*y*/5'd27: sseg[6:0]=7'b1000_100;
	  /*Z*/5'd28: sseg[6:0]=7'b0010_010; 
	/*OFF*/5'd29: sseg[6:0]=7'b1111_111; //decimal 30 to 31 will be alloted for future use
	  /*Z*/5'd30: sseg[6:0]=7'b1111_110; 

			 endcase
		 sseg[7]=!hex_out[5]; //active high decimal
	 end

endmodule