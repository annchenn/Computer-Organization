#112550184
.data
    input:      .asciiz "Enter five positive integers: "
    array:      .word 0:5
    space:      .asciiz " "
.text
.globl main
main:
#input
    la      $t0, array 
    #$t0: a[0]
    li      $v0, 4
    la      $a0, input
    syscall
    li      $v0, 5
    syscall
    sw      $v0, 0($t0)

    li      $v0, 5
    syscall
    sw      $v0, 4($t0)
    
    li      $v0, 5
    syscall
    sw      $v0, 8($t0)

    li      $v0, 5
    syscall
    sw      $v0, 12($t0)

    li      $v0, 5
    syscall
    sw      $v0, 16($t0)

#find max and min
    move    $a0, $t0
    jal     find

#print
    move    $a0, $v0
    li      $v0, 1
    syscall

    li      $v0, 4
    la      $a0, space
    syscall

    li      $v0, 1
    move    $a0, $v1
    syscall
#exit
    li      $v0, 10
    syscall



.text
#max in $v0, min in $v1
find:
    #a0=&array[0] 
    addi    $t1, $a0, 16 # t1=array size
    lw      $v0, 0($a0)
    lw      $v1, 0($a0)

loop:
    lw      $t0, 0($a0)
    ble     $t0, $v0, checkmin
    move    $v0, $t0

checkmin:
    bge     $t0, $v1, continue
    move    $v1, $t0

continue:
    bge     $a0, $t1, end
    addi    $a0, $a0, 4
    j       loop

end:
    jr      $ra