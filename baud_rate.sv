// Engineer: Yasser Mohamed
// Create Date: 21/4/204 
// Module Name: Baud_rate_gen
// Project Name: UART

module baud_rate_generator
    #(parameter DataBits = 8)
    (
        input logic clk, reset_n,
        input logic [10:0] final_value,
        output logic done
    );

    logic [DataBits-1:0] Q_reg,Q_next;

    always_ff @(posedge clk or negedge reset_n) 
    begin
        if (~reset_n) 
        begin
            Q_reg <= '0;
        end 
        else 
        begin
          Q_reg <= Q_next;
        end
    end
    assign Q_next = (Q_reg==final_value) ? 0 : Q_reg + 1;
    assign done = (Q_reg==1);
endmodule