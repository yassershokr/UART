// Engineer: Yasser Mohamed
// Create Date: 21/9/2023 
// Module Name: Baud Rate Generator
// Project Name: UART
module baud_rate_generator
				#(parameter bits = 8)
				(
				input clk,reset_n,
				input [9:0] final_value,
				output reg done
				);
				
				reg [bits-1:0] Q;
				
				always @ (posedge clk , negedge reset_n)
				begin
					if (~reset_n)
						Q <= 'b0;
					
					else
					begin
						if ( Q == final_value)
						begin
							done <= 1'b1;
							Q <= 'b0;
						end
						else 
						begin
							done <= 1'b0;
							Q <= Q+1;
						end
					end
				end
endmodule 					
					
