//This is previous case, not accompaning the new control signals

module ass_1_1_tb;
    timeunit 1ns/1ps;

    localparam W = 3, N = 5, CLK_PERIOD = 10;
    logic clk = 0, rst = 0;
    logic [W-1 : 0] s_data;
    logic [1:0][6:0] m_data;

    initial forever #(CLK_PERIOD/2) clk <= !clk;
    ass_1_1 #(.W(W), .N(N)) dut(.*);

    initial begin
        repeat(2) @(posedge clk);
        #1 rst <= 1;

        for (int i=0; i<N; ++i) begin
            s_data <= i;
            @(posedge clk);            
        end
    end
endmodule