module cla4(inA, inB, cIn, sum, c0);

input [3:0] inA;
input [3:0] inB;
input cIn;
output [3:0] sum;
output c0;
wire [3:0] gen, propogate;
wire [3:0] carry;

//get generates and propogates
pfa p1( .inA(inA[0]), .inB(inB[0]), .gen(gen[0]), .propogate(propogate[0]) );
pfa p2( .inA(inA[1]), .inB(inB[1]), .gen(gen[1]), .propogate(propogate[1]));
pfa p3( .inA(inA[2]), .inB(inB[2]), .gen(gen[2]), .propogate(propogate[2]));
pfa p4( .inA(inA[3]), .inB(inB[3]), .gen(gen[3]), .propogate(propogate[3]));

//perform lookahead logic after addition
assign carry[0] = (cIn & propogate[0]) | (gen[0]) ;
assign carry[1] = (cIn & propogate[0] & propogate[1]) | (gen[0] & propogate[1]) | gen[1];
assign carry[2] = gen[2] | (propogate[2] & gen[1]) | (propogate[2] & propogate[1] & gen[0]) | (propogate[2] & propogate[1] & propogate[0] & cIn);
assign c0 =  (cIn & propogate[0] & propogate[1] & propogate[2] & propogate[3]) | (gen[0] & propogate[3] & propogate[2] & propogate[1]) | (gen[1] & propogate[3] & propogate[2]) | (propogate[3] & gen[2]) | gen[3];

//now compute sum bits
assign sum[0] = inA[0] ^ inB[0] ^ cIn;
assign sum[1] = inA[1] ^ inB[1] ^ carry[0];
assign sum[2] = inA[2] ^ inB[2] ^ carry[1];
assign sum[3] = inA[3] ^ inB[3] ^ carry[2];



endmodule

