// Test of effects of cache prediction
// Authors: Chris Aberger and Michael Sartin-Tarm (Team Rippers)

lbi r0, 4

// Tags will never match so cache will have to flush
// Expected CPI: 3 + (number of cycles due to non dirty cache miss)
// + (1/4 * * cycles on instruction fetch cache miss)

ld r2, r0, 0 // cache miss

// change the tag here
btr r0, r0      // first, flip the reg
addi r0, r0, 1  // add 1 to what will be the tag
btr r0, r0      // flip it back

ld r2, r0, 0 // different tag this time - another miss. next miss will be eviction

btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
btr r0, r0
ld r2, r0, 0
btr r0, r0
addi r0, r0, 1
ld r2, r0, 0
halt
