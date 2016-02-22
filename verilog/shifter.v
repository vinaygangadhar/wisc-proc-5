module shifter (In, Cnt, Op, Out);
   
    input [15:0] In;
    input [3:0]  Cnt;
    input [1:0]  Op;
    output [15:0] Out;

    wire[15:0] shiftLeft, shiftRight;


    shift_left_value left(.in(In), .opsel(Op[0]), .count(Cnt), .out(shiftLeft));
   
    shift_right_value right_new(.in(In), .opsel(Op[0]), .count(Cnt), .out(shiftRight));
   
    two_input_mux op1[15:0](.a(shiftLeft), .b(shiftRight), .S(Op[1]), .out(Out)); 
   
endmodule
