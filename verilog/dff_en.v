// If en is high, pass input value through
// If en is low, hold current value

module dff_en (q, d, clk, rst, en);

    output         q;
    input          d;
    input          clk;
    input          rst;
	input	   en;
	
	wire d_en;
	
	two_input_mux mux(.a(q), .b(d), .S(en), .out(d_en));
	
    dff dffz(.q(q), .d(d_en), .clk(clk), .rst(rst));

endmodule