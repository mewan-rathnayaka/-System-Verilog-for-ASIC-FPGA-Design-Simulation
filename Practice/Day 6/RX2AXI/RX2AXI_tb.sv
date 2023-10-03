`timescale 1ns/1ps;

module RX2AXI_tb;

    localparam CLK_PERIOD = 10;
    logic clk = 0, rstn = 0;
    initial forever begin
        #(CLK_PERIOD / 2)
        clk <= ~clk;
    end

    localparam CLOCKS_PER_PULSE = 4, W_OUT = 16, BITS_PER_WORD = 8, 
           NUM_WORDS = W_OUT/ BITS_PER_WORD;

    logic baud = 0, rx = 1, m_valid;
    logic [NUM_WORDS-1:0][BITS_PER_WORD-1:0] m_data, data;
    logic [BITS_PER_WORD + 1: 0] packet;
    
    RX2AXI #(.CLOCKS_PER_PULSE(CLOCKS_PER_PULSE), .W_OUT(W_OUT), .BITS_PER_WORD(BITS_PER_WORD)) dut(.*);
    initial begin
        repeat(2) @(posedge clk) #1;
        rstn = 1;
        repeat(5) @(posedge clk) #1;

        
        repeat(10) begin
            data = $urandom();

            for (int iw=0; iw<NUM_WORDS; ++iw) begin
                packet = {1'b1, data[iw], 1'b0};

                repeat($urandom(1,20)) @(posedge clk);

                for (int ib=0; ib<BITS_PER_WORD; ++ib) begin
                    repeat(CLOCKS_PER_PULSE) begin
                        #1 rx <= packet[ib];
                        @(posedge clk);
                    end
                    baud <= !baud;
                end

            end
            repeat($urandom(1,100)) @(posedge clk);
        end
    end

    initial forever begin
        @(posedge clk)
        if (m_valid) begin
            assert (m_data == data) $display ("ok ,%b", m_data);
            else   $error("Sent %b, got %b", data, m_data);
        end
    end
endmodule