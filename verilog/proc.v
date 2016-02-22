/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   input clk;
   input rst;

   output err;

   // None of the above lines can be modified

   // OR all the err ouputs for every sub-module and assign it as this
   // err output
   
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines
   
   
   /* your code here */
	wire [4:0] err_subm;
	assign err = | err_subm;

      
    wire cache_stall, mem_stall, fetch_stall; 
    wire hazard_cont;

    assign cache_stall = mem_stall | fetch_stall;
    
    // Instantiate everything
    // All this top level should do is connect the 5 submodules together
    // Next stage, there will also be FFs
    
    // Wire Name Syntax: name_A_B
    // A is output of a module, B is input to another module
    // Next stage we'll change it so these are stored in FFs intermediately
    
    // From IF to ID
    wire [15:0] inst_IF_dff, inst_dff_ID;
    // IF to EX
    wire [15:0] PC_plus2_IF_dff, PC_plus2_dff_ID;
    wire [15:0] PC_plus2_ID_dff, PC_plus2_dff_EX;

    // From ID to EX
	wire check_overflow_ID_dff, check_overflow_dff_EX;
    wire ExtOp_ID_dff, ExtOp_dff_EX;
    wire ALU_Src_ID_dff, ALU_Src_dff_EX;
    wire [6:0] ALU_control_ID_dff, ALU_control_dff_EX;
    wire [15:0] immediate_ID_dff, immediate_dff_EX;
    wire [15:0] read_data1_ID_dff, read_data1_dff_EX;
    wire [15:0] read_data2_ID_dff, read_data2_dff_EX;   
    wire LBI_control_ID_dff, LBI_control_dff_EX;
    wire SLBI_control_ID_dff, SLBI_control_dff_EX;
    wire condition_ID_dff, condition_dff_EX;
    wire btr_control_ID_dff, btr_control_dff_EX;
	wire SEQ_cont_ID_dff, SEQ_cont_dff_EX;
	wire SLT_cont_ID_dff, SLT_cont_dff_EX;
	wire SLE_cont_ID_dff, SLE_cont_dff_EX;
	wire SCO_cont_ID_dff, SCO_cont_dff_EX;
    wire [1:0] branch_type_ID_dff, branch_type_dff_EX;
	wire jump_reg_ID_dff, jump_reg_dff_EX; 
    wire [1:0] Rs_select_ID_dff, Rt_select_ID_dff, Rs_select_dff_EX, Rt_select_dff_EX;
    wire next_PC_control_ID_dff, next_PC_control_dff_EX;
    // ID to MEM
    wire mem_write_enable_ID_dff, mem_write_enable_dff_EX;
    wire mem_write_enable_EX_dff, mem_write_enable_dff_MEM;
	wire mem_read_enable_ID_dff, mem_read_enable_dff_EX;
	wire mem_read_enable_EX_dff, mem_read_enable_dff_MEM;
    // ID to WB
    wire mem_to_reg_MEM_dff, mem_to_reg_dff_WB;
    // ID to IF
	wire exception_ID_dff, exception_dff_EX;
	wire exception_EX_dff, exception_dff_MEM;
	wire exception_MEM_IF;
	wire exception_return_ID_dff, exception_return_dff_EX;
	wire exception_return_EX_dff, exception_return_dff_MEM;
	wire exception_return_MEM_IF;
    // halt
    wire halt_ID_dff, halt_dff_EX;     
    wire halt_EX_dff, halt_dff_MEM;
    wire halt_MEM_dff, halt_dff_WB;
    wire halt_WB_IF;
          
        
    // From EX to MEM
    wire [15:0] write_data_mem_EX_dff, write_data_mem_dff_MEM;

    // EX to IF
    wire [15:0] alu_result_EX_dff, alu_result_dff_MEM, alu_result_dff_WB;
    wire [15:0] alu_result_MEM_IF;
    wire [15:0] PC_offset_EX_dff, PC_offset_dff_MEM;
    wire [15:0] PC_offset_MEM_IF;  
    wire change_PC_EX_dff, change_PC_dff_MEM;
    wire change_PC_MEM_IF; 
    // From MEM to WB
    wire [15:0] read_data_MEM_dff, read_data_dff_WB;
    
    // WB to ID
    wire [15:0] write_data_reg_WB_ID;
    
    // we want our reset to cycle through the modules individually
    wire [2:0] rst_shift;
    dff rst_through[2:0](
        .d({(rst_shift[1:0]|{2{rst}}),rst}),
        .q(rst_shift),
        .clk(clk),
        .rst(1'b0)
    );
    
    wisc_IF fetch(
        // inputs
		.halt(halt_WB_IF),
		.alu_result(alu_result_MEM_IF),
        .change_PC(change_PC_MEM_IF),
		.exception(exception_MEM_IF), 
		.exception_return(exception_return_MEM_IF),
        .PC_offset(PC_offset_MEM_IF),
        .stall(stall),
        .clk(clk),
        .rst(rst),
        // outputs
        .fetch_stall(fetch_stall),
        .PC_plus2(PC_plus2_IF_dff),
        .inst(inst_IF_dff),
		.err(err_subm[0])
    );
 
	dff_en IF_ID [15:0] (
		.d(PC_plus2_IF_dff),
		.q(PC_plus2_dff_ID),
		.clk(clk),
		.rst(rst),
		.en(~stall)
	);

	dff_en IF_ID_special [15:0] (
		.d(rst ? 16'h0800 : inst_IF_dff),
		.q(inst_dff_ID),
		.clk(clk),
		.rst(1'b0),
		.en(~stall | rst)
	);
    
    wisc_ID decode(
        // inputs
        .inst(inst_dff_ID), 
        .PC_plus2_in(PC_plus2_dff_ID), 
        .write_data(write_data_reg_WB_ID),
        .hazard_cont(hazard_cont),
		.clk(clk),
		.rst(rst_shift[0]),
        .cache_stall(cache_stall),
        .fetch_stall(fetch_stall),
        .cache_done(cache_done),
        .mem_to_reg(mem_to_reg_dff_ID),
        // outputs      
        .immediate(immediate_ID_dff), 
        .read_data1(read_data1_ID_dff),
        .read_data2(read_data2_ID_dff), 
        .PC_plus2_out(PC_plus2_ID_dff),
        .jump_link(jump_link_ID_dff),
        .jump_reg(jump_reg_ID_dff),
        .jump(jump_ID_dff),
        .LBI_control(LBI_control_ID_dff),
        .SLBI_control(SLBI_control_ID_dff),
        .ALU_Src(ALU_Src_ID_dff),
        .ALU_control(ALU_control_ID_dff),
        .mem_write_enable(mem_write_enable_ID_dff),
		.mem_read_enable(mem_read_enable_ID_dff),
		.halt(halt_ID_dff),
        .branch(branch_ID_dff),
        .condition(condition_ID_dff),
		.check_overflow(check_overflow_ID_dff),
		.btr_control(btr_control_ID_dff),
		.SEQ_cont(SEQ_cont_ID_dff), 
		.SLT_cont(SLT_cont_ID_dff), 
		.SLE_cont(SLE_cont_ID_dff), 
		.SCO_cont(SCO_cont_ID_dff),
		.exception(exception_ID_dff), 
		.exception_return(exception_return_ID_dff),
		.stall(stall),
		.err(err_subm[1]),
        .Rs_select(Rs_select_ID_dff),
        .Rt_select(Rt_select_ID_dff),
        .branch_type(branch_type_ID_dff),
        .next_PC_control(next_PC_control_ID_dff)
    );
 
	dff_en ID_EX [95:0] (
		.d({Rs_select_ID_dff, Rt_select_ID_dff,
        immediate_ID_dff,read_data1_ID_dff,read_data2_ID_dff,PC_plus2_ID_dff,jump_link_ID_dff,jump_reg_ID_dff, jump_ID_dff, LBI_control_ID_dff, SLBI_control_ID_dff,ALU_Src_ID_dff,ALU_control_ID_dff,mem_write_enable_ID_dff,mem_read_enable_ID_dff,halt_ID_dff,condition_ID_dff,check_overflow_ID_dff,btr_control_ID_dff,SEQ_cont_ID_dff,SLT_cont_ID_dff,SLE_cont_ID_dff,SCO_cont_ID_dff,exception_ID_dff,exception_return_ID_dff,
        branch_type_ID_dff,next_PC_control_ID_dff}),
		.q({Rs_select_dff_EX, Rt_select_dff_EX,
        immediate_dff_EX,read_data1_dff_EX,read_data2_dff_EX,PC_plus2_dff_EX,jump_link_dff_EX,jump_reg_dff_EX, jump_dff_EX, LBI_control_dff_EX, SLBI_control_dff_EX,ALU_Src_dff_EX,ALU_control_dff_EX,mem_write_enable_dff_EX,mem_read_enable_dff_EX,halt_dff_EX,condition_dff_EX,check_overflow_dff_EX,btr_control_dff_EX,SEQ_cont_dff_EX,SLT_cont_dff_EX,SLE_cont_dff_EX,SCO_cont_dff_EX,exception_dff_EX,exception_return_dff_EX,
        branch_type_dff_EX,next_PC_control_dff_EX}),
		.clk(clk),
		.rst(rst),
		.en(~cache_stall)
	); 	
 
    wisc_EX execute(
        // inputs
		.check_overflow(check_overflow_dff_EX),
        .LBI_control(LBI_control_dff_EX), 
        .SLBI_control(SLBI_control_dff_EX),
        .ALU_Src(ALU_Src_dff_EX),
        .ALU_control(ALU_control_dff_EX),
        .mem_write_enable_in(mem_write_enable_dff_EX),
		.mem_read_enable_in(mem_read_enable_dff_EX),
        .jump_link(jump_link_dff_EX),
        .jump_reg(jump_reg_dff_EX), 
        .jump(jump_dff_EX),
        .exception_in(exception_dff_EX), 
        .exception_return_in(exception_return_dff_EX), 
        .read_data1(read_data1_dff_EX),
        .read_data2(read_data2_dff_EX),
        .immediate(immediate_dff_EX),
        .condition(condition_dff_EX),
		.SEQ_cont(SEQ_cont_dff_EX), 
		.SLT_cont(SLT_cont_dff_EX), 
		.SLE_cont(SLE_cont_dff_EX), 
		.SCO_cont(SCO_cont_dff_EX),
        .btr_control(btr_control_dff_EX),
        .PC_plus2(PC_plus2_dff_EX),
        .halt_in(halt_dff_EX | err),
        .Rs_select(Rs_select_dff_EX),
        .Rt_select(Rt_select_dff_EX),
        .Rd_MEM(alu_result_dff_MEM),
        .Rd_WB(write_data_reg_WB_ID),
        .branch_type(branch_type_dff_EX),
        .next_PC_control(next_PC_control_dff_EX),
        // outputs    
        .alu_result(alu_result_EX_dff),
        .write_data(write_data_mem_EX_dff),
        .PC_offset(PC_offset_EX_dff),
        .mem_write_enable_out(mem_write_enable_EX_dff),
		.mem_read_enable_out(mem_read_enable_EX_dff),
        .change_PC(change_PC_EX_dff),
        .exception_out(exception_EX_dff), 
        .exception_return_out(exception_return_EX_dff),      
        .halt_out(halt_EX_dff),  
        .hazard_cont(hazard_cont),        
        .zero(),
        .err(err_subm[2])
    );

	dff_en EX_MEM [51:0] (
		.d({alu_result_EX_dff,write_data_mem_EX_dff,PC_offset_EX_dff,change_PC_EX_dff,exception_EX_dff,exception_return_EX_dff,halt_EX_dff}),
		.q({alu_result_dff_MEM,write_data_mem_dff_MEM,PC_offset_dff_MEM,change_PC_dff_MEM,exception_dff_MEM,exception_return_dff_MEM,halt_dff_MEM}),
		.clk(clk),
		.rst(rst),
		.en(~cache_stall)
	); 
    
  	dff_en EX_MEM_stall [1:0] (
		.d({mem_write_enable_EX_dff & ~mem_stall,mem_read_enable_EX_dff & ~mem_stall}),
		.q({mem_write_enable_dff_MEM,mem_read_enable_dff_MEM}),
		.clk(clk),
		.rst(rst),
		.en(
            (~mem_stall | mem_write_enable_dff_MEM | mem_read_enable_dff_MEM)
            & ~fetch_stall
    )   );   
 
    wisc_MEM memory(
        // inputs
		.halt_in(halt_dff_MEM),
        .mem_write_enable(mem_write_enable_dff_MEM & ~fetch_stall),
		.mem_read_enable(mem_read_enable_dff_MEM & ~fetch_stall), 
        .change_PC_in(change_PC_dff_MEM), 
        .exception_in(exception_dff_MEM), 
        .exception_return_in(exception_return_dff_MEM), 
        .PC_offset_in(PC_offset_dff_MEM),
        .alu_result_in(alu_result_dff_MEM), 
        .write_data(write_data_mem_dff_MEM), 
        .clk(clk),
        .rst(rst_shift[2]),
        // outputs
        .read_data(read_data_MEM_dff), 
        .PC_offset_out(PC_offset_MEM_IF),
        .alu_result_out(alu_result_MEM_IF),
        .mem_to_reg(mem_to_reg_MEM_dff), 
        .change_PC_out(change_PC_MEM_IF),
		.exception_out(exception_MEM_IF), 
		.exception_return_out(exception_return_MEM_IF),
		.halt_out(halt_MEM_dff),
        .mem_stall(mem_stall),
        .cache_done(cache_done),
		.err(err_subm[3])
    );

	dff_en MEM_WB (
		.d(mem_to_reg_MEM_dff),
		.q(mem_to_reg_dff_ID),
		.clk(clk),
		.rst(rst),
		.en(1'b1)
	); 
    
	dff_en MEM_WB_stuff [16:0] (
		.d({read_data_MEM_dff,mem_to_reg_MEM_dff}),
		.q({read_data_dff_WB,mem_to_reg_dff_WB}),
		.clk(clk),
		.rst(rst),
		.en(~cache_stall | mem_to_reg_MEM_dff)
	); 

    dff_en MEM_WB_delay [16:0] (
		.d({alu_result_MEM_IF,halt_MEM_dff}),
		.q({alu_result_dff_WB,halt_dff_WB}),
		.clk(clk),
		.rst(rst),
		.en(~cache_stall)
	); 
    
    wisc_WB write(
        // inputs
        .halt_in(halt_dff_WB),
        .mem_to_reg(mem_to_reg_dff_WB),
        .read_data(read_data_dff_WB), 
        .alu_result(alu_result_dff_WB), 
        // outputs
        .halt_out(halt_WB_IF),
        .write_data(write_data_reg_WB_ID),
		.err(err_subm[4])
    );
    
    
endmodule // proc
// DUMMY LINE FOR REV contROL :0:
