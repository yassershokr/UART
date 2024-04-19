// Engineer: Yasser Mohamed
// Create Date: 19/4/2024 
// Module Name: Reciever
// Project Name: UART

module Receiver
    #(parameter DataBits = 8, StopBitTicks = 16)
    (
        input logic clk, reset_n,
        input logic s_tick,
        input logic rx,
        output logic rx_done_tick,
        output logic [DataBits-1:0] rx_dout
    );

    // States
    localparam [1:0] Idle = 2'b00, Start = 2'b01, Receive = 2'b10, Stop = 2'b11;

    // State registers
    logic [1:0] state, next_state;
    logic [3:0] s_reg, s_next;
    logic [$clog2(DataBits)-1:0] n_reg, n_next;
    logic [DataBits-1:0] b_reg, b_next;

    // State transition
    always_ff @(posedge clk or negedge reset_n) begin
        if (~reset_n) 
        begin
            state <= Idle;
            s_reg <= 0;
            n_reg <= 0;
            b_reg <= 0;
        end 
        else 
        begin
            state <= next_state;
            s_reg <= s_next;
            n_reg <= n_next;
            b_reg <= b_next;
        end
    end

    // Next state logic
    always_comb 
    begin
        next_state = state;
        b_next = b_reg;
        s_next = s_reg;
        n_next = n_reg;
        rx_done_tick = 1'b0;

        case (state)
            Idle: 
            begin
                if (~rx)
									begin							
										s_next = 0;
										next_state = Start;										
									end
									else										
										next_state = Idle;
            end
            Start: 
            begin
                if (s_tick)
									begin
										if (s_reg == 7)
										begin
											s_next = 0;
											n_next = 0;
											next_state = Receive;
											
										end
										else
										begin
											s_next = s_next + 1;
											next_state = Start;
										end
									end

            end
            Receive: 
            begin
                if (s_tick)
									begin
										if (s_reg == 15)
										begin
											s_next = 0;
											b_next = {rx, b_reg[(DataBits - 1):1]};
											if(n_reg == (DataBits - 1))
												next_state = Stop;
											else
												n_next = n_reg + 1;
										end
										else
										begin
											s_next = s_next + 1;
											next_state = Receive;
										end
									end

            end
            Stop: 
            begin
                if (s_tick)
									begin
										if (s_reg == (StopBitTicks-1))
										begin
											
											rx_done_tick = 1'b1;
											next_state = Idle;
										
										end
										else
										begin
											s_next = s_reg + 1;
											next_state = Stop;
										end
									end
            end
            default: next_state = Idle;
        endcase
    end

    // Output assignment
    assign rx_dout = b_reg;
endmodule