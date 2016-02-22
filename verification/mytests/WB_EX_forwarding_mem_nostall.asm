// Test of forwarding from Write Back to EX without stalls
// Authors: Chris Aberger and Michael Sartin-Tarm (Team Rippers)

lbi r0, 4
lbi r2, 0

// load hit in cache (after first time) - tests WB-EX forwarding
// Expected behavior : roughly 1 CPI (never stalls)
// + (1/4 * * cycles on instruction fetch cache miss)

ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
ld r2, r0, 0
nop
halt
