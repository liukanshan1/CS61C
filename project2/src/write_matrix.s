.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 112.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 113.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 114.
# ==============================================================================
write_matrix:
    # Prologue
	addi sp, sp, -24
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
	
    # Save
	mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, ra
    # Prepare Jump
	mv a1, a0
    addi a2, x0, 1
    jal fopen
	addi t0, x0, -1
    beq a0, t0, error1
    mv s5, a0 # File
    # Prepare Jump
    addi a0, x0, 8
    jal malloc # NOT FREE
    beq x0, a0 error4
    sw s2, 0(a0) # Row
    sw s3, 4(a0) # Col
    # Prepare Jump
    mv a1, s5
    mv a2, a0
	addi a3, x0, 2
    addi a4, x0, 4
    jal fwrite
    addi a3, x0, 2
	bne a0, a3, error2
	# Prepare Jump
    mv a1, s5
    mv a2, s1
	mul a3, s2, s3
    addi a4, x0, 4
    jal fwrite
    mul a3, s2, s3
	bne a0, a3, error2
	# Prepare Jump
    mv a1, s5
    jal fclose
    addi t0, x0, -1
    beq a0, t0, error3
    # Restore
    mv a0, s0
    mv a1, s1
    mv a2, s2
    mv a3, s3
    mv ra, s4
    
    # Epilogue
	lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    addi sp, sp, 24
    ret

error1:
	addi a1, x0, 112
    jal exit2
error2:
	addi a1, x0, 113
    jal exit2
error3:
	addi a1, x0, 114
    jal exit2
error4:
	addi a1, x0, 122
    jal exit2