module rf (
   // Outputs
   read1data, read2data, err, 
   // Inputs
   clk, rst, read1regsel, read2regsel, writeregsel, writedata, write
   );
   input clk, rst;
   input [2:0] read1regsel;
   input [2:0] read2regsel;
   input [2:0] writeregsel;
   input [15:0] writedata;
   input        write;

   output [15:0] read1data;
   output [15:0] read2data;
   output err;

   // your code, out and in array select them using the mux3_8_16b
   wire w0, w1, w2, w3, w4, w5, w6, w7;
   wire [127:0] outreg;
   decoder3_8 dec1(.in0(writeregsel[0]), .in1(writeregsel[1]), .in2(writeregsel[2]), .en(write), .out0(w0), .out1(w1), .out2(w2), .out3(w3), .out4(w4), .out5(w5), .out6(w6), .out7(w7));
   //use output of decoder as enable to 8 reg files.
   
   assign err=1'b0;
   
   reg16 regFile [7:0](.out16(outreg), .in16(writedata), .clk(clk), .rst(rst), .en({w7, w6, w5, w4, w3, w2, w1, w0}) );
   mux3_8_16b mux1(.in0(outreg[15:0]), .in1(outreg[31:16]), .in2(outreg[47:32]), .in3(outreg[63:48]), .in4(outreg[79:64]), .in5(outreg[95:80]), .in6(outreg[111:96]), .in7(outreg[127:112]), .sel(read1regsel), .out(read1data));
   mux3_8_16b mux2(.in0(outreg[15:0]), .in1(outreg[31:16]), .in2(outreg[47:32]), .in3(outreg[63:48]), .in4(outreg[79:64]), .in5(outreg[95:80]), .in6(outreg[111:96]), .in7(outreg[127:112]), .sel(read2regsel), .out(read2data));

   
   

endmodule

