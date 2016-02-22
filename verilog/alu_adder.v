module alu_adder (A, B, Out, Ofl);

   input [15:0] A;
   input [15:0] B;
   output [15:0] Out;
   output 	 Ofl;

   
   logical_add la(.inA(A), .inB(B), .op_c(2'b00), .cIn(Cin), .co(Of1), .out(Out));

endmodule

