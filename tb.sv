// Engineer: Yasser Mohamed
// Create Date: 19/4/2024 
// Module Name: tb
// Project Name: UART

module tb_UART;
    // Parameters
    parameter DataBits = 8;
    parameter ClkTicks = 16;
    parameter addr_width = 5;
    parameter Read = 2'b01;
    parameter Write = 2'b10;
    parameter Read_and_Write = 2'b11;

    // Signals
    logic clk;
    logic reset_n;
    logic read_uart;
    logic write_uart;
    logic rx;
    logic [DataBits-1:0] w_data;
    logic [10:0] Final_Value;
    logic [DataBits-1:0] r_data;
    logic tx;
    logic rx_empty;
    logic tx_full;
    logic rx_full;

    // Instantiate the UART module
    UART #(
        .DataBits(DataBits),
        .ClkTicks(ClkTicks),
        .addr_width(addr_width),
        .Read(Read),
        .Write(Write),
        .Read_and_Write(Read_and_Write)
    ) uut (
        .clk(clk),
        .reset_n(reset_n),
        .read_uart(read_uart),
        .write_uart(write_uart),
        .rx(rx),
        .w_data(w_data),
        .Final_Value(Final_Value),
        .r_data(r_data),
        .tx(tx),
        .rx_empty(rx_empty),
        .tx_full(tx_full),
        .rx_full(rx_full)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    // Test sequence
    initial 
    begin
        // Initialize signals
        clk = 0;
        reset_n = 1;
        read_uart = 0;
        write_uart = 0;
        Final_Value = 650;
      end
   initial 
    begin
        // Apply reset
        #10 reset_n = 0;
        #10 reset_n = 1;
    end
        

        // Write some data
    initial     
	  begin
	    	 #100
	    	 w_data=8'b11100011;	 
      	 write_uart=1;
    	 	 #10 write_uart=0; 
	    	 #1090000
	    	 
        w_data=8'b10010011;	 
      	 write_uart=1;
    	 	 #10 write_uart=0; 
	    	 #1090000
	    	 
	    	 write_uart=0; 	 
  	 end
 
initial     
	begin
 	 #1000
	 // second byte 
	 rx=1;	 
	 #10
	 rx=0;	 
	 #52000 //start bit duration is 8 ticks as defined in UART top module so the duration= 8*650*10 ns=52000ns	 
	 //data bits	 
	 //first bit	 
	 rx=1;	 
	 #104000
	 //second bit	 
	 rx=1;	 
	 #104000	 	 
	 //third bit	 
	 rx=0;	 
	 #104000	 	 
	 //fourth bit	 
	 rx=1;	 
	 #104000
	 //fifth bit	 
	 rx=0;	 
	 #104000
	 //sixth bit	 
	 rx=1;	 
	 #104000	 
	 //seventh bit	 
	 rx=0;	 
	 #104000	 	 
	 //eighth bit	 
	 rx=1;	 
	 #104000	 	 	 
	 //stop bit	 
	 rx=1;	 
	 #1000	 
	 
	 
	// second byte 
	 rx=1;	 
	 #10
	 rx=0;	 
	 #52000 //start bit duration is 8 ticks as defined in UART top module so the duration= 8*650*10 ns=52000ns	 
	 //data bits	 
	 //first bit	 
	 rx=0;	 
	 #104000
	 //second bit	 
	 rx=1;	 
	 #104000	 	 
	 //third bit	 
	 rx=0;	 
	 #104000	 	 
	 //fourth bit	 
	 rx=1;	 
	 #104000
	 //fifth bit	 
	 rx=0;	 
	 #104000
	 //sixth bit	 
	 rx=0;	 
	 #104000	 
	 //seventh bit	 
	 rx=0;	 
	 #104000	 	 
	 //eighth bit	 
	 rx=1;	 
	 #104000	 	 	 
	 //stop bit	 
	 rx=1;	 
        end
endmodule
