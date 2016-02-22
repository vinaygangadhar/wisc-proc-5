module shift_left_value(in, opsel, count, out);
	
	input[15:0] in;
	input opsel;	// A 0 means rotate left, a 1 means shift left
	wire [15:0] A,B,C;
	input [3:0] count;
	output [15:0] out;
	
	two_input_mux Shift1 [15:0] (.a(in), .b({in[14:0], ~opsel & in[15]}), .S(count[0]), .out(A));
	
	two_input_mux Shift2 [15:0] (.a(A), .b({A[13:0], {2{~opsel}} & A[15:14]}), .S(count[1]), .out(B));
	
	two_input_mux Shift3 [15:0] (.a(B), .b({B[11:0], {4{~opsel}} & B[15:12]}), .S(count[2]), .out(C));
	
	two_input_mux Shift4 [15:0] (.a(C), .b({C[7:0], {8{~opsel}} & C[15:8]}), .S(count[3]), .out(out));
	
endmodule
