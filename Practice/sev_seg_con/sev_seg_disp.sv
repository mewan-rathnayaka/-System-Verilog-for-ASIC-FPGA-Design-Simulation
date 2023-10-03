module sev_seg_disp #(
    parameter WIDTH=4
) (
    input logic signed [WIDTH-1 :0] int_ger,
    output logic [6:0] out_array
    //Outarray reflects a,b,c,d,e,f,g grom 0 to 6 order.
);
always_comb begin 
    unique case (int_ger)
    'b0000  : out_array = 'b1111110;
    'b0001  : out_array = 'b0110000;
    'b0010  : out_array = 'b1101101;
    'b0011  : out_array = 'b1111001;
    'b0100  : out_array = 'b0110011;
    'b0101  : out_array = 'b1011011;
    'b0110  : out_array = 'b1011111;
    'b0111  : out_array = 'b1110000;
    'b1000  : out_array = 'b1111111;
    'b1001  : out_array = 'b1111011;
    default : out_array = 'b0000001;
    //in default, or error only g lights up showing no number.        
    endcase  
end   
endmodule