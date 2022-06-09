.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 121.
    # - If malloc fails, this function terminates the program with exit code 116 (though we will also accept exit code 122).
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

	# =====================================
    # LOAD MATRICES
    # =====================================
    
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
    # Load pretrained m0
	# Save
	mv s0, a0
    mv s1, a1
    mv s2, a2
    addi a0, x0, 8
    jal malloc # NOT FREE
    beq x0, a0 error4
	mv s3, a0 # Rows and Cols of m0
	lw a0, 0(s1)
	mv a1, s3
    addi a2, s3, 4
    jal read_matrix
	mv s4, a0 # m0
    # Load pretrained m1
	addi a0, x0, 8
    jal malloc # NOT FREE
    beq x0, a0 error4
	mv s5, a0 # Rows and Cols of m1
	lw a0, 4(s1)
	mv a1, s5
    addi a2, s5, 4
    jal read_matrix
	mv s6, a0 # m1
    # Load input matrix
	addi a0, x0, 8
    jal malloc # NOT FREE
    beq x0, a0 error4
	mv s7, a0 # Rows and Cols of input
	lw a0, 8(s1)
	mv a1, s7
    addi a2, s7, 4
    jal read_matrix
	mv s8, a0 # input
    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
	lw t0, 0(s3)
    lw t1, 4(s7)
    mul t0, t0, t1
    addi t1, x0, 4
    mul a0, t0, t1
    jal malloc
	beq x0, a0 error4
    mv s9, a0
    # Prepare m0 * input
    mv a0, s4
    lw a1, 0(s3)
    lw a2, 4(s3)
    mv a3, s8
    lw a4, 0(s7)
    lw a5, 4(s7)
    mv a6, s9
    jal matmul
    # Prepare ReLU(m0 * input)
    mv a0, s9
	lw t0, 0(s3)
    lw t1, 4(s7)
    mul a1, t0, t1
   	jal relu
    # Prepare m1 * ReLU(m0 * input)
	lw t0, 0(s5)
    lw t1, 4(s7)
    mul t0, t0, t1
    addi t1, x0, 4
    mul a0, t0, t1
    jal malloc
	beq x0, a0 error4
    mv s10, a0 
	mv a0, s6
    lw a1, 0(s5)
    lw a2, 4(s5)
    mv a3, s9
    lw a4, 0(s3)
	lw a5, 4(s7)
    mv a6, s10
    jal matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
	lw a0, 12(s1)
	mv a1, s10
    lw a2, 0(s5)
    lw a3, 4(s7)
	jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
	mv a0, s10
	lw t0, 0(s5)
    lw t1, 4(s7)
    mul a1, t0, t1
	jal argmax
	mv s11, a0
    # Print classification
    bne s2, x0, end
    mv a1, s11
    jal print_int
    # Print newline afterwards for clarity
	addi a1, x0, '\n'
    jal print_char
end:
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
    ret

error4:
	addi a1, x0, 122
    jal exit2