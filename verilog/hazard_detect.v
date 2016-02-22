// This detects hazards.
// To do this, it checks Rs and Rt to see if they are
// reading from Rd before it is written to
// I still need to make sure they're being used though
module hazard_detect(
    // inputs
    opcode, Rd, Rs, Rt, hazard_cont, jump, jump_reg, jump_link, next_PC_control, branch, clk, rst, mem_to_reg, cache_stall, cache_done,
    // outputs
    Rd_delay2, Rd_delay3, write_en_delay3, stall, wipe, mem_write_en, mem_read_en,
    Rs_forward_MEM_EX, Rs_forward_WB_EX, Rt_forward_MEM_EX, Rt_forward_WB_EX
);

	parameter ST = 5'b10000;
	parameter LD = 5'b10001;
	parameter STU =  5'b10011;
    parameter LBI = 5'b11000;
    parameter SLBI =  5'b10010;	

    input [2:0] Rd, Rs, Rt;
    input clk, rst, cache_done;
    input branch;
    input hazard_cont;          // from execute
    input [4:0] opcode;
    input mem_to_reg, cache_stall;
    
    output mem_write_en, mem_read_en;
    output [2:0] Rd_delay3, Rd_delay2;
    output write_en_delay3, stall, wipe;
    output jump, jump_reg, jump_link;
    output next_PC_control;
    output Rs_forward_MEM_EX, Rs_forward_WB_EX;
    output Rt_forward_MEM_EX, Rt_forward_WB_EX;
    
    wire write_to_Rs;
    wire will_jump;
    wire jump_code;
    wire reg_write_en;
    wire use_Rs, use_Rt, use_Rd;
	wire hazard_cont_delay1;
    wire [2:0] Rd_delay0, Rd_delay1;
    wire Rs_hazard, Rt_hazard, Rd_hazard;
    
    // don't want to write, read, or jump if we're stalling
    assign next_PC_control = (opcode[4:2] == 3'b011) & ~wipe;
    assign mem_write_en = (opcode == ST  | opcode == STU) & ~wipe;
    assign mem_read_en = (opcode == LD) & ~wipe;
	// we do not want to write these cycles in case of a control hazard	or delay
    assign jump_code = (opcode[4:2] == 3'b001);
    assign jump_temp = (jump_code & ~opcode[0]);
    assign jump = jump_temp & ~wipe;    
    assign jump_reg_temp = jump_code & opcode[0];
    assign jump_reg = jump_reg_temp & ~wipe; 
	assign jump_link_temp = jump_code & opcode[1];
    assign jump_link = jump_link_temp & ~wipe;
	assign reg_write_en = (
	    opcode[4:1] != 4'b1000 //STORE and LD
	  & opcode[4:2] != 3'b011		// Branch
	  & opcode[4:1] != 4'b0010	// Jump and JR
	  & opcode[4:2] != 3'b000	// illegal and NOOP	and HALT
      & ~wipe
    );
 
	// we need to store control hazard signal for 2 cycles
	dff_en delay_hazard_control[1:0](
		.d({hazard_cont_delay1,hazard_cont}),
		.q({hazard_cont_delay2,hazard_cont_delay1}),
		.clk(clk),
		.rst(rst),
		.en(~cache_stall) // hold memory if stalling
	); 
	// here is the cycle we do not want to write in case of control hazard
	// hazard only is high for 1 cycle but we need to wipe next 3 cycles
    assign will_jump = (hazard_cont | hazard_cont_delay1 | hazard_cont_delay2); 
    assign wipe = will_jump | stall;

    
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
   
    // we only need Rs values for the instruction in these cases
    assign use_Rs = ((opcode[4:2] != 3'b000) 
                  & ~(opcode[4:2] == 3'b001 & ~opcode[0]))
                  | (opcode == SLBI) | (opcode == LD)
                  | jump_reg_temp;
    // we only need Rt values for the instruction in these cases     
    assign use_Rt = (opcode[4:3] == 2'b11) & (opcode[2:1] != 2'b00)
    | (opcode == ST) | (opcode == STU);
    
	// stores signals Rd and write_en for 3 cycles
    dff_en delay_Rd [8:0] (
		.d({Rd_delay2, Rd_delay1, Rd_delay0}),
		.q({Rd_delay3, Rd_delay2, Rd_delay1}),
		.clk(clk),
		.rst(rst),
		.en(~cache_stall)
	); 	
    // only the first... the second will only happen in the case of JAL        
    // however, we want to write unconditionally in this case
    wire write_en_delay1, write_en_delay2;
	dff_en delay_write_en [2:0] (
		.d({write_en_delay2 & ~cache_stall,write_en_delay1,reg_write_en}),
		.q({write_en_delay3, write_en_delay2, write_en_delay1}),
		.clk(clk),
		.rst(rst),
		.en({1'b1,{2{~cache_stall}}})
	); 	

    // -------------Memory Check--------------//
    // store whether we read from memory for 2 cycles
    wire mem_read_en_delay1;
	dff_en delay_mem_read [1:0] (
		.d({mem_read_en_delay1,mem_read_en}),
		.q({mem_read_en_delay2,mem_read_en_delay1}),
		.clk(clk),
		.rst(rst),
		.en(~cache_stall) // hold memory if stalling
	); 
    
    assign Rs_before_cache = use_Rs & (Rs == Rd_delay1 & mem_read_en_delay1);
    assign Rs_in_cache = use_Rs & (Rs == Rd_delay2 & (mem_read_en_delay2 &cache_stall));    
    assign Rs_forward_MEM_EX = use_Rs & (Rs == Rd_delay1 & write_en_delay1);
    assign Rs_forward_WB_EX = use_Rs & (Rs == Rd_delay2 & ((mem_read_en_delay2 & ~cache_stall) | write_en_delay2));

    assign Rt_before_cache = use_Rt & (Rt == Rd_delay1 & mem_read_en_delay1);
    assign Rt_in_cache = use_Rt & (Rt == Rd_delay2 & (mem_read_en_delay2 &cache_stall));    
    assign Rt_forward_MEM_EX = use_Rt & (Rt == Rd_delay1 & write_en_delay1);
    assign Rt_forward_WB_EX = use_Rt & (Rt == Rd_delay2 & ((mem_read_en_delay2 & ~cache_stall) | write_en_delay2));

    
    assign stall =
       (Rs_before_cache | Rs_in_cache | Rt_before_cache | Rt_in_cache & ~will_jump)
       | cache_stall;
    // we will never get to this instruction if PC
    // will change so we will never need to delay here
endmodule
