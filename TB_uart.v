// Engineer: Yasser Mohamed
// Create Date: 22/9/2023 
// Module Name: TB
// Project Name: UART

module UART_TB;
				parameter DataBits = 8, ClkTicks = 16;

				
				reg clk,reset_n;
				reg read_uart,write_uart,rx;
				reg [DataBits-1:0] w_data;
				reg [9:0]Final_Value;
				wire [DataBits-1:0] r_data;
				wire tx;
				wire rx_empty,tx_full,rx_full;

				  initial 
				  begin
					 reset_n = 1'b0;
					 clk = 0;
					 Final_Value = 10'b1010001010;
					 #10;
					 reset_n = 1'b1;
				  end

				  always #5 clk = ~clk;

	initial 
	begin
	 
	 #100
	 
	 w_data=8'b11100011;
	 
	 write_uart=1; #10
	 write_uart=0; 
	 
	 #1090000

	 
	 
	 
	 w_data=8'b11110000;
	 
	 write_uart=1; #10
	 write_uart=0; 
	 
	 #1090000
	 
	 write_uart=0; 

	 
	 end
 
 
//receive data

 	initial 
	begin
	 
	 
	 #10000 //delay between receiver and transmiter
	 
 //first case
	 //idle state 
	 
	 rx=1;
	 
	 #10
	 
	 
	 //start bit
	 
	 rx=0;
	 
	 #52000 //start bit duration is 8 ticks as defined in UART top module so the duration= 8*650*10 ns=52000ns
	 
	 
	 //data bits
	 
	 //firts bit
	 
	 rx=1;
	 
	 #104000

	 
	 //second bit
	 
	 rx=1;
	 
	 #104000
	 
	 
	 //third bit
	 
	 rx=0;
	 
	 #104000
	 
	 
	 //fourth bit
	 
	 rx=0;
	 
	 #104000
	 

	 //fifth bit
	 
	 rx=0;
	 
	 #104000
	 
	 

	 //sixth bit
	 
	 rx=1;
	 
	 #104000
	 
	 
	 
	 //seventh bit
	 
	 rx=1;
	 
	 #104000
	 
	 
	 
	 //eighth bit
	 
	 rx=1;
	 
	 #104000
	 
	 
	 
	 //parith bit
	 
	 rx=0;
	 
	 #104000	 
	 

	 
	 //stop bit
	 
	 rx=1;
	 
	 #10000	 
 
 //second case

	 //idle state it can be removed as the lase bit is logic 1
	 
	 rx=1;
	 
	 #10
	 
	 
	 //start bit
	 
	 rx=0;
	 
	 #52000 
	 
	 
	 //data bits
	 
	 //firts bit
	 
	 rx=0;
	 
	 #104000

	 
	 //second bit
	 
	 rx=0;
	 
	 #104000
	 
	 
	 //third bit
	 
	 rx=0;
	 
	 #104000
	 
	 
	 //fourth bit
	 
	 rx=0;
	 
	 #104000
	 

	 //fifth bit
	 
	 rx=1;
	 
	 #104000
	 
	 

	 //sixth bit
	 
	 rx=1;
	 
	 #104000
	 
	 
	 
	 //seventh bit
	 
	 rx=1;
	 
	 #104000
	 
	 
	 
	 //eighth bit
	 
	 rx=1;
	 
	 #104000
	 
	 
	 
	 //parith bit
	 
	 rx=0;
	 
	 #104000	 
	 

	 
	 //stop bit
	 
	 rx=1;
	 
		 
 
 end
 
 
 // end

UART Myuart 
				(
				clk,reset_n,
				read_uart,write_uart,
				w_data,rx,
				Final_Value,
				r_data,
				tx,
				rx_empty,tx_full,rx_full
				);
				  
endmodule
