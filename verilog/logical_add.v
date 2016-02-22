module logical_add(inA, inB, op_c, cIn, co, out);

input [15:0] inA;
input [15:0] inB;
input [1:0] op_c;
input cIn;
output [15:0] out;
output co;

wire [15:0] w_add, w_or, w_xor, w_and;
wire carry;


cla16 adder(.inA(inA), .inB(inB), .cIn(cIn), .sum(w_add), .cOut(carry));
or_  or1(.inA(inA), .inB(inB), .out(w_or));
and_ and1(.inA(inA), .inB(inB), .out(w_and));
xor_ xor1(.inA(inA), .inB(inB), .out(w_xor));

assign co = carry & (~op_c[0]) & (~op_c[1]);

four_one_mux15 mux4(.Out(out), .InA(w_add), .InB(w_or), .InC(w_xor), .InD(w_and), .S(op_c));

endmodule

