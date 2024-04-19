// Engineer: Yasser Mohamed
// Create Date: 21/9/2023 
// Module Name: FIFO
// Project Name: UART

module FIFO 
    #(
        parameter addr_width = 5,
        parameter DataBits = 8,
        parameter Read = 2'b01,
        parameter Write = 2'b10,
        parameter Read_and_Write = 2'b11
    )
    (
        input clk, Reset,
        input wr, rd,
        input [DataBits-1:0] w_data,
        output logic full, empty,
        output [DataBits-1:0] r_data
    );

    // Intermediate signals declaration
    logic [addr_width-1:0] w_addr, r_addr;
    logic w_en;

    // Write enable logic
    assign w_en = wr & (~full);

    // Initialize FIFO control unit
    FIFO_Contr 
        #(
            .addr_width(addr_width), 
            .Read(Read), 
            .Write(Write), 
            .Read_and_Write(Read_and_Write)
        )
        controller
        (
            .clk(clk),
            .Reset(Reset),
            .wr(wr),
            .rd(rd),
            .full(full),
            .empty(empty),
            .w_addr(w_addr),
            .r_addr(r_addr)
        );

    // Initialize register file
    Register_file 
        #(
            .addr_width(addr_width), 
            .DataBits(DataBits)
        )
        reg_file
        (
            .clk(clk),
            .w_en(w_en),
            .w_data(w_data),
            .w_addr(w_addr),
            .r_addr(r_addr),
            .r_data(r_data)
        );
endmodule