.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 123.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 124.
# =======================================================
dot:
    # Prologue

	# Exceptions
	blt x0, a2, exp1
	addi a0, x0, 123
	ret
exp1:
    blt x0, a3, exp2
	addi a0, x0, 124
	ret
exp2:
    blt x0, a4, loop_start
	addi a0, x0, 124
	ret
loop_start:
	addi t6, x0, 4 # Single Memory Step
	mul a2, a2, t6 # End Address
    mul a3, a3, t6 # Stride Memory Step of v0
    mul a4, a4, t6 # Stride Memory Step of v1
	addi t0, x0, 0 # Current Index of v0
    addi t1, x0, 0 # Current Index of v1
    addi t2, x0, 0 # Sum
loop_continue:
	beq t0, a2, loop_end
    add t3, a0, t0
	lw t3, 0(t3) # Current Value of v0
    add t4, a1, t1
	lw t4, 0(t4) # Current Value of v0
	mul t5, t3, t4
    add t2, t2, t5
	add t0, t0, a3
    add t1, t1, a4
	j loop_continue
loop_end:
    # Epilogue

    add a0, t2, x0
    ret
