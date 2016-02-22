module mem_read(clk, rst, next_state, index, done); 
	input next_state;
	input clk, rst;


	output [1:0] index;
	output done;

	wire [4:0] count_in, count_out;
	wire [4:0] next_count;
	assign next_count = count_out << 1;
	assign count_in = next_state ? next_count: 5'b00001;
	dff countFF [4:0](.q(count_out), .d(count_in), .clk(clk), .rst(1'b0));

	wire [1:0]index1, index2;
	two_input_mux i1 [1:0](
			.a(2'b00), 
			.b(2'b01), 
			.S(count_out[2]), 
			.out(index1)
	);

   two_input_mux i2 [1:0](
			.a(index1), 
			.b(2'b10), 
			.S(count_out[3]), 
			.out(index2)
	);

	two_input_mux i3 [1:0](
			.a(index2), 
			.b(2'b11), 
			.S(count_out[4]), 
			.out(index)
	);

	
    assign done = count_out[4];

endmodule
