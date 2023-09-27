// Engineer: Yasser Mohamed
// Create Date: 21/9/2023 
// Module Name: FIFO
// Project Name: UART

module fifo
	    #(parameter bits = 8,
	      parameter depth = 8
	      )
	     (
	    input clk,reset_n,
	    input [bits-1:0] data_in,
	    input write_enable,read_enable,
	    output reg full,empty,
	    output reg [bits-1:0] data_out
					);
	reg [bits-1:0] FIFO [depth-1:0];
	reg [2:0] write_ptr,read_ptr;
	reg [3:0] count;			
		always @ (count)
		begin
			empty <= (count == 0);
			full <= (count == depth);
		end
				
		always @ (posedge clk,negedge reset_n) 
		begin
			if (~reset_n)
				count <= 0;
			else if (!empty && read_enable)
				count <= count - 1;
			else if (!full && write_enable)
				count <= count + 1;
			else
				count <= count;
		end
				
		always @ (posedge clk,negedge reset_n)     //read
				begin
					if (~reset_n)
						data_out <= 8'b0;
					else
					begin
						if (!empty && read_enable)
							data_out <= FIFO[read_ptr];
						else
							data_out <= data_out;
					end
				end
				
				always @ (posedge clk)   //(write) 
				begin
					if (!full && write_enable)
						FIFO[write_ptr] <= data_in ;
					else
						FIFO[write_ptr] <= FIFO[write_ptr];
				end
				
				always @ (posedge clk ,negedge reset_n)        //pointers
				begin
					if (~reset_n)
					begin
						write_ptr <= 0;
						read_ptr <= 0;
					end
					else
				   begin	
						if (!full && write_enable)
							write_ptr <= write_ptr + 1;
						else
							write_ptr <= write_ptr;
							
						if (!empty && read_enable)
							read_ptr <= read_ptr + 1;
						else
							read_ptr <= read_ptr;
					end
				end	
endmodule
