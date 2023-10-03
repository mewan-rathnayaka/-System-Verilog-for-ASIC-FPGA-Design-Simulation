module sev_seg_tb;
timeunit 1ns; timeprecision 1ps;

localparam N = 4;
logic signed [N-1 :0] int_ger; 
logic [6:0] out_array;

sev_seg_disp #(.WIDTH(N)) dut (.*);

initial begin
    $dumpfile("dump.vcd");  
  	$dumpvars(0, dut);

    #10 int_ger <= 3;
    #10 int_ger <= 5;
    #10;
end
    
endmodule