module four_one_mux15(Out, InA, InB, InC, InD, S);

input [15:0] InA, InB, InC, InD;
input [1:0] S;

output[15:0] Out;
wire [15:0] w1, w2;

two_one_mux15 M1(.Out(w1), .InA(InA), .InB(InB), .S(S[0]));
two_one_mux15 M2(.Out(w2), .InA(InC), .InB(InD), .S(S[0]));
two_one_mux15 M3(.Out(Out), .InA(w1), .InB(w2), .S(S[1]));

endmodule
