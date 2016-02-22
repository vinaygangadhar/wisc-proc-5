module two_input_mux (a, b, S, out);

	input a, b, S;
	output out;

	assign out = (a & ~S) | (b & S);



endmodule
