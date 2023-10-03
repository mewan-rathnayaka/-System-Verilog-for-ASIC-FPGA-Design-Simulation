`timescale  1ns/1ps

module funtion_lut_tb;
localparam W_x =4, W_y = 8;
logic signed [W_x - 1: 0] xf = 3, xq = 3, xiq;
logic signed [W_y - 1: 0] yiq = 3, yf, yq_lut, yq_fun;
funtion_lut #(.W_x(W_x), .W_y(W_y)) dut(.*);

initial begin
    $dumpfile("dump.vcd"); $dumpvars;
    #20 $finish;
end
    
endmodule