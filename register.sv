// Engineer: Yasser Mohamed
// Create Date: 21/9/2023 
// Module Name: Register_file
// Project Name: UART

module Register_file #(
    parameter addr_width = 5,
    parameter DataBits = 8) 
    (
    input clk,
    input w_en,
    input [DataBits-1:0] w_data,
    input [addr_width-1:0] w_addr, r_addr,
    output [DataBits-1:0] r_data
    );

    logic [DataBits-1:0] mem [0:2**addr_width-1];

    always_ff @(posedge clk) 
    begin
        if (w_en) 
            mem[w_addr] <= w_data;
    end

    assign r_data = mem[r_addr];
endmodule