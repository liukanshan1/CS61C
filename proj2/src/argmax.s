.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 120.
# =================================================================
argmax:
    # Prologue

	# Exceptions
	blt x0, a1, loop_start
	addi a0, x0, 120
	ret
loop_start:
	addi t0, x0, 4
    mul a1, a1, t0 # End Address
    addi t0, x0, 0 # Current Index
	lw t2, 0(a0) # Max Value
    addi t3, x0, 0 # Max Index
loop_continue:
	beq t0, a1, loop_end
    add t1, a0, t0
    lw t1, 0(t1) # Current Value
    bge t2, t1, continue
    add t2, x0, t1
    add t3, x0, t0
continue:
    addi t0, t0, 4
    j loop_continue
loop_end:
    # Epilogue
    
	addi t0, x0, 4
    div a0, t3, t0
    ret
