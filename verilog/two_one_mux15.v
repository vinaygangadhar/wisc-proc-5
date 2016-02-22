module two_one_mux15(Out, InA, InB, S);

output [15:0] Out;
input [15:0] InA, InB;
input S;

assign Out[15:0] = (InA & (~{16{S}}) ) | (InB & ({16{S}}) );


endmodule

