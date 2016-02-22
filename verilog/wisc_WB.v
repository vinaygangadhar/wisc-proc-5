// write back module
module wisc_WB(
		// inputs
		halt_in, mem_to_reg, read_data, alu_result, 
		// outputs
        halt_out, write_data, err);
    
    input	halt_in;
    input   mem_to_reg;
    input   [15:0]  read_data;
    input   [15:0]  alu_result;
    
    output	halt_out;
    output  [15:0]  write_data;
	output	err;

	assign halt_out = halt_in;

	// no error detection here
	assign err = 1'b0;
    
    // Instantiate a mux that controls whether we want ALU result or read data
    
	two_input_mux write_mux [15:0] (
        .a(alu_result),
        .b(read_data),
        .S(mem_to_reg),
        .out(write_data)
    );
    

endmodule 
