`timescale 1ns/1ps

module p2s_tb;

    localparam CLK_PERIOD = 10;
    logic clk = 0, rstn = 0;
    initial forever begin
        #(CLK_PERIOD / 1)
        clk <= ~clk;
    end

    parameter NUM = 8;

    logic [NUM - 1: 0] p_data;
    
    logic p_valid = 0, s_ready = 0;
    logic p_ready, s_data, s_valid;

    p2s #(.NUM(NUM)) dut(.*);

    initial begin
        @(posedge clk); #1 rstn <= 1;
        @(posedge clk); #1 p_data <= 8'd7;  p_valid <= 0; s_ready <= 1;
        #(CLK_PERIOD*3)
        @(posedge clk); #1 p_data <= 8'd63; p_valid <= 1;
        
        @(posedge clk); #1 p_valid <= 0;
        #(CLK_PERIOD*20)
        @(posedge clk); #1 p_data <= 8'd52; p_valid <= 1;
        #(CLK_PERIOD*1)
        @(posedge clk); #1 p_valid <= 0;
        @(posedge clk); #1 s_ready <=0;
        #(CLK_PERIOD*3)
        @(posedge clk); #1 s_ready <= 1;
        #(CLK_PERIOD*10)
        @(posedge clk); #1 s_ready <=0;
    end
endmodule