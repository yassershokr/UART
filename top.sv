// Engineer: Yasser Mohamed
// Create Date: 19/4/2024 
// Module Name: TOP
// Project Name: UART

module UART 
    #(
        parameter DataBits = 8,
        parameter ClkTicks = 16,
        parameter addr_width = 5,
        parameter Read = 2'b01,
        parameter Write = 2'b10,
        parameter Read_and_Write = 2'b11
    )
    (
        input clk,reset_n,
				input read_uart,write_uart,rx,
				input [DataBits-1:0] w_data,
				input [10:0]Final_Value,
				output [DataBits-1:0] r_data,
				output tx,
				output rx_empty,tx_full,rx_full
    );

    // Intermediate signals declaration
        logic [DataBits-1:0]din,dout;
				logic rx_done_tick,tx_done_tick;
				logic tx_start;
				logic s_tick;
				logic full_fifo_out;
        logic empty_tx_fifo;

    // UART Transmitter
    Transmitter #(.DataBits(DataBits), .StopBitTicks(ClkTicks)) tx1
				(
				.clk(clk),
				.reset_n(reset_n),
				.tx_start(~tx_start),
			  .s_tick(s_tick),                                          
				.tx(tx),                                         
				.tx_done_tick(tx_done_tick),                               
				.tx_din(din)                                   
				);

    // UART Receiver
    Receiver #(.DataBits(DataBits), .StopBitTicks(ClkTicks))  rx1
				(
				.clk(clk),
				.reset_n(reset_n),
				.s_tick(s_tick),																		
				.rx(rx),
				.rx_done_tick(rx_done_tick),
		    .rx_dout(dout)
				);

    // Receiver FIFO
    FIFO #( .addr_width(addr_width), .DataBits(DataBits), .Read(Read), .Write(Write),.Read_and_Write(Read_and_Write))
 
           FIFO_RX 
        ( .clk(clk),
				  .Reset(reset_n),
				  .wr(rx_done_tick),
				  .rd(read_uart),
				  .w_data(dout),
				  .r_data(r_data),
				  .full(full_fifo_out),
				  .empty(rx_empty) );

    // Transmitter FIFO
   FIFO #( .addr_width(addr_width), .DataBits(DataBits), .Read(Read), .Write(Write),
 .Read_and_Write(Read_and_Write)) 
 
          FIFO_TX 
      ( .clk(clk),
				.Reset(reset_n), 
				.wr(write_uart), 
				.rd(tx_done_tick), 
				.w_data(w_data), 
				.r_data(din),
        .full(tx_full),
        .empty(empty_tx_fifo) );

    // Baud rate generator
    baud_rate_generator #(.DataBits(DataBits)) Stage0
				(
				.clk(clk),
				.reset_n(reset_n),
				.final_value(Final_Value),             
				.done(s_tick)                               
				); 
endmodule