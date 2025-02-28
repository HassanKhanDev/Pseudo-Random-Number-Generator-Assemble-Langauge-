# prng16_5.asm - 16-bit LFSR PRNG with Random Seed (Syscall 30)

.data
newline: .asciiz "\n"

.text
.globl main

main:
    li $v0, 30            # Syscall 30 to get system time
    syscall
    move $t0, $a0         # Use lower bits as seed
    li $t1, 10            # Generate 10 random numbers

loop:
    move $a0, $t0
    li $v0, 1
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall

    srl $t3, $t0, 1       # Right shift
    andi $t4, $t0, 1      # Extract LSB
    srl $t5, $t0, 13
    xor $t4, $t4, $t5
    srl $t5, $t0, 5
    xor $t4, $t4, $t5
    srl $t5, $t0, 1
    xor $t4, $t4, $t5
    sll $t4, $t4, 15      # Shift XOR result to MSB
    or  $t0, $t3, $t4
    
    sub $t1, $t1, 1
    bnez $t1, loop

exit:
    li $v0, 10
    syscall
