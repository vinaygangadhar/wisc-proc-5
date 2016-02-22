module rf_bypass (
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
   
   wire [15:0] read1holder, read2holder;
   
   rf rf0(
          // Outputs
          .read1data                    (read1holder[15:0]),
          .read2data                    (read2holder[15:0]),
          .err                          (err),
          // Inputs
          .clk                          (clk),
          .rst                          (rst),
          .read1regsel                  (read1regsel[2:0]),
          .read2regsel                  (read2regsel[2:0]),
          .writeregsel                  (writeregsel[2:0]),
          .writedata                    (writedata[15:0]),
          .write                        (write));
          
 assign read1data = (write & (read1regsel == writeregsel)) ?  writedata: read1holder;
 assign read2data = (write & (read2regsel == writeregsel)) ?  writedata: read2holder;
 
 endmodule
