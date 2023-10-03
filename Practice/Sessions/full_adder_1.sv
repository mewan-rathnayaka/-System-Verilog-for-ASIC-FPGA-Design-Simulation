module full_adder(input logic a,b,ci,
                  output logic sum,co);
  logic wire_1,wire_2;
  
  assign wire_1 = a^b;
  assign wire_2 = wire_1 & ci;
  
  wire wire_3 = a&b;
  
  always_comb begin
      co = wire_2 | wire_3;
      sum = wire_1 ^ ci;
    end
endmodule