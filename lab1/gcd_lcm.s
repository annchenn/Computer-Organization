#112550184
.data
    input_first:    .asciiz "Please enter the first number: "
    input_second:   .asciiz "please enter the second number: "
    newline:    .asciiz "\n"
    space:      .asciiz " "

.text
.globl main
main:
#read input
    li      $v0, 4
    la      $a0, input_first
    syscall

    li      $v0, 5
    syscall
    move    $t2, $v0

    li      $v0, 4
    la      $a0, input_second
    syscall

    li      $v0, 5
    syscall
    move    $t3, $v0

#gcd
    move    $a0, $t2
    move    $a1, $t3
    jal     gcd
    move    $t4, $v0

#lcm
    move    $a0, $t2
    move    $a1, $t3
    jal     lcm
    move    $t5, $v0

#print
    li      $v0, 1
    move    $a0, $t4
    syscall

    li      $v0, 4
    la      $a0, space
    syscall

    li      $v0, 1
    move    $a0, $t5
    syscall

    li      $v0, 4
    la      $a0, newline
    syscall
#exit
    li      $v0, 10
    syscall

.text
gcd:
    beq     $a1, $zero, L1
    addi    $sp, $sp, -4
    sw      $ra, 0($sp)
    div     $a0, $a1
    mfhi    $t0
    move    $a0, $a1
    move    $a1, $t0
    jal     gcd

    lw      $ra, 0($sp)
    addi    $sp, $sp, 4
    jr      $ra

#return a
L1:
    move    $v0, $a0
    jr      $ra
    
    
lcm:
    addi    $sp, $sp, -12
    sw      $ra, 0($sp)
    sw      $a0, 4($sp)
    sw      $a1, 8($sp)
    jal     gcd
    lw      $ra, 0($sp)
    lw      $a0, 4($sp)
    lw      $a1, 8($sp)
    addi    $sp, $sp, 12
    mul     $t0, $a0, $a1
    div     $t0, $v0
    mflo    $v0
    jr      $ra