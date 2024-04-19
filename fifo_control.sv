// Engineer: Yasser Mohamed
// Create Date: 19/4/2024 
// Module Name: FIFO_Control
// Project Name: UART

module FIFO_Contr #(
    parameter addr_width = 5,
    parameter Read = 2'b01,
    parameter Write = 2'b10,
    parameter Read_and_Write = 2'b11
) (
    input logic clk, Reset,
    input logic wr, rd,
    output logic full, empty,
    output logic [addr_width-1:0] w_addr, r_addr
);

    logic full_next, full_logic;
    logic empty_next, empty_logic;
    logic [addr_width-1:0] wr_ptr_next, wr_ptr_logic, wr_ptr_succ;
    logic [addr_width-1:0] rd_ptr_next, rd_ptr_logic, rd_ptr_succ;

    always_ff @(posedge clk or posedge Reset) begin
        if (Reset) begin
            full_logic <= 1'b0;
            empty_logic <= 1'b1;
            wr_ptr_logic <= '0;
            rd_ptr_logic <= '0;
        end else begin
            full_logic <= full_next;
            empty_logic <= empty_next;
            wr_ptr_logic <= wr_ptr_next;
            rd_ptr_logic <= rd_ptr_next;
        end
    end

    always_comb begin
        full_next = full_logic;
        empty_next = empty_logic;
        wr_ptr_next = wr_ptr_logic;
        rd_ptr_next = rd_ptr_logic;

        wr_ptr_succ = wr_ptr_logic + 1;
        rd_ptr_succ = rd_ptr_logic + 1;

        unique case ({wr, rd})
            Read: if (~empty_logic) begin
                rd_ptr_next = rd_ptr_succ;
                full_next = 1'b0;
                if (rd_ptr_succ == wr_ptr_logic) empty_next = 1'b1;
            end
            Write: if (~full_logic) begin
                wr_ptr_next = wr_ptr_succ;
                empty_next = 1'b0;
                if (wr_ptr_succ == rd_ptr_logic) full_next = 1'b1;
            end
            Read_and_Write: begin
                wr_ptr_next = wr_ptr_succ;
                rd_ptr_next = rd_ptr_succ;
            end
            default: ; // No operation
        endcase
    end

    assign full = full_logic;
    assign empty = empty_logic;
    assign w_addr = wr_ptr_logic;
    assign r_addr = rd_ptr_logic;
endmodule
