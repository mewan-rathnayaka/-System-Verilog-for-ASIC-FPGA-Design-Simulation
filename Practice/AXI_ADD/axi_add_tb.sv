`timescale 1ns/1ps
module axi_add_tb;
    logic clk = 0, reset = 0;
    localparam CLK_PERIOD = 10;
    initial forever
        #(CLK_PERIOD/2)
        clk <= ~clk;
    
    parameter N = 8;
    logic[N-1 : 0] data;
    logic s_ready = 0, m_ready, m_valid, s_valid;
    logic [6:0] m_data_ones, m_data_tens;

    axi_add #(.NUM_COUNT(N)) dut(.*);

    initial begin
        $dumpfile("dump.vcd"); $dumpvars;

        @(posedge clk); #1 reset <= 1;
        @(posedge clk ) #1 data =4'd7; s_valid =1; m_ready =1;
        #10
        @(posedge clk ) #1 data =4'd7; #10
        @(posedge clk ) #1 data =4'd7; #10
        @(posedge clk ) #1 data =4'd7; #10
        @(posedge clk ) #1 data =4'd7; #10
        @(posedge clk ) #1 data =4'd7; #10
        @(posedge clk ) #1 data =4'd7; #10
        @(posedge clk ) #1 data =4'd7; #10
        #50
        $finish();





    end


endmodule