module pfa (inA, inB, gen, propogate);

input inA;
input inB;
output gen;
output propogate;



assign propogate = inA | inB;
assign gen = inA & inB;


endmodule

