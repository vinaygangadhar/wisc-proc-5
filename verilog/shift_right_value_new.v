module shift_right_value(in, opsel, count, out);
	
	input[15:0] in;
	input opsel;	// A 0 means rotate right, a 1 means logical shift right
	wire [15:0] A,B,C;
	input [3:0] count;
	output [15:0] out;
	
	two_input_mux Shift1 [15:0] (.a(in), .b({~opsel & in[0], in[15:1]}), .S(count[0]), .out(A));
	
	two_input_mux Shift2 [15:0] (.a(A), .b({ {2{~opsel}} & A[1:0], A[15:2]}), .S(count[1]), .out(B));
	
	two_input_mux Shift3 [15:0] (.a(B), .b({{4{~opsel}} & B[3:0], B[15:4]}), .S(count[2]), .out(C));
	
	two_input_mux Shift4 [15:0] (.a(C), .b({{8{~opsel}} & C[7:0], C[15:8]}), .S(count[3]), .out(out));
	
endmodule
