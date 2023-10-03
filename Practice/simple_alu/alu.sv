module alu #(
    parameter WIDTH = 8,
              ALU_sel_WIDTH = 3
) (
    input logic signed [WIDTH-1:0] bus_a,bus_b,
    output logic signed [WIDTH-1:0] alu_out,
    input logic[ALU_sel_WIDTH-1:0] alu_sel,
    output logic zero, negative
);

    always_comb begin
        unique case (alu_sel)
            'b001 : alu_out = bus_a+bus_b;
            'b010 : alu_out = bus_a-bus_b;
            'b011 : alu_out = bus_a*bus_b;
            'b100 : alu_out = bus_a/2;
            default : alu_out = bus_b;            
        endcase
    end
    
    assign zero = (alu_out == 0);
    assign negative = (alu_out < 0);
endmodule