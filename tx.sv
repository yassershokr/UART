// Engineer: Yasser Mohamed
// Create Date: 19/4/2024 
// Module Name: Transmitter
// Project Name: UART

module Transmitter
    #(parameter DataBits = 8, StopBitTicks = 16)
    (
        input logic clk, reset_n,
        input logic s_tick,
        input logic tx_start,
        input logic [DataBits-1:0] tx_din,
        output logic tx,
        output logic tx_done_tick
    );

    // States
    localparam [1:0] Idle = 2'b00, Start = 2'b01, Transmit = 2'b10, Stop = 2'b11;

    // State registers
    logic [1:0] state, next_state;
    logic [3:0] s_reg, s_next;
    logic [$clog2(DataBits)-1:0] n_reg, n_next;
    logic [DataBits-1:0] b_reg, b_next;
    logic tx_reg, tx_next;

    // State transition
    always_ff @(posedge clk or negedge reset_n) begin
        if (~reset_n) begin
            state <= Idle;
            s_reg <= 0;
            n_reg <= 0;
            b_reg <= 0;
            tx_reg <= 1'b1;
        end 
        else 
        begin
            state <= next_state;
            s_reg <= s_next;
            n_reg <= n_next;
            b_reg <= b_next;
            tx_reg <= tx_next;
        end
    end

    // Next state logic
    always_comb begin
        next_state = state;
        b_next = b_reg;
        s_next = s_reg;
        n_next = n_reg;
        tx_done_tick = 1'b0;

        case (state)
            Idle: begin
                tx_next = 1'b1;
                if (tx_start) begin
                    s_next = 0;
                    b_next = tx_din;
                    next_state = Start;
                end
              else 
                begin
                    next_state = Idle;
                end
            end
            Start: 
            begin
                tx_next = 1'b0;
                if (s_tick && s_reg == 15) begin
                    s_next = 0;
                    n_next = 0;
                    next_state = Transmit;
                end 
                else 
                begin
                    s_next = s_reg + 1;
                    next_state = Start;
                end
            end
            Transmit: begin
                tx_next = b_reg[0];
                if (s_tick)
									begin
										if (s_reg == 15)
										begin
											s_next = 0;
											b_next = {1'b0, b_reg[(DataBits - 1):1]};
											next_state = Transmit;
											if(n_reg == (DataBits - 1))
												next_state = Stop;
											else
												n_next = n_reg + 1;
										end
										else
										begin
											s_next = s_next + 1;
											next_state = Start;
										end
									end
            end
            Stop: begin
                tx_next = 1'b1;
                if (s_tick)
									begin
										if (s_reg == (StopBitTicks-1))
										begin											
											tx_done_tick = 1'b1;
											next_state = Idle;										
										end
										else
										begin
											s_next = s_reg + 1;
											next_state = Transmit;
										end
									end
								end
            default: next_state = Idle;
        endcase
    end

    // Output assignment
    assign tx = tx_reg;
endmodule