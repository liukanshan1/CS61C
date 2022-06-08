.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 115.
# ==============================================================================
relu:
    # Prologue
    
    # Exceptions
	blt x0, a1, loop_start
	addi a0, x0, 115
	ret
loop_start:
	addi t0, x0, 4
    mul a1, a1, t0
    addi t0, x0, 0 # Index
	j loop_continue
loop_continue:
	beq t0, a1, loop_end
    add t1, a0, t0 # Address
    lw t2, 0(t1) # Value
    bge t2, x0 no_ope
    sw x0, 0(t1)
    j no_ope
no_ope:
	addi t0, t0, 4
    j loop_continue
loop_end:
    # Epilogue

	ret
