// This detects RAW hazards.
// To do this, it checks Rs and Rt to see if they are
// reading from Rd before it is written to
// I still need to make sure they're being used though
module hazard_detect_RAW(
    // inputs
    opcode, Rd, Rs, Rt, hazard_cont, jump, jump_reg, jump_link, next_PC_control, branch, clk, rst, 
    // outputs
    Rd_delay3, write_en_delay3, stall, wipe, mem_write_en, mem_read_en
);

	parameter ST = 5'b10000;
	parameter LD = 5'b10001;
	parameter STU =  5'b10011;
    parameter LBI = 5'b11000;
    parameter SLBI =  5'b10010;	

    input [2:0] Rd, Rs, Rt;
    input clk, rst;
    input branch;
    input hazard_cont;          // from execute
    input [4:0] opcode;
    
    output mem_write_en, mem_read_en;
    output [2:0] Rd_delay3;
    output write_en_delay3, stall, wipe;
    output jump, jump_reg, jump_link;
    output next_PC_control;
    
    wire write_to_Rs;
    wire jump_code;
    wire reg_write_en;
    wire use_Rs, use_Rt, use_Rd;
	wire hazard_cont_delay1;
    wire [2:0] Rd_delay0, Rd_delay1, Rd_delay2;
    wire write_en_delay1, write_en_delay2;
    wire Rs_hazard, Rt_hazard, Rd_hazard;
    wire write_en_hazard;
    
    // don't want to write, read, or jump if we're stalling
    assign next_PC_control = (opcode[4:2] == 3'b011) & ~stall & ~wipe;
    assign mem_write_en = (opcode == ST  | opcode == STU) & ~wipe & ~stall;
    assign mem_read_en = (opcode == LD) & ~stall & ~wipe;
	// we do not want to write these cycles in case of a control hazard	or delay
    assign jump_code = (opcode[4:2] == 3'b001);
    assign jump_temp = (jump_code & ~opcode[0]);
    assign jump = jump_temp & ~stall & ~wipe;    
    assign jump_reg_temp = jump_code & opcode[0];
    assign jump_reg = jump_reg_temp & ~stall & ~wipe; 
	assign jump_link_temp = jump_code & opcode[1];
    assign jump_link = jump_link_temp & ~stall & ~wipe;
	
    
    assign reg_write_en = (
	    opcode != 5'b10000 //STORE
	  & opcode[4:1] != 5'b10011	// STU
	  & opcode[4:2] != 3'b011		// Branch
	  & opcode[4:1] != 4'b0010	// Jump and JR
	  & opcode[4:2] != 3'b000	// illegal and NOOP	and HALT
	);
	assign write_en_hazard = reg_write_en & ~stall & ~wipe;
	// we need to store control hazard signal for 2 cycles
	dff_en delay_hazard_control[1:0](
		.d({hazard_cont_delay1,hazard_cont}),
		.q({hazard_cont_delay2,hazard_cont_delay1}),
		.clk(clk),
		.rst(rst),
		.en(1'b1) // hold memory if stalling
	); 
	// here is the cycle we do not want to write in case of control hazard
	// hazard only is high for 1 cycle but we will need to wipe next cycle too
    // since IF already has an instruction
    assign wipe = (hazard_cont | hazard_cont_delay1 | hazard_cont_delay2); // unless we're stalling

    
        ///one more for STU, Chris
        // We need Rd for hazard detection so this is necessary
    assign write_to_Rs = (opcode == STU)  
					| (opcode == LBI)
					| (opcode == SLBI);

    two_input_mux Rs_logic[2:0](
        .a(Rd), 
        .b(Rs), 
        .S(write_to_Rs),
        .out(Rd_delay0)
    );
	// stores signals Rd and write_en for 3 cycles
    dff_en delay_Rd [8:0] (
		.d({Rd_delay2, Rd_delay1, Rd_delay0}),
		.q({Rd_delay3, Rd_delay2, Rd_delay1}),
		.clk(clk),
		.rst(rst),
		.en(1'b1)
	); 	
    


    // only the first... the second will only happen in the case of jump and link
        // however, we want to write unconditionally in this case
    
	dff_en delay_write_en [2:0] (
		.d({write_en_delay2,write_en_delay1,write_en_hazard}),
		.q({write_en_delay3, write_en_delay2, write_en_delay1}),
		.clk(clk),
		.rst(rst),
		.en(1'b1)
	); 	

    // we only need Rs values for the instruction in these cases
    assign use_Rs = ((opcode[4:2] != 3'b000) 
                  & ~(opcode[4:2] == 3'b001 & ~opcode[0]))
                  | (opcode == SLBI) | (opcode == LD)
                  | jump_reg_temp;
    // we only need Rt values for the instruction in these cases     
    assign use_Rt = (opcode[4:3] == 2'b11) 
                  & (opcode[2:1] != 2'b00);
    // in the case store, we need Rd...
    assign use_Rd = (opcode == ST) | (opcode == STU);
    
    // read-after-write hazards will occer if we use Rs
    assign Rs_hazard = use_Rs & (
        // and the reg's value will be updated in 2 cycles
        (Rs == Rd_delay1 & write_en_delay1) 
    |   (Rs == Rd_delay2 & write_en_delay2)
    );
    assign Rt_hazard = use_Rt & ((Rt == Rd_delay1 & write_en_delay1) 
                              |  (Rt == Rd_delay2 & write_en_delay2));
    assign Rd_hazard = use_Rd & ((Rd == Rd_delay1 & write_en_delay1) 
                              |  (Rd == Rd_delay2 & write_en_delay2));

    assign stall = (Rs_hazard | Rt_hazard | Rd_hazard) & ~wipe;
    // we will never get to this instruction if PC
    // will change so we will never need to delay here
endmodule
