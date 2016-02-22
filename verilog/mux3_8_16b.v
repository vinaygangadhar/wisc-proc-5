module mux3_8_16b(in0, in1, in2, in3, in4, in5, in6, in7, sel, out);

input [15:0] in0, in1, in2, in3, in4, in5, in6, in7;
input [2:0] sel;
output [15:0] out;

wire [15:0] w1, w2;
//have decoder but only enable selected one, wire data to all of them


four_one_mux15 m1(.Out(w1), .InA(in0), .InB(in1), .InC(in2), .InD(in3), .S(sel[1:0]));
four_one_mux15 m2(.Out(w2), .InA(in4), .InB(in5), .InC(in6), .InD(in7), .S(sel[1:0]));
two_one_mux15 m3(.Out(out), .InA(w1), .InB(w2), .S(sel[2]));

endmodule