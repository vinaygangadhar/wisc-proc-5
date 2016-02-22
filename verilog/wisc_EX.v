// execute or address calculation module
module wisc_EX(
		// inputs
		check_overflow, LBI_control, SLBI_control, ALU_Src, ALU_control, mem_write_enable_in, mem_read_enable_in,  jump_link, jump_reg, jump, exception_in, exception_return_in, read_data1, read_data2, immediate, condition, SEQ_cont, SLE_cont, SLT_cont, SCO_cont, btr_control, PC_plus2, halt_in, Rs_select, Rt_select, 
        Rd_MEM, Rd_WB, branch_type, next_PC_control,
		// outputs
		alu_result, write_data, PC_offset, mem_write_enable_out, mem_read_enable_out, change_PC, exception_out, exception_return_out, halt_out, hazard_cont, zero, err);

  	input	check_overflow;	// used in overflow check    
    input   LBI_control;
	input	SLBI_control;
    input   ALU_Src;
    input   [6:0]	ALU_control;
    input   [1:0] branch_type;    
    input   mem_write_enable_in;
	input 	mem_read_enable_in;
    input   jump_link;    
    input   jump_reg;    
    input   jump;
    input   exception_in;    
    input   exception_return_in;   
    input   condition; //Chris
	input   SEQ_cont, SLE_cont, SLT_cont, SCO_cont;
    input   [15:0]  read_data1, read_data2;
    input   [15:0]  immediate;
    input   btr_control;
    input   [15:0]  PC_plus2;
    input	halt_in;
    input   next_PC_control;
    
    output  [15:0]  alu_result;
    output  [15:0]  write_data;
    output  [15:0]  PC_offset;
    output  mem_write_enable_out;
	output  mem_read_enable_out;
    output  change_PC;   
    output  exception_out;    
    output  exception_return_out;
    output	halt_out;
	output	zero;
	output	err;
	output  hazard_cont;
    
	// Error will occur in case of overflow, and if we are adding or subtracting
    wire [15:0] Rs_alu, Rt_alu;
	wire	PC_overflow, alu_overflow;
	assign err =  1'b0;    //(PC_overflow & next_PC_control) | (alu_overflow & check_overflow);
    
	wire 	[15:0]	PC_alu_result, alu_result_temp0, alu_result_temp1, alu_result_temp2, alu_result_temp3, alu_result_temp4;
    wire    [15:0]  btr_holder;
    wire    SEQ_control, SLT_control, SLE_control, SCO_control;
	wire    carry;
    
    assign mem_write_enable_out = mem_write_enable_in;
	assign mem_read_enable_out = mem_read_enable_in;
    assign exception_out = exception_in;
    assign exception_return_out = exception_return_in;
    wire hazard_int;
	assign halt_out = halt_in & ~hazard_int;
    wire branch;
    assign branch = next_PC_control & (
 		 ( (branch_type == 2'b00) & (Rs_alu == 16'h0000) ) |
         ( (branch_type == 2'b01) & (Rs_alu != 16'h0000) ) |
         ( (branch_type == 2'b10) & (Rs_alu[15] == 1'b1) ) |
         ( (branch_type == 2'b11) & (Rs_alu[15] != 1'b1) ) 
    ); 
    assign change_PC = branch | jump | jump_reg | jump_link;    
    // by this stage,we know whether we have a control hazard
    // it will occur if PC changes 
    assign hazard_int = change_PC | exception_in | exception_return_in;
    assign hazard_cont = hazard_int | halt_in;
       
///////////////////////////---PC Alu---//////////////////////
                     
    // Instantiate ALU with inputs sign left immediate (SL by 1) and PC+2, 
    //    output PC offset
	cla16 next_PC(
		.inA(PC_plus2), 
		.inB(immediate), 
		.cIn(1'b0), 
		.sum(PC_alu_result), 
		.cOut(PC_overflow)
	);
    // In the case of Jump Reg we instead want the main ALU result
    two_input_mux jump_reg_check[15:0](
		.a(PC_alu_result),
		.b(alu_result_temp0),
		.S(jump_reg),
		.out(PC_offset)
	);
    
///////////////////////////---Main Alu---//////////////////////
    
    //  Instantiate mux that controls whether offset or register data goes to main ALU
    
    input [15:0] Rd_MEM, Rd_WB;
    input [1:0] Rs_select;
    four_one_mux15 Rs_sel(
        .Out(Rs_alu), 
        .InA(read_data1), 
        .InB(Rd_WB), 
        .InC(Rd_MEM), 
        .InD(Rd_MEM), 
        .S(Rs_select)
    );
    
    input [1:0] Rt_select;
    wire [15:0] Rt_temp;
    four_one_mux15 Rt_sel(
        .Out(Rt_temp),
        .InA(Rd_MEM), 
        .InB(Rd_WB), 
        .InC(read_data2), 
        .InD(read_data2), 
        .S(Rt_select)
    );
    
    two_input_mux Rt_sel2[15:0](
        .a(Rt_temp),
        .b(immediate),
        .S(Rt_select == 2'b11 | mem_write_enable_in),
        .out(Rt_alu)
    );
    
    assign write_data = Rt_temp; // straight from Reg B

    
    // Instantiate ALU with result of mux along with read_data1, outputs to alu_result
    alu exec_add(
        .A(Rs_alu), 
        .B(Rt_alu), 
        .Cin(ALU_control[6]), 
        .Op(ALU_control[2:0]), 
        .invA(ALU_control[3]), 
        .invB(ALU_control[4]),
        .sign(ALU_control[5] | Rs_alu[15] | Rt_alu[15]),   //if top bit is set entering this is signed arithmetic  
        .Out(alu_result_temp0), 
		.c_out(carry),
        .Ofl(alu_overflow),
        .Z(zero)
    );    
    
    // We might instead want the next PC...
    two_input_mux jump_link_check[15:0](
		.a(alu_result_temp0),
		.b(PC_plus2),
		.S(jump_link),
		.out(alu_result_temp1)
	);
    
	// In cases LBI and SLBI, bypass ALU register

    two_input_mux LBI_mux[15:0](
        .a(alu_result_temp1),
        .b(immediate),
        .S(LBI_control),
        .out(alu_result_temp2)
    );

    two_input_mux SLBI_mux[15:0](
        .a(alu_result_temp2),
        .b({Rs_alu[7:0],immediate[7:0]}),
        .S(SLBI_control),
        .out(alu_result_temp3)
    );

	//now check for BTR
	assign btr_holder = {Rs_alu[0], Rs_alu[1], 
				  Rs_alu[2], Rs_alu[3],
				  Rs_alu[4], Rs_alu[5],
				  Rs_alu[6], Rs_alu[7],
				  Rs_alu[8], Rs_alu[9],
				  Rs_alu[10],Rs_alu[11],
				  Rs_alu[12],Rs_alu[13],
                  Rs_alu[14],Rs_alu[15]
                 };
	two_input_mux BTR_mux[15:0](
        .a(alu_result_temp3),
        .b(btr_holder),
        .S(btr_control),
        .out(alu_result_temp4)
    );

     //not done yet, need to check for SEQ, SLT, SLE, and SCO cases
    //  Chris
	assign SEQ_control = SEQ_cont ? (zero ? 1'b1 : 1'b0) : 1'b0;  
      //equivalent to if(condition)
      //                  if(zero)
	  //  					SEQ_control = 1'b1;
      //                  else
      //                     SEQ_control = 1'b0
     //not done yet, need to check for SEQ, SLT, SLE, and SCO cases
    //  Chris

    assign SLT_control = SLT_cont &  
         ( ((alu_result_temp1[15] != 1'b1 ) & (alu_result_temp1[14:0] != 15'd0) 
         | (Rs_alu[15] & ~Rt_alu[15])) & ~(~Rs_alu[15] & Rt_alu[15]) );
         //checks for positive answer
    assign SLE_control = SLE_cont ? (
			    ( ( alu_result_temp1[15] != 1'b1 | (Rs_alu[15] & ~Rt_alu[15]) | (Rs_alu[15] & ~Rt_alu[15]) ) & ~(~Rs_alu[15] & Rt_alu[15]) ) ? 1'b1: 1'b0) : 1'b0;
         //checks for positive or zero answer 
    assign SCO_control = SCO_cont ? (carry ? 1'b1 : 1'b0) : 1'b0;  //error signals a carry out in 
                                                                  //unsinged addition which is 
                                                                  //what will occur
    assign alu_result[15:0] =  condition ? 
        ( (SEQ_control | SLT_control | SLE_control | SCO_control) ? 16'd1: 16'd0 ) : alu_result_temp4;  
    //  if(condition)
    //     if(SEQ_control | SLT_control | SLE_control | SCO_control)
    //         alu_result = 1
    //     else
    //          alu_result = 0
    //   else 
    //       alu_result = alu_result_temp3


endmodule
