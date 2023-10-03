module gates(
input A, B, C, D,
input [3:0] vA, vB,
output W, U, X, Y, Z,
output [3:0] vX, vY);

assign W = A & B;
assign U = ~(A|B);
assign X = C^D;
assign Y = C~^D;
assign Z = (A&B) |(C&D);
assign vX = vA & vB;
assign vY = vA | vB;

endmodule
// scalar AND gate
// scalar NOR gate
// scalar XOR gate
// scalar XNOR gate
// AND-OR gates
// vector bitwise AND
// vector bitwise OR