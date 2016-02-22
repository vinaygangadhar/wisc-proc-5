// memory access module
module wisc_MEM(
        // inputs
        halt_in, mem_write_enable, mem_read_enable, change_PC_in, exception_in, exception_return_in, PC_offset_in, alu_result_in, write_data, clk, rst, 
        // outputs
        read_data, PC_offset_out, alu_result_out, change_PC_out, exception_out, exception_return_out, cache_done,
        mem_to_reg, halt_out, err, mem_stall
    );
    
	input	halt_in; 
    input   mem_write_enable;
	input   mem_read_enable;
    input   change_PC_in;   
    input   exception_in;    
    input   exception_return_in;        
    input   [15:0]  PC_offset_in;
    input   [15:0]  alu_result_in;
    input   [15:0]  write_data;

    input   clk;
    input   rst;
    
    output  [15:0]  read_data;
    output  [15:0]  PC_offset_out;
    output  [15:0]  alu_result_out;
    output  change_PC_out;
    output  mem_to_reg;
    output  exception_out;    
    output  exception_return_out;
    output  cache_done;
    output	halt_out;
	output	err; 
    output  mem_stall;

   
    assign PC_offset_out = PC_offset_in;
	assign alu_result_out = alu_result_in;
    assign change_PC_out = change_PC_in;
    assign exception_out = exception_in;
    assign exception_return_out = exception_return_in;
    assign halt_out = halt_in;
 
    wire err_temp, mem_done;
 
    // Inst data memory (address = alu_result) . 
    // This will also need a read/write signal control
    wire [15:0] addr_to_mem, data_to_mem, addr_delay, write_data_delay;
    mem_system memory(
        .DataOut(read_data), 
        .Done(mem_done), 
        .Stall(mem_stall_before), 
        .CacheHit(), 
        .err(err_temp), 
        .Addr(addr_to_mem), 
        .DataIn(data_to_mem), 
        .Rd(mem_read_enable), 
        .Wr(mem_write_enable), 
        .createdump(halt_out | err_temp), 
        .clk(clk), 
        .rst(rst)
    ); 
 
    assign mem_stall = mem_stall_before & ~mem_done;
 
    assign cache_done = mem_done;
 
    wire data_valid;
    dff_en read_hold [32:0] (
        .d({mem_read_enable,alu_result_in,write_data}),
        .q({data_valid,addr_delay,write_data_delay}),
        .clk(clk),
        .rst(rst),
        .en((mem_write_enable | mem_read_enable)) // get read, and only update value when cache is accepting input
    );
    
    dff err_delay(
        .d(err_temp),
        .q(err),
        .clk(clk),
        .rst(rst)
    );
    
    // this will store the new value on each read / write request to give the cache; necessary to pass testbench
    assign addr_to_mem = (mem_write_enable | mem_read_enable) ? alu_result_in : addr_delay;
    assign data_to_mem = (mem_write_enable | mem_read_enable) ? write_data : write_data_delay;
    // if request was a read, we will write to reg
    assign mem_to_reg = mem_done & ((mem_write_enable | mem_read_enable) ? mem_read_enable : data_valid);
 
endmodule
