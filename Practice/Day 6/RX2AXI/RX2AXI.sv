module RX2AXI #(
    parameter CLOCKS_PER_PULSE = 4,
              BITS_PER_WORD = 8,
              W_OUT = 16
) (
    input logic clk, rstn,
    input logic rx,
    output logic m_valid,
    output logic [W_OUT - 1 : 0] m_data
);
    localparam NUM_WORDS = W_OUT/BITS_PER_WORD;
    enum  {IDLE, START, COLLECT, FINISH} state;

    //Counters
    logic [$clog2(NUM_WORDS)-1 : 0]       c_words;
    logic [$clog2(BITS_PER_WORD)-1:0]     c_bits;
    logic [$clog2(CLOCKS_PER_PULSE)-1:0] c_clocks;

    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            {m_data, m_valid, c_bits, c_clocks, c_words} = '0;
            state <= IDLE;
        end else begin
            m_valid <= 0;
            case (state)
                IDLE: if (!rx) begin
                    state <= START;
                end

                START: if (c_clocks == CLOCKS_PER_PULSE/2 -1) begin
                    state <= COLLECT;
                    c_clocks <= 0;
                end else begin
                    c_clocks <= c_clocks + 1;
                end
                
                COLLECT: if (c_clocks == CLOCKS_PER_PULSE - 1) begin
                    c_clocks <= 0;
                    m_data <= {rx, m_data[W_OUT-1 : 1]};

                    if (c_bits == BITS_PER_WORD - 1) begin
                        state <= FINISH;
                        c_bits <= 0;

                        if (c_words == NUM_WORDS - 1) begin
                            m_valid <= 1;
                            c_words <= 0;

                        end else begin
                            c_words <= c_words + 1;
                        end


                    end else begin
                        c_bits <= c_bits + 1;
                    end

                end else begin
                    c_clocks <= c_clocks + 1;
                end

                FINISH : if (c_clocks == CLOCKS_PER_PULSE - 1) begin
                    state <= IDLE;
                    c_clocks <= 0;
                end else begin
                    c_clocks <= c_clocks + 1;
                end
            endcase
        end
    end

     
    
endmodule