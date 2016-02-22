// Test provided by Karu modified by Michael
// bneqz test.

lbi r1, 1            //set r1 to a constant 1
lbi r2, 2	     //set r2 to a constant 2
lbi r4, 0            //set r4 to a constant 0, r4 will be used to indicate our program can be execate currectly or not
nop
nop
nop
nop
slt r3, r1, r2       //set the r3 if r1 is less than r2, it will be set here
beqz r3, .label1     //if r3 is zero, program will branch to label1, and it won't do branch here.
lbi  r4, 1       //if the beqz above didn't branch, r4 will be added 1
lbi  r4, 2
lbi  r4, 3
lbi  r4, 4
.label1:
lbi r1, 2            //set r1 to a constant 2
lbi r2, 1	     //set r2 to a constant 1
slt r3, r1, r2        //set the r3 if r1 is less than r2, it won't be set here
nop
nop
nop
nop
beqz r3, .label2     //if r3 is zero, program will branch to label1, and it will do branch here.
lbi r4, 5	     //if the beqz above didn't branch, r4 will be added 5
lbi r4, 6		 // how far does our pipeline need to go?
lbi r4, 7
halt

.label2:
lbi r4, 8       //if the beqz above brance, r4 will be added 2
halt
