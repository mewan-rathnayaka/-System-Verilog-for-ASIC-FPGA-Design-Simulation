module AXI2RX #(
    parameter CLOCKS_PER_PULSE = 4,
              BITS_PER_WORD    = 8,
              PACKET_SIZE      = BITS_PER_WORD + 5,
              W_OUT            = 16,
    localparam NUM_WORDS = W_OUT/BITS_PER_WORD
) (
    input logic clk, rstn,
    input logic s_valid,
    input logic [NUM_WORDS - 1 : 0][BITS_PER_WORD - 1: 0] s_data,
    output logic tx, s_ready
);
    logic [NUM_WORDS - 1: 0][PACKET_SIZE - 1: 0] s_packets;
    logic [NUM_WORDS*PACKET_SIZE - 1 : 0] m_packets;

    always_comb begin
        s_packets = '1;
        for (int i=0; i<NUM_WORDS; ++i) begin
            s_packets[i][BITS_PER_WORD : 0] = {s_data[i], 1'b0};
        end
        tx = m_packets[0];
    end

    logic [$clog2(NUM_WORDS*PACKET_SIZE)-1:0]     c_pulse;
    logic [$clog2(CLOCKS_PER_PULSE)-1:0]         c_clocks;

    enum  {IDLE, SEND  } state;

    always_ff @(posedge clk or negedge rstn) begin
        
        if (!rstn) begin
            state <= IDLE;
            m_packets <= '1;
            {c_pulse, c_clocks} = 0;
        end else begin
            case (state)
            IDLE: begin
                s_ready <= 1;
                if (s_valid) begin
                    state <= SEND;
                    m_packets <= s_packets;
                end
            end
            SEND: if (c_clocks == CLOCKS_PER_PULSE - 1) begin
                c_clocks <= 0;

                if (c_clocks == NUM_WORDS*PACKET_SIZE - 1) begin
                    c_pulse     <= 0;
                    m_packets   <= '1;
                    state       <= IDLE;
                end else begin
                    c_pulse <= c_pulse + 1;
                    m_packets <= (m_packets >> 1);
                end

            end else begin
                c_clocks <= c_clocks + 1;
            end 
            endcase   
        end
    end
    
endmodule