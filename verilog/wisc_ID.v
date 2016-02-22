module wisc_ID(
        // inputs
        clk, rst, inst, PC_plus2_in, 
        write_data, hazard_cont, cache_done,
        // outputs
        immediate, read_data1,read_data2, PC_plus2_out, jump, jump_link, jump_reg, LBI_control, SLBI_control, ALU_Src, ALU_control, mem_write_enable, mem_read_enable, mem_to_reg, fetch_stall, cache_stall, halt, branch, condition, check_overflow, btr_control, SEQ_cont, SLT_cont, SLE_cont, SCO_cont, exception, exception_return, stall, err, Rt_select, Rs_select, branch_type, next_PC_control
    );
            
    parameter HALT = 16'b00000;
    parameter NOP = 5'b00001;
    parameter ADDI = 5'b01000;       
    parameter XORI = 5'b01010;
    parameter ANDNI = 5'b01011;	parameter ST = 5'b10000;
	parameter LD = 5'b10001;
	parameter STU =  5'b10011;	
	parameter LBI =  5'b11000;	
	parameter SLBI = 5'b10010;
	parameter SEQ = 5'b11100;
	parameter SLT = 5'b11101;
	parameter SLE = 5'b11110;
	parameter SCO = 5'b11111;
	parameter SIIC = 5'b00010;
	parameter RTI = 5'b00011;
    
	input	clk;
	input 	rst;
    input   [15:0]  inst;
    input   [15:0]  PC_plus2_in;
    input   [15:0]  write_data;
    input   hazard_cont;            // logic to determine this is in ex
    input   mem_to_reg;
    input   fetch_stall, cache_stall, cache_done;
    
    output  [15:0]  immediate;
    output  [15:0]  read_data1, read_data2;
    output  [15:0]  PC_plus2_out;
    output  condition; // Chris, see alu_control
	output	check_overflow;
    output  next_PC_control;  //tells us if a jump or a branch is encountered, ovfl
	output  btr_control;
	output  SEQ_cont, SLT_cont, SLE_cont, SCO_cont;
	output	exception, exception_return;
	output	err;
    output jump_link;
	output jump_reg;
	output LBI_control;
	output SLBI_control;
    output ALU_Src; 
    output [6:0] ALU_control;
    output mem_write_enable;
	output mem_read_enable;    
	output halt;   
    output branch;
    output stall;
	output jump;
    
    wire [4:0] opcode;
    wire [1:0] funct;
    wire [2:0] Rs, Rd, Rt, Rd_temp, Rd_temp2; 
    wire [2:0] Rd_delay1, Rd_delay2, Rd_delay3; 
    wire reg_dest;
	wire write_to_Rs;
	wire [15:0] to_write;   
	wire [15:0] imm_SEXT, imm_16;
	wire immediate_select;     
    wire reg_write_enable_delay3;
    wire wipe;
    
    assign opcode = inst[15:11];
    assign funct = inst[1:0];
	assign err = 1'b0;
	assign btr_control = (opcode == 5'b11001);
    assign PC_plus2_out = PC_plus2_in;
	assign exception = (opcode == SIIC) & ~wipe;
	assign exception_return = (opcode == RTI) & ~wipe;
	//assign SEQ, SLT, SLE, & SCO controls
	assign SEQ_cont = (opcode == SEQ);
	assign SLT_cont = (opcode == SLT);
	assign SLE_cont = (opcode == SLE);
	assign SCO_cont = (opcode == SCO);

	assign LBI_control = (opcode == LBI);

	assign SLBI_control = (opcode == SLBI);

    output [1:0] branch_type;
    assign branch_type = inst[12:11];

	ALU_control_decode ALU_control_logic(
        .jump(jump_reg),
		.opcode(opcode), 
		.funct(funct), 
		.ALU_control(ALU_control),
        .condition(condition)
	);

	assign check_overflow = (
							(opcode == 5'b11011 & ~funct[1]) // instruction is ADD or SUB
				   			| opcode[4:1] == 4'b0100			 // ADDI or SUBI
							| jump_reg
							| opcode[4:2] == 3'b100
						);

			
	// obviously if we're changing the PC we're not going to halt here
	assign halt = (opcode == HALT) & ~rst & ~wipe;

    assign Rs = inst[10:8];
    assign Rt = inst[7:5];    

    assign reg_dest = (opcode[4:3] == 2'b11);    
    two_input_mux Rd_logic[2:0](
        .a(inst[7:5]),
        .b(inst[4:2]), 
        .S(reg_dest),
        .out(Rd_temp)
    );

    // What we need to do for a register jump
    assign Rd = Rd_temp | {3{jump_link}};

    // STU, LBI, SLBI detect moved to hazard detect
    // This is necessary because in STU we need both Rd and Rs

    // Here is the logic to see whether we have to stall (which it detects)
    // or not write memory (which it handles)
    wire Rs_forward_MEM_EX, Rs_forward_WB_EX;
    wire Rt_forward_MEM_EX, Rt_forward_WB_EX;
    hazard_detect reg_hazard (
        .Rd(Rd), 
        .Rs(Rs), 
        .Rt(Rt), 
        .branch(branch),
        .hazard_cont(hazard_cont),
        .jump(jump),
        .jump_reg(jump_reg),
        .jump_link(jump_link),
        .opcode(opcode),
        .wipe(wipe),
        .mem_to_reg(mem_to_reg),
        .cache_stall(cache_stall),
        .cache_done(cache_done),
        .clk(clk), 
        .rst(rst), 
        .mem_write_en(mem_write_enable),
        .mem_read_en(mem_read_enable),
        .next_PC_control(next_PC_control),
        .Rd_delay3(Rd_delay3), 
        .Rd_delay2(Rd_delay2),
        .write_en_delay3(reg_write_enable_delay3), 
        .stall(stall),
        .Rs_forward_MEM_EX(Rs_forward_MEM_EX), 
        .Rs_forward_WB_EX(Rs_forward_WB_EX), 
        .Rt_forward_MEM_EX(Rt_forward_MEM_EX), 
        .Rt_forward_WB_EX(Rt_forward_WB_EX)
    );

	assign ALU_Src = ((opcode[4:3] == 2'b11) & (opcode[2:0]!= 3'b000) );
    output [1:0] Rs_select;
    assign Rs_select = {Rs_forward_MEM_EX,Rs_forward_WB_EX};
    
    output reg [1:0] Rt_select;
    always @(ALU_Src or Rt_forward_WB_EX or Rt_forward_MEM_EX)
    casex ({Rt_forward_MEM_EX,Rt_forward_WB_EX,ALU_Src})
        3'b1?? : Rt_select = 2'b00;
        3'b01? : Rt_select = 2'b01;
        3'b001 : Rt_select = 2'b10;
        3'b000 : Rt_select = 2'b11;
    endcase

//------------------------------------------------------------------------------

    // Instantiate 16 bit wide register unit module with these values
        // 3 3-bit inputs: Rs, Rt, and Rd
        // 1 1-bit write enable
        // 1 16-bit input: Write data (from WB)
        // 2 16-bit outputs containing data from Rs and Rt
    
    wire [2:0] Rd_select;
    
    wire fetch_stall_delay1;
    
    assign Rd_select = (mem_to_reg & fetch_stall_delay1) ? Rd_delay2 : Rd_delay3;
    
    dff_en delay_Rd [2:0] (
		.d(fetch_stall),
		.q(fetch_stall_delay1),
		.clk(clk),
		.rst(rst),
		.en(1'b1)
	); 	
    
    rf_bypass reg_file(
        .read1regsel(Rs), 
        .read2regsel(Rt), 
        .writeregsel(Rd_select), 
        .write((reg_write_enable_delay3 | mem_to_reg)),
        .writedata(write_data),
        .read1data(read_data1),
        .read2data(read_data2),
		.err(),
        .clk(clk),
        .rst(rst)
    );

    assign immediate_select = (opcode[3:2] == 2'b11
                            | opcode[4:3] == 2'b00
                            | opcode == LBI
                            | opcode == SLBI);
    // sign extend with intermediate
    assign imm_SEXT[4:0] = inst[4:0];    
	two_input_mux imm_extend[2:0](
		.a({3{inst[4]}}),
		.b(inst[7:5]),
		.S(immediate_select),
		.out(imm_SEXT[7:5])
	);

    two_input_mux imm_extend2[15:8](
		.a({8{imm_SEXT[7]}}),
		.b({{5{inst[10]}},inst[10:8]}),
		.S(jump),
		.out(imm_SEXT[15:8])
	);
    
    // In the case of XORI and ANDI, we do not want sign extend
    
	two_input_mux imm_select2[15:0](
		.a(imm_SEXT),
		.b({11'b0,inst[4:0]}),
		.S(opcode[4:1] == 4'b0101),
		.out(immediate)
	);

    //Take care of branch control signal (n_Pc) for mux.  next_PC_control simply
    //signals whether the branch is taken or not.  The branch control signal
    //will tell us if the branch is take(1) or not (0). Not sure if this should
    // be in decode or execute.  Figured it would be quicker for pipelining
    // here tho because we don't need the alu result. --Chris

	// we also cannot branch when we're stalling for a RAW


endmodule
