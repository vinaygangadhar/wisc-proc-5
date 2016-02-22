// Test of effects of cache prediction where we will have to evict
// Authors: Chris Aberger and Michael Sartin-Tarm (Team Rippers)

lbi r0, 4

// Tags will never match so cache will have to flush and evict
// Expected CPI: 3 + (number of cycles due to dirty cache miss)
// + (1/4 * * cycles on instruction fetch cache miss)

st r2, r0, 0 // cache miss

// change the tag here
btr r0, r0      // first, flip the reg
addi r0, r0, 1  // add 1 to what will be the tag
btr r0, r0      // flip it back

st r2, r0, 0 // different tag this time - another miss. data will be dirty now 

btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
st r2, r0, 0
btr r0, r0
addi r0, r0, 1
st r2, r0, 0
halt
