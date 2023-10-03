module n_adder_tb;
  
  timeunit 10ns; timeprecision 1ns;
  
  localparam N = 8;
  
  logic signed [N-1:0] A, B, S;
  logic ci, co;
  
  bit [N-1:0] m;
  
  n_adder #(.N(N)) dut(.*));
  
  initial begin
    $dumpfile("dump.vcd"); $dumpvars(0,dut);
    
    A<=8'd5; B<=-8'd10; ci<=0;
    
    #10 A<=8'd30; B<=-8'd10; ci<=0;
    #10 A<=8'd5; B<=8'd10; ci<=1;
    #10 A<=8'd127; B<=-8'd1; ci<=0;
    
    repeat(10) begin
      #9
      std::randamize(ci);
      std::randamize(A) with {A inside {[-127:127]}; };
      std::randamize(B) with {B inside {[-127:127]}; };
      
      #1
      assert ({co,S} == A+B+ci)
        else $error("%d+%d+%d != {%d,%d}", A,B,ci,co,S);
    end
  end 
endmodule
  