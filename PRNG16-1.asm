# prng16_1.asm - 16-bit LFSR PRNG (400 iterations)

.data
newline: .asciiz "\n"

.text
.globl main

main:
    li $t0, 0xA315        # Seed value
    li $t1, 400           # Loop counter

loop:
    # Print the current value
    move $a0, $t0
    li $v0, 1
    syscall
    
    # Print newline
    li $v0, 4
    la $a0, newline
    syscall

    # Perform LFSR shift with XOR at tap points (13, 5, 1)
    srl $t3, $t0, 1       # Right shift
    andi $t4, $t0, 1      # Extract LSB
    srl $t5, $t0, 13
    xor $t4, $t4, $t5
    srl $t5, $t0, 5
    xor $t4, $t4, $t5
    srl $t5, $t0, 1
    xor $t4, $t4, $t5
    sll $t4, $t4, 15      # Shift XOR result to MSB
    or  $t0, $t3, $t4     # Combine new MSB and shifted register
    
    sub $t1, $t1, 1       # Decrease counter
    bnez $t1, loop

exit:
    li $v0, 10
    syscall
