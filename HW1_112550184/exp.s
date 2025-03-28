#112550184
.data
    input_base:     .asciiz "Enter base (positive integers): "
    input_exp:      .asciiz "Enter exponent (positive integers): "
    newline:        .asciiz "\n"
.text
.globl main

# t0: base, t1: exp 
main:
#read input
    li      $v0, 4
    la      $a0, input_base
    syscall
    li      $v0, 5
    syscall
    move    $t0, $v0

    li      $v0, 4
    la      $a0, input_exp
    syscall
    li      $v0, 5
    syscall
    move    $t1, $v0

#exp
    jal     exp

#print
    move    $a0, $v0
    li      $v0, 1
    syscall

    la      $a0, newline
    li      $v0, 4
    syscall

#exit
    li      $v0, 10
    syscall

.text
exp:
    addi    $sp, $sp, -4
    sw      $ra, 0($sp)
    beq     $t1, $zero, end
    addi    $t1, $t1, -1
    jal     exp
    mul     $v0, $v0, $t0
    lw      $ra, 0($sp)
    addi    $sp, $sp, 4
    jr      $ra

end:
    addi    $v0, $zero, 1
    lw      $ra, 0($sp)
    addi    $sp, $sp, 4
    jr      $ra