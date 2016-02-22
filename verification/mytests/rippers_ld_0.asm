// Author: nfischer, edited by Michael Sartin-Tarm
// This code was edited to further debug pipelined load / story raw hazards
// and see how long our control hazard WIPE signal had to propogate.
// Test source code follows


//basic load
lbi  r3, 128
lbi  r7, 1
lbi  r7, 2
lbi  r7, 3
lbi  r7, 4
lbi  r7, 5
lbi  r7, 6
lbi  r7, 7
lbi  r7, 8 
ld   r7, r3, 0  //store at mem location
nop
ld   r7, r3, 0  //store at mem location
nop
ld   r7, r3, 0  //store at mem location
nop
ld   r7, r3, 0  //store at mem location
ld   r7, r3, 0  //store at mem location
ld   r7, r3, 0  //store at mem location
ld   r7, r3, 0  //store at mem location

lbi  r7, 9
lbi  r7, 1
lbi  r7, 1
lbi  r7, 1
lbi  r7, 1
lbi  r7, 1
lbi  r7, 1
lbi  r3, 128

halt
