/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP5-1
// Date      : Wed Apr 26 19:29:19 2023
/////////////////////////////////////////////////////////////


module full_adder ( a, b, ci, sum, co );
  input a, b, ci;
  output sum, co;
  wire   n2;

  XOR2X2_HVT U4 ( .A1(b), .A2(a), .Y(n2) );
  AO22X1_HVT U5 ( .A1(a), .A2(b), .A3(n2), .A4(ci), .Y(co) );
  XOR3X2_HVT U6 ( .A1(b), .A2(a), .A3(ci), .Y(sum) );
endmodule

