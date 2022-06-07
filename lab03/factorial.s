.globl factorial

.data
n: .word 8

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    # YOUR CODE HERE
    addi t1, x0, 1
    addi t2, x0, 1
loop:
    blt a0, t2, exit
    mul t1, t1, t2
    addi t2, t2, 1
    jal x0, loop
exit:
	add a0, t1, x0
    jr ra
    