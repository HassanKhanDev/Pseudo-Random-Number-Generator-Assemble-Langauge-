# prng8.asm - 8-bit LFSR PRNG

.data
newline: .asciiz "\n"

.text
.globl main

main:
    li $t0, 0xA3          # Seed value
    li $t1, 255           # Loop counter
    li $t2, 0             # Store initial seed for checking repetition

loop:
    # Print the current value
    move $a0, $t0
    li $v0, 1
    syscall
    
    # Print newline
    li $v0, 4
    la $a0, newline
    syscall

    # Check if the value is same as the seed
    beq $t0, $t2, exit    # If repeated, exit loop

    # Perform LFSR shift with XOR at tap points (6, 5, 4)
    srl $t3, $t0, 1       # Right shift
    andi $t4, $t0, 1      # Extract LSB
    srl $t5, $t0, 6
    xor $t4, $t4, $t5
    srl $t5, $t0, 5
    xor $t4, $t4, $t5
    srl $t5, $t0, 4
    xor $t4, $t4, $t5
    sll $t4, $t4, 7       # Shift XOR result to MSB
    or  $t0, $t3, $t4     # Combine new MSB and shifted register
    
    sub $t1, $t1, 1       # Decrease counter
    bnez $t1, loop

exit:
    li $v0, 10
    syscall


