/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

module mem_system(/*AUTOARG*/
   // Outputs
   DataOut, Done, Stall, CacheHit, err, 
   // Inputs
   Addr, DataIn, Rd, Wr, createdump, clk, rst
   );
   
   input [15:0] Addr;
   input [15:0] DataIn;
   input        Rd;
   input        Wr;
   input        createdump;
   input        clk;
   input        rst;
   
   output [15:0] DataOut;
   output Done;
   output Stall;
   output CacheHit;
   output err;

   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter mem_type = 0;
   wire [5:0] cur, next;  //for state machine
   wire [1:0] mr_index, mw_index;

   wire m_err;
   
   wire c_enable;
   wire c_comp;
   wire c_write;
   wire c_valid_in;
   wire [4:0] c0_tag_out,c1_tag_out,c_tag_out;
   wire [15:0] c0_data_out,c1_data_out,c_data_out;
   wire c0_hit,c1_hit,c_hit;
   wire c0_dirty,c1_dirty,c_dirty;
   wire c0_valid,c1_valid,c_valid;
   wire c0_err,c1_err;
   wire [15:0] data_valid_in;
   wire [15:0] addr_valid_in;	
	
///////////////////////////////////////////////////////////////////////////////
//Outputs
	assign DataOut = c_data_out;
	assign CacheHit = c_hit & cur[0] & c_valid;
	assign err = (m_err | c0_err | c1_err) & (cur[0] & (Rd | Wr));
	assign Stall = cur[1] | cur[2] | cur[3] | cur[4] | cur[5] | (cur[0] & (Rd|Wr) & ~(c_hit & c_valid)) ;
///////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
//Sets up read flip flop: 1 = Read, 0 = Write
   wire read_st, next_read;
   assign next_read = (cur[0] & (Rd | Wr) & ~(c_hit & c_valid)) ? Rd: 1'b0; 
   //cleared in state 5, set in state 0: only two states enabled
   dff_en read_ff(.q(read_st), .d(next_read), .clk(clk), .rst(rst), .en(cur[0]));
//////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////
//Stores address in and data when necessary
	wire [15:0] d_inFF, addr_inFF;
	wire d_in_en, addr_in_en;
	//only enable when in state 0 and write and miss
	assign d_in_en = cur[0] & Wr & ~(c_hit & c_valid);
	dff_en data_inFF1 [15:0](.q(d_inFF), .d(DataIn), .clk(clk), .rst(rst), .en(d_in_en));
	
	assign addr_in_en = cur[0] & (Wr|Rd) & ~(c_hit & c_valid);
	dff_en data_inFF2 [15:0](.q(addr_inFF), .d(Addr), .clk(clk), .rst(rst), .en(addr_in_en));
///////////////////////////////////////////////////////////////////////////////////////////
   
   assign c_enable = (cur[0] & (Rd | Wr)) |
					cur[1] | cur[4] | cur[5];
    assign c_comp = cur[0] | cur[5];
	assign c_write = (cur[0] & Wr) | (cur[5] & ~read_st) | cur[4] ;
	assign c_valid_in = cur[4];
	assign Done = c_hit & c_valid & (cur[0] | cur[5]) & c_enable & ~err;

	wire [15:0] address_St;
	wire [15:0] data_St;
    //only want inputs when in state 0, otherwise stored value
	assign address_St = cur[0] ? Addr: addr_inFF;
	
//////////////////////////////////////////////////////////////////////////////////////////
//gets the right data to the cache
	wire [1:0] aw_index;
	wire [15:0] m_data_out;
    wire [15:0] data_St1, data_St2, data_St3, data_St4;
	wire [15:0] mem_hold1, mem_hold2,  mem_hold3;  
	
    assign data_St1 = cur[0] ? DataIn: d_inFF;
	assign data_St2 = (cur[4] & (aw_index == 2'b11)) ? m_data_out: data_St1; 
	assign data_St3 = (cur[4] & (aw_index == 2'b10)) ? mem_hold3: data_St2; 
	assign data_St4 = (cur[4] & (aw_index == 2'b01)) ? mem_hold2: data_St3;
	assign data_St = (cur[4] & (aw_index == 2'b00)) ? mem_hold1: data_St4;
///////////////////////////////////////////////////////////////////////////////////////////
	wire [2:0] cache_index;
	
	wire c1_write, c2_write;

    cache #(0+mem_type) cache0(
              .enable(c_enable),
              .clk(clk),
              .rst(rst),
              .createdump(createdump),
              .tag_in(address_St[15:11]),
              .index(address_St[10:3]),
              .offset(cache_index),
              .data_in(data_St),
              .comp(c_comp),
              .write(c0_write),
              .valid_in(c_valid_in),

              .tag_out(c0_tag_out),
              .data_out(c0_data_out),
              .hit(c0_hit),
              .dirty(c0_dirty),
              .valid(c0_valid),
              .err(c0_err)
              );
              
    cache #(2+mem_type) cache1(
              .enable(c_enable),
              .clk(clk),
              .rst(rst),
              .createdump(createdump),
              .tag_in(address_St[15:11]),
              .index(address_St[10:3]),
              .offset(cache_index),
              .data_in(data_St),
              .comp(c_comp),
              .write(c1_write),
              .valid_in(c_valid_in),

              .tag_out(c1_tag_out),
              .data_out(c1_data_out),
              .hit(c1_hit),
              .dirty(c1_dirty),
              .valid(c1_valid),
              .err(c1_err)
              );

	//-----------logic to determine which cache to victimize---------------//

	
	wire to_victimize;
	dff_en victimway(
		.d(~to_victimize),
		.q(to_victimize),
		.clk(clk),
		.rst(rst),
		.en(Done)    // will invert on each read or write of cache
	);

	// valid bit for: c0 c1 victimize
	//                 0  0  0
	//                 0  1  0	
	//                 1  0  1
	//                 1  1  v_sel

	reg v_sel;
	always @ (c0_valid or c1_valid or to_victimize)
	casex ({c0_valid,c1_valid})
		2'b0? : v_sel = 1'b0;
		2'b10 : v_sel = 1'b1;
		2'b11 : v_sel = to_victimize;
	endcase

	wire v_sel_en;

	dff_en v_en(
		.d(v_sel),
		.q(v_sel_temp),
		.clk(clk),
		.rst(rst),
		.en(cur[0] & (Rd | Wr))  // will only update when we read the valid or hit bits
	);	
    
    assign v_sel_en = cur[0] & (Rd | Wr) ? v_sel : v_sel_temp;
    
    

	wire data_output;
	// only want to select from cache 1 if it's a hit and valid
	assign data_output = c1_hit & c1_valid;

	assign c_hit = (c0_hit & c0_valid) | (c1_hit & c1_valid);


    
	// cache select will either need to pass compare read through
	// or do victimize logic
	two_input_mux select_cache(
		.a(v_sel_en),
		.b(data_output),
		.S(c_valid),
		.out(c_sel)
	);

	two_input_mux cache_sel [22:0] (
		.a({c0_tag_out,c0_data_out,c0_dirty,c0_valid}),
		.b({c1_tag_out,c1_data_out,c1_dirty,c1_valid}),
		.S(c_sel),
		.out({c_tag_out,c_data_out,c_dirty,c_valid})
	);

	// pass write through on a comp; otherwise, use select
	assign c0_write = c_write & (c_comp | ~v_sel_en);
	assign c1_write = c_write & (c_comp | v_sel_en);

	wire [15:0] m_addr;
	wire [15:0] m_data_in;
	wire m_wr;
	wire m_rd;
	wire m_stall;
	wire [3:0] m_busy;
	
////////////////////////////////////////////////////////////////////////////
//calculates index for mem_reads	
    wire state_2;
	mem_write mw(.clk(clk), .rst(rst), 
				.next_state(next[1]), .index(mw_index), .done(state_2));

//calculates index for mem_writes
	wire [4:0] count;
	wire state_3;
	mem_read rw(.clk(clk), .rst(rst), 
				.next_state(next[2]), .index(mr_index), .done(state_3));
	//holds data coming out of mem_reads
	wire mem_hold1_en, mem_hold2_en,  mem_hold3_en;
	
	assign mem_hold1_en =  cur[2] & (mr_index == 2'b10);
	dff_en data_inFF3 [15:0](.q(mem_hold1), .d(m_data_out), .clk(clk), .rst(rst), .en(mem_hold1_en));
  
	assign mem_hold2_en =  cur[2] & (mr_index == 2'b11);
	dff_en data_inFF4 [15:0](.q(mem_hold2), .d(m_data_out), .clk(clk), .rst(rst), .en(mem_hold2_en));
    //this is the wait state
	assign mem_hold3_en =  cur[3];
	dff_en data_in [15:0](.q(mem_hold3), .d(m_data_out), .clk(clk), .rst(rst), .en(mem_hold3_en));
///////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
//select the index to use
	wire [1:0] mem_index;
		 two_input_mux mem_ind[1:0](
			.a(mw_index), 
			.b(mr_index), 
			.S(cur[2]), 
			.out(mem_index)
	);
	wire [2:0] cache_index_holder;
	wire c1_en;
	assign c1_en = cur[0] | cur[5];
	two_input_mux mem_indM1[2:0](
			.a({mem_index, 1'b0}), 
			.b(address_St[2:0]), 
			.S(c1_en), 
			.out(cache_index_holder)
	);

	 two_input_mux mem_indM2[2:0](
			.a(cache_index_holder), 
			.b({aw_index, 1'b0}), 
			.S(cur[4]), 
			.out(cache_index)
	);





//////////////////////////////////////////////////////////////////////////////


	wire [15:0] m_addr1, m_addr2;
	
	assign m_addr1 = {c_tag_out, address_St[10:3], mem_index, 1'b0};
	assign m_addr2 = {address_St[15:3], mem_index, 1'b0};
	assign m_addr = cur[1] ? m_addr1: m_addr2;

	assign m_data_in = c_data_out;
	assign m_wr = cur[1];
	assign m_rd = cur[2];
	four_bank_mem bank_4(
            .clk(clk),
			.rst(rst),
            .createdump(createdump),
			.addr(m_addr),
			.data_in(m_data_in),
			.wr(m_wr),
			.rd(m_rd),
			
			.data_out(m_data_out),
			.stall(m_stall),
			.busy(m_busy),
			.err(m_err)
);

///////////////////////////////////////////////////////////////////////////////
//one more loop for access write
		
		wire state_5;
		access_write aw(.clk(clk), .rst(rst), .next_state(next[4]), .index(aw_index), .done(state_5));

///////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////
//State machine logic
dff dffs[5:0](.d(next), .q(cur), .rst({rst,rst,rst,rst,rst,1'b0}), .clk(clk));
assign next[0] =  rst | cur[5] | (cur[0] &( (c_hit & c_valid) | (~Rd & ~Wr) ) );
assign next[1] = ( (cur[0] & ~c_hit & c_valid & c_dirty) | (cur[1] & ~state_2) )& ~rst;
assign next[2] = ( state_2 | (cur[2] & m_stall) | 
				(cur[0] & ( (~c_hit & c_valid & ~c_dirty) | (~c_valid & c_enable) ) )  | (cur[2] & ~state_3) ) & ~rst;
assign next[3] =  (state_3) & ~rst;
assign next[4] =  (cur[3] | (~state_5 & cur[4])) & ~rst;
assign next[5] =  state_5 & ~rst;
////////////////////////////////////////////////////////////////////////////////////

   
endmodule // mem_system

   


// DUMMY LINE FOR REV CONTROL :9:
