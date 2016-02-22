module ALU_control_decode(jump, opcode, funct, ALU_control, condition);

	input	jump;
	input	[4:0]	opcode;
	input	[1:0]	funct;
	output	[6:0]	ALU_control;
	output condition;  //I need this passed to execute stage as a control
                        // signal--Chris
	// bits 2 to 0 are ALU opcode
	// bits 3 and 4 are invA and invB
	// bit 5 is sign
	// bit 6 is Cin


	wire R_Type;
	wire [2:0] temp1_ALU_control, set_temp, temp2_ALU_control, temp3_ALU_control;
	wire condition, condition_sub, condition_add;


	assign R_Type = &opcode[4:3];




	two_input_mux ALU_decode[2:0](
		.a({opcode[3],opcode[1:0]}),
		.b({opcode[0],funct}), 
		.S(R_Type), // R-Type if first 2 instruction bits are 1
		.out(temp1_ALU_control)
	);

//--------------------deal with set and jump instructions-----------------------

    // Determine whether it's SEQ, SLT, or SLE; and thus appropriate add or sub
	assign condition = & opcode[4:2];
	assign condition_add = condition & (&opcode[1:0]);
	assign condition_sub = condition & (~condition_add);
	
	two_input_mux set_add[2:0](
		.a(temp1_ALU_control),
		.b(3'b100),
		.S(condition_add | jump),  //suspect
		.out(set_temp)
	);

	two_input_mux set_sub[2:0](
		.a(set_temp),
		.b(3'b101),
		.S(condition_sub),
		.out(temp2_ALU_control)
	);

//------------------------------------------------------------------------------

	// this mux changes OR to ADD (so we can perform SUB instruction)
	two_input_mux ALU_assign[2:0](
		.a(temp2_ALU_control),
		.b(3'b100),
		.S((temp2_ALU_control == 3'b101) | (opcode[4:2] == 3'b100)),  //now handles loads and stores: Chris
		.out(ALU_control[2:0])  //this is ALU_control[2:0] Chris
	);

    



	// Invert first input in case of SUB
	assign ALU_control[3] = (temp2_ALU_control == 3'b101);
	// Add 1 to make first input 2Sc
	assign ALU_control[6] = (temp2_ALU_control == 3'b101);
	// Signed
	assign ALU_control[5] = (temp2_ALU_control == 3'b101);



	// All ANDS negate second input
	assign ALU_control[4] = (ALU_control[2:0] == 3'b111);

endmodule
