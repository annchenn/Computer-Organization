#112550184
.data
    input:      .asciiz "Enter an integer: "
    newline:    .asciiz "\n"
.text
.globl main
main:
#input
    li      $v0, 4
    la      $a0, input
    syscall
    li      $v0, 5
    syscall
    move    $t0, $v0

#sum of digits
    move    $a0, $t0
    jal     sum
    move    $t0, $v0

#print
    li      $v0, 1
    move    $a0, $t0
    syscall
    li      $v0, 4
    la      $a0, newline
    syscall

#exit
    li      $v0, 10
    syscall

.text
sum:
    beq     $a0, $zero, return0
    addi    $sp, $sp, -8
    sw      $ra, 0($sp)
    addi    $t1, $zero, 10
    div     $a0, $t1
    mfhi    $t1
    mflo    $t2
    move    $a0, $t2
    sw      $t1, 4($sp)
    jal     sum
    lw      $t1, 4($sp)
    add     $v0, $v0, $t1
    lw      $ra, 0($sp)
    addi    $sp, $sp, 8
    jr      $ra


return0:
    add     $v0, $zero, $zero
    jr      $ra