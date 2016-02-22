module cla16(inA, inB, cIn, sum, cOut);

input [15:0] inA, inB;
input cIn;
output [15:0] sum;
output cOut;
wire carry1, carry2, carry3, carry4;

cla4 b1( .inA(inA[3:0]), .inB(inB[3:0]), .cIn(cIn), .sum(sum[3:0]), .c0(carry1));
cla4 b2( .inA(inA[7:4]), .inB(inB[7:4]), .cIn(carry1), .sum(sum[7:4]), .c0(carry2));
cla4 b3( .inA(inA[11:8]), .inB(inB[11:8]), .cIn(carry2), .sum(sum[11:8]), .c0(carry3));
cla4 b4( .inA(inA[15:12]), .inB(inB[15:12]), .cIn(carry3), .sum(sum[15:12]), .c0(cOut));

endmodule

