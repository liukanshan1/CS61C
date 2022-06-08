.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 116.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 117.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 118.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 119.
# ==============================================================================
read_matrix:
    # Prologue
	addi sp, sp, -32
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    
    # Save
	mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, ra
    # Prepare Jump
	mv a1, a0
    mv a2, x0
	jal fopen
    addi t0, x0, -1
    beq a0, t0, error2
    mv s4, a0 # File
    # Prepare Jump
    addi a0, x0, 8
    jal malloc
    beq x0, a0 error1
    mv s5, a0 # Row and Col
    # Prepare Jump
    mv a1, s4
    mv a2, s5
    addi a3, x0, 8
    jal fread
    beq a0, a3, error3
    lw t0, 0(s5) # Row
    lw t1, 4(s5) # Col
    # Prepare Jump
    mul t2, t0, t1
    addi t3, x0, 4
    mul s7, t2, t3 # Matrix Size
    mv a0, s7
    jal malloc
    beq x0, a0 error1
    mv s6, a0 # Matrix
    # Prepare Jump
    mv a1, s4
    mv a2, s6
    mv a3, s7
    jal fread
    beq a0, a3, error3
    # Restore
    mv a0, s0
    mv a1, s1
    mv a2, s2
    mv ra, s3
    # Prepare Return
    mv a0, s6
    lw t0, 0(s5) # Row
    lw t1, 4(s5) # Col
    sw t0, 0(a1)
    sw t1, 0(a2)
    
    # Epilogue
	lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    addi sp, sp, 32
    ret

error1:
	addi a1, x0, 116
    jal exit2
error2:
	addi a1, x0, 117
    jal exit2
error3:
	addi a1, x0, 118
    jal exit2
error4:
	addi a1, x0, 119
    jal exit2

