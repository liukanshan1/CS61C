.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 125.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 126.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 127.
# =======================================================
matmul:
    # Error checks
	blt x0, a1, exp1
	addi a0, x0, 125
	ret
exp1:
    blt x0, a2, exp2
	addi a0, x0, 125
	ret
exp2:
    blt x0, a4, exp3
	addi a0, x0, 126
	ret
exp3:
	blt x0, a5, exp4
	addi a0, x0, 126
	ret
exp4:
	beq a2, a4, start
    addi a0, x0, 127
    ret
start:
	# Prologue
    addi sp, sp, -48
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw s9, 36(sp)
    sw s10, 40(sp)
    sw s11, 44(sp)
    addi s11, x0, 4 # Single Memory Step
    mul s10, s11, a2 # Row Address Step of m0
	addi t0, x0, -1 # Row Index
    addi t1, x0, -1 # Col Index
outer_loop_start:
	beq t0, a1, outer_loop_end
    addi t0, t0, 1
	addi t1, x0, -1
inner_loop_start:
	beq t1, a5, outer_loop_start
	addi t1, t1, 1
	# Save
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6
    mv s7, t0
    mv s8, t1
    mv s9, ra
    # Prepare Jump
    mul t0, s7, s10
	add a0, s0, t0
    mul t0, s8, s11
    add a1, s3, t0
    add a2, s2, x0
	addi a3, x0, 1
    add a4, x0, s5
	jal dot # Jump
    mv t2, a0 # Result
	# Restore
    mv a0, s0
    mv a1, s1
    mv a2, s2
    mv a3, s3
    mv a4, s4
    mv a5, s5
    mv a6, s6
    mv t0, s7
    mv t1, s8
    mv ra, s9
    mul t3, t0, a5
    add t3, t3, t1
    mul t3, t3, s11
    add t3, t3, a6
    sw t2, 0(t3)
	j inner_loop_start
outer_loop_end:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw s10, 40(sp)
    lw s11, 44(sp)
    addi sp, sp, 48
    mv a0, x0
    ret
