module alu_tb;
    timeunit 1ns/1ps;

    localparam WIDTH = 8;
  	logic [2:0] alu_sel;
    logic signed [WIDTH-1:0] bus_a,bus_b,alu_out;
  	logic zero,negative;

    alu #(.WIDTH(WIDTH)) dut(.*);

    initial begin
        $dumpfile("Dump.vcd");  $dumpvars(0, dut);

        #10 bus_a <= 8'd5; bus_b <= 8'd10 ; alu_sel <= 3'b000;
        #10 bus_a <= 8'd30 ; bus_b <= 8'd10 ; alu_sel <= 3'b001;
        #10 bus_a <= 8'd5 ; bus_b <= 8'd10 ; alu_sel <= 3'b010;
        #10;
    end

endmodule