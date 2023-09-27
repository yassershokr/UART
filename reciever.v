// Engineer: Yasser Mohamed
// Create Date: 21/9/2023 
// Module Name: Reciever
// Project Name: UART

module Reciever
			 #(parameter DataBits = 8,stop_bit_Ticks = 16)
			(
			 input clk,reset_n,
			 input s_tick,
			 input rx,
			 output reg rx_done_tick,                         
			 output [DataBits-1:0] rx_dout
			 );
						 
						 // registers for the present state and next state
						 
						 reg [1:0] next_state, present_state;
						 
						 reg [3:0]s_next, s_present;
						 
						 reg [$clog2(DataBits) - 1:0] n_next, n_present;              
						 
						 reg [DataBits - 1:0] b_next, b_present;                   

						 //states
						 
						 localparam idle = 0, start = 1, recieve = 2, stop = 3;
 
						 //present state
						 
						 always @ (posedge clk,negedge reset_n)
						 begin
							
							if (~reset_n)
							begin
								
								present_state <= idle;
								s_present <= 0;
								n_present <= 0;
								b_present <= 0;
								
								
							end
							
							else
							begin
							
								present_state <= next_state;
								s_present <= s_next;
								n_present <= n_next;
								b_present <= b_next;
								
							end
							
						end
						
						
						//next state
						
						always @ (*)
						begin
						
							next_state = present_state;
							b_next = b_present;
							s_next = s_present;
							n_next = n_present;
							rx_done_tick = 1'b0;
							
							case (present_state)
								
								idle:                                      // First state in which the transmitter prepared to transmit the data
								begin
									if (~rx)
									begin
								
										s_next = 0;
										next_state = start;
										
									end
									else
										
										next_state = idle;
								end
								
								start:                                      // Second state in which start transmitting the data
								begin
									if (s_tick)
									begin
										if (s_present == 7)
										begin
											s_next = 0;
											n_next = 0;
											next_state = recieve;
											
										end
										else
										begin
											s_next = s_next + 1;
											next_state = start;
										end
									end
								end
								
								recieve:                                              // Third state in which reciving the data process is happened
								begin
									if (s_tick)
									begin
										if (s_present == 15)
										begin
											s_next = 0;
											b_next = {rx, b_present[(DataBits - 1):1]};
											if(n_present == (DataBits - 1))
												next_state = stop;
											else
												n_next = n_present + 1;
										end
										else
										begin
											s_next = s_next + 1;
											next_state = recieve;
										end
									end
								end
			 
								stop:                                                               // Fourth state in which stop transmitting the data
								begin
									if (s_tick)
									begin
										if (s_present == (stop_bit_Ticks-1))
										begin
											
											rx_done_tick = 1'b1;
											next_state = idle;
										
										end
										else
										begin
											s_next = s_present + 1;
											next_state = stop;
										end
									end
								end
								
								default:
									next_state = idle;
									
							endcase
						
						end
							
					//output 
					
					
					assign rx_dout = b_present;
endmodule
