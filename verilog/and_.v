module and_(inA, inB, out);

input [15:0] inA;
input [15:0] inB;
output [15:0] out;

assign out[15:0] = inA & inB;

endmodule

