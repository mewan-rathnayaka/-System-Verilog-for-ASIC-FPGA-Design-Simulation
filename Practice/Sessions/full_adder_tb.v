// Code your testbench here
// or browse Examples
module full_adder_tb;
  
  timeunit 10ns; timeprecision 1ns;
  
  logic a=0, ci=0, b, sum, co;
  
  full_adder dut(.*);
  
  initial begin
    $dumpfile("dump.vcd"); $dumpvars(0,dut);
    
    #30 a<=0; b<=0; ci<=0;
  	#10 a<=0; b<=0; ci<=1;
    
    #20 a<=1; b<=1; ci<=0;
    
    #1 assert({co+sum}==a+b+ci)
      $display("OK");
    else $error("Not OK");
    
    #10 a<=1; b<=1;ci<=1;
    
    #1	assert (dut.wire_1 ==0)
      else $error("False.wire_1:%d", dut.wire_1);
    $finish();
  end 
endmodule
  
  