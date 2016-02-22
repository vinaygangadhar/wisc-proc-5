// Instruction fetch
// Probably the second hardest unit just because it does a lot of stuff
// First stage, this will be the only module with a dff
module wisc_IF(
    // inputs
    halt, alu_result, change_PC, exception, exception_return, PC_offset, stall, clk, rst, 
    // outputs
    fetch_stall, PC_plus2, inst, err);

	input	halt;
    input   change_PC;
	input	exception, exception_return;
    input   [15:0]  PC_offset;
	input   [15:0] alu_result;
    input   stall;

    input   clk;
    input   rst;
    
    output  fetch_stall;
    output  [15:0]  PC_plus2;
    output  [15:0]  inst;
	output	err;



    wire [15:0] PC_curr, PC_temp, PC_temp2, PC_temp3, PC_next, inst_temp;
	wire [15:0] ePC_curr;
	wire [15:0] exception_address;
    // Instantiate mux, chooses between PC+2 or PC+offset (branch mux)
    
    two_input_mux PC_offsetz[15:0](
        .a(PC_plus2),
        .b(PC_offset),
        .S(change_PC), 
        .out(PC_temp)
    );
   
    two_input_mux PC_exception[15:0](
        .a(PC_temp),
        .b(16'h0002),
        .S(exception),
        .out(PC_temp2)
    );

    two_input_mux PC_return_exception[15:0](
        .a(PC_temp2),
        .b(ePC_curr),
        .S(exception_return),
        .out(PC_next)
    );

    // Instantiate PC flip-flop
    // Input will be output of the mux
    dff_en PC[15:0](
        .d(PC_next), 
        .q(PC_curr), 
        .clk(clk), 
        .rst(rst),
		.en(~halt & ~stall)
    );

    dff_en ePC[15:0](
        .d(PC_temp), 	// value of next PC before we check for exception
        .q(ePC_curr), 
        .clk(clk), 
        .rst(rst),
		.en(exception & ~halt)
    );
    
    // Instantiate PC+2 ALU (can this be optimized?)
    // We want to subtract 4 in the case of an exception instead.
    // This will be the value a non-pipelined PC + 2 would have been
    // 3 cycles ago 0010 0100 1011 1111100 ir 0000010
    wire [15:0] increment_PC;
    assign increment_PC = {{14{exception}},~exception,1'b0};
    
       cla16 add_2_to_PC(
		.inA(PC_curr), 
		.inB(increment_PC), 
		.cIn(1'b0), 
		.sum(PC_plus2), 
		.cOut()
	);

/*     memory2c inst_memory(
        .data_out(inst_temp), 
        .data_in(16'b0),    
        .addr(PC_curr),
        .enable(~halt),
        .wr(1'b0),         // instructions are set in stone
        .createdump(halt), // 'halt' makes this 1
        .clk(clk), 
        .rst(rst)
    ); */

    mem_system memory(
        .DataOut(inst_temp), 
        .Done(fetch_done), 
        .Stall(), 
        .CacheHit(), 
        .err(err), 
        .Addr(PC_curr), 
        .DataIn(16'b0), 
        .Rd(~halt), 
        .Wr(1'b0), 
        .createdump(halt), 
        .clk(clk), 
        .rst(rst)
    ); 
    
    assign fetch_stall = ~fetch_done;
    
	// When reset or stall is high, we want instruction to be noop
	two_input_mux reset_noop[15:0](
		.a(inst_temp),
		.b(16'h0800),
		.S(rst | fetch_stall),
		.out(inst)
	);

	
    
endmodule
