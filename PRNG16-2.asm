# prng16_2.asm - Looping Feedback Values (First 100 Even Values)

.data
newline: .asciiz "\n"

.text
.globl main

main:
    li $t0, 0xA315        # Fixed seed
    li $t1, 2            # First even feedback value
    li $t2, 200          # Loop counter (100 even values)

loop:
    move $t3, $t1        # Store feedback value
    li $t4, 65536        # Cycle length counter

inner_loop:
    # Perform LFSR shift with XOR using $t3 as feedback pattern
    srl $t5, $t0, 1      # Right shift
    andi $t6, $t0, 1     # Extract LSB
    srl $t7, $t0, 13
    xor $t6, $t6, $t7
    srl $t7, $t0, 5
    xor $t6, $t6, $t7
    srl $t7, $t0, 1
    xor $t6, $t6, $t7
    sll $t6, $t6, 15     # Shift XOR result to MSB
    or  $t0, $t5, $t6    # Combine new MSB and shifted register
    
    sub $t4, $t4, 1      # Decrease counter
    bnez $t4, inner_loop

    # Print feedback value and cycle count
    move $a0, $t1
    li $v0, 1
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
    # Increment feedback value (next even number)
    addi $t1, $t1, 2
    sub $t2, $t2, 1
    bnez $t2, loop

exit:
    li $v0, 10
    syscall