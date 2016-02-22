module alu (A, B, Cin, Op, invA, invB, sign, Out, Ofl, c_out, Z);

   input [15:0] A;
   input [15:0] B;
   input 	Cin;
   input [2:0]	Op;
   input 	invA;
   input 	invB;
   input 	sign;
   output [15:0] Out;
   output 	 Ofl;
   output    c_out;
   output 	 Z;
   
   wire [15:0] inA, inB;
   wire carry;
   wire [15:0] logic_add, shifter_o;
   
   //handle inversion first
   two_one_mux15 mux1(.Out(inA), .InA(A), .InB(~A), .S(invA));
   two_one_mux15 mux2(.Out(inB), .InA(B), .InB(~B), .S(invB));
   
   
   
   shifter sh(.In(inA), .Cnt(inB[3:0]), .Op(Op[1:0]), .Out(shifter_o));
   logical_add la(.inA(inA), .inB(inB), .op_c(Op[1:0]), .cIn(Cin), .co(carry), .out(logic_add));
   
   two_one_mux15 mux3(.Out(Out), .InA(shifter_o), .InB(logic_add), .S(Op[2]));
   
   assign c_out = carry;
   assign Ofl = ((sign &((inA[15] ~^ inB[15])  & (logic_add[15] ^ inA[15]) ) ) | (~sign & carry) ) & Op[2] & ~Op[1] & ~Op[0];
   assign Z =  &(~Out);
    

endmodule

