// JAL Test. This is a test we used in pipelining
// to determine how to handle combined RAW and control
// hazard logic.

lbi r7, 0
jal 2
addi r7, r7, 1
jal 2
addi r7, r7, 1
jal 4 // skips over the next JAL
.increment:
addi r7, r7, 1
jal .end
jal 2
addi r7, r7, 1
jal 2
addi r7, r7, 1
jal .increment    // Should be the only time r7 increments
addi r7, r7, 1 // This should never be reached
jal .end        // Or this
.end:
halt
