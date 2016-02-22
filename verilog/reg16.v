module reg16(out16, in16, clk, rst, en);

output [15:0] out16;
input [15:0] in16;
input clk, rst, en;
wire [15:0] hold;

dff_en dffs16 [15:0](.q(out16), .d(in16), .clk(clk), .rst(rst), .en(en));

endmodule