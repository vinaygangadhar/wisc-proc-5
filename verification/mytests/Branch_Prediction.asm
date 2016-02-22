// Test of effects of branch prediction (assuming not taken)
// Authors: Chris Aberger and Michael Sartin-Tarm (Team Rippers)

lbi r0, 4
lbi r2, 2

// This tests optimization to a certain point as well
// If program doesn't ignore branches of less than 6, we will witness stalls
// Expected CPI: 1 + (cycles of stalls due to branch misprediction)
// + (1/4 * * cycles on instruction fetch cache miss)

beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
beqz r2, 2
halt