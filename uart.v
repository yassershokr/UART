// Engineer: Yasser Mohamed
// Create Date: 21/9/2023 
// Module Name: UART
// Project Name: UART

module UART 
				#(parameter DataBits = 8,ClkTicks = 16)
				(
				input clk,reset_n,
				input read_uart,write_uart,rx,
				input [DataBits-1:0] w_data,
				input [9:0]Final_Value,
				output [DataBits-1:0] r_data,
				output tx,
				output rx_empty,tx_full,rx_full
				);
				wire [DataBits-1:0]din,dout;
				wire rx_done_tick,tx_done_tick;
				wire tx_start;
				wire s_tick;
				// instantiation
				
				// Timer
				
				baud_rate_generator #(.bits(DataBits)) Stage0
				(
				.clk(clk),
				.reset_n(reset_n),
				.final_value(Final_Value[9:0]),             
				.done(s_tick)                               
				);   
				
				// FIFO for transmitter
				
				fifo #(.bits(DataBits), .depth(8)) Stage1
				(
				.clk(clk),
				.reset_n(reset_n),
			        .write_enable(write_uart),                                     
				.read_enable(tx_done_tick),                                       
				.data_in(w_data[DataBits-1:0]),                                        
				.data_out(dout[DataBits-1:0]),                                
				.empty(tx_start),                                           
				.full(tx_full)                                             
				);
				
				// Transmitter
				Transmitter #(.DataBits(DataBits), .stop_bit_Ticks(ClkTicks)) Stage2
				(
				.clk(clk),
				.reset_n(reset_n),
				.tx_start(~tx_start),
			        .s_tick(s_tick),                                          
				.tx(tx),                                         
				.tx_done_tick(tx_done_tick),                               
				.tx_din(dout[DataBits-1:0])                                   
				);
				
				
				// Reciever
				
				Reciever #(.DataBits(DataBits), .stop_bit_Ticks(ClkTicks))  Stage3
				(
				.clk(clk),
				.reset_n(reset_n),
				.s_tick(s_tick),																		
				.rx(rx),
				.rx_done_tick(rx_done_tick),
           		        .rx_dout(din[DataBits-1:0])
				);
				
				
				// FIFO for reciever
				
				fifo #(.bits(DataBits), .depth(8)) Stage4
				(
				.clk(clk),
				.reset_n(reset_n),
			        .write_enable(rx_done_tick),                                     
				.read_enable(read_uart),                                       
				.data_in(din[DataBits-1:0]),                                        
				.data_out(r_data),                                
				.empty(rx_empty),                                           
				.full(rx_full)                                             
				);
				


endmodule
