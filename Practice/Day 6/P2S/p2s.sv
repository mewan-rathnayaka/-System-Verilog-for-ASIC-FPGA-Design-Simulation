module p2s #(
    parameter NUM = 8
) (
    input logic [NUM - 1: 0] p_data,
    input logic clk, rstn,
    input logic p_valid, s_ready,
    output logic p_ready, s_data, s_valid
);
    enum {RX, TX} state, next_state;
    logic [$clog2(NUM)-1 : 0] count;

    always_comb begin
        unique case (state)
            RX : next_state = (p_valid)                 ? TX : RX;
            TX : next_state = ((count == 7) && s_ready) ? RX : TX;     
        endcase   
    end 
    always_ff@(posedge clk or negedge rstn) begin
        state <= (!rstn) ? RX : next_state;
    end

    logic [NUM-1 : 0] shift_reg;

    assign s_data = shift_reg[0];
    assign p_ready = (state == RX);
    assign s_valid = (state == TX);

    always_ff @(posedge clk or negedge rstn) begin
        unique case (state)
            RX :begin
                    count <= 0;
                    shift_reg <= p_data;
            end
            TX:if (s_ready) begin
                    count <= count + 1'd1;
                    shift_reg <= shift_reg >> 1;
            end 
        endcase
    end   
endmodule