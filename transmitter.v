// Engineer: Yasser Mohamed
// Create Date: 21/9/2023 
// Module Name: Transmitter
// Project Name: UART

module Transmitter
			 #(parameter DataBits = 8,stop_bit_Ticks = 16)
			(
			 input clk,reset_n,
			 input s_tick,
			 input tx_start,
			 input [DataBits-1:0] tx_din,
			 output tx,
			 output reg tx_done_tick                         
			 );
						 
						 // registers for the present state and next state
						 
						 reg [1:0] next_state, present_state;
						 
						 reg [3:0]s_next, s_present;
						 
						 reg [$clog2(DataBits)-1:0] n_next, n_present;              
						 
						 reg [(DataBits)-1:0] b_next, b_present; 

						 reg  tx_present,tx_next;                 

						 //states
						 
						 localparam idle = 0, start = 1, trans = 2, stop = 3;
 
						 //present state
						 
						 always @ (posedge clk,negedge reset_n)
						 begin
							
							if (~reset_n)
							begin
								
								present_state <= idle;
								s_present <= 0;
								n_present <= 0;
								b_present <= 0;
								tx_present <= 1'b1;
								
							end
							
							else
							begin
							
								present_state <= next_state;
								s_present <= s_next;
								n_present <= n_next;
								b_present <= b_next;
								tx_present <= tx_next;
							end
							
						end
						
						
						//next state
						
						always @ (*)
						begin
						
							next_state = present_state;
							b_next = b_present;
							s_next = s_present;
							n_next = n_present;
							tx_done_tick = 1'b0;
							
							case (present_state)
								
								idle:                                      // First state in which the transmitter prepared to transmit the data
								begin
									tx_next<=1'b1;
									if (tx_start)
									begin
								
										s_next = 0;
										b_next = tx_din;
										next_state = start;
										
									end
									else
										
										next_state = idle;
								end
								
								start:                                      // Second state in which start transmitting the data
								begin
									tx_next<=1'b0;
									if (s_tick)
									begin
										if (s_present == 15)
										begin
											s_next = 0;
											n_next = 0;
											next_state = trans;
											
										end
										else
										begin
											s_next = s_next + 1;
											next_state = start;
										end
									end
								end
								
								trans:                                              // Third state in which transimtting the data process is happened
								begin
									tx_next<=b_present[0];
									if (s_tick)
									begin
										if (s_present == 15)
										begin
											s_next = 0;
											b_next = {1'b0, b_present[(DataBits - 1):1]};
											next_state = trans;
											if(n_present == (DataBits - 1))
												next_state = stop;
											else
												n_next = n_present + 1;
										end
										else
										begin
											s_next = s_next + 1;
											next_state = start;
										end
									end
								end
			 
								stop:                                                               // Fourth state in which stop transmitting the data
								begin
									tx_next<=1'b1;
									if (s_tick)
									begin
										if (s_present == (stop_bit_Ticks-1))
										begin
											
											tx_done_tick = 1'b1;
											next_state = idle;
										
										end
										else
										begin
											s_next = s_present + 1;
											next_state = trans;
										end
									end
								end
								
								default:
									next_state = idle;
									
							endcase
						
						end
							
					//output 
					
					
					assign tx = b_present;
endmodule
