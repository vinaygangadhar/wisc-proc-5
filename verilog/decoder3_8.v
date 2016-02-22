module decoder3_8(in0, in1, in2, en, out0, out1, out2, out3, out4, out5, out6, out7);

input in0, in1, in2, en;
output out0, out1, out2, out3, out4, out5, out6, out7;

assign out0 = ~in0 & ~in1 & ~in2 & en;
assign out1 = in0 & ~in1 & ~in2 & en;
assign out2 = ~in0 & in1 & ~in2 & en;
assign out3 = in0 & in1 & ~in2 & en;
assign out4 = ~in0 & ~in1 & in2 & en;
assign out5 = in0 & ~in1 & in2 & en;
assign out6 = ~in0 & in1 & in2 & en;
assign out7 = in0 & in1 & in2 & en;

endmodule


