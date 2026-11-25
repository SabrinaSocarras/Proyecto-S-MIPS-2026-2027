
# test_arithmetic.asm
# Cubre:
# add, sub: operandos positivos y negativos
# addi: inmediato negativo
# addu: mediante move
# addiu: mediante li
# slt, slti: resultados 1 y 0, comparación con signo
# $zero: intento de escritura y comprobación

.text
.globl main

main:
    # ADD: 5 + 3 = 8
    addi $t0, $zero, 5
    addi $t1, $zero, 3
    add $t2, $t0, $t1

    addi $a0, $t2, 48
    addi $v0, $zero, 11
    syscall

    # SUB: 9 - 4 = 5
    addi $t0, $zero, 9
    addi $t1, $zero, 4
    sub $t2, $t0, $t1

    addi $a0, $t2, 48
    syscall

    # ADDI negativo: 5 + (-2) = 3
    addi $t0, $zero, 5
    addi $t1, $t0, -2

    addi $a0, $t1, 48
    syscall

    # SUB con operando negativo: -3 - 2 = -5
    addi $t0, $zero, -3
    addi $t1, $zero, 2
    sub $t2, $t0, $t1

    # Comprobar que el resultado es negativo
    slt $t3, $t2, $zero
    addi $a0, $t3, 48
    syscall

    # SLT: 2 < 5 = 1
    addi $t0, $zero, 2
    addi $t1, $zero, 5
    slt $t2, $t0, $t1

    addi $a0, $t2, 48
    syscall

    # SLT: 5 < 2 = 0
    slt $t2, $t1, $t0

    addi $a0, $t2, 48
    syscall

    # SLT: -1 < 1 = 1 (comparación con signo)
    addi $t0, $zero, -1
    addi $t1, $zero, 1
    slt $t2, $t0, $t1

    addi $a0, $t2, 48
    syscall

    # SLTI: 3 < 5 = 1
    addi $t0, $zero, 3
    slti $t1, $t0, 5

    addi $a0, $t1, 48
    syscall

    # SLTI: 5 < 3 = 0
    slti $t1, $t0, 2
    addi $a0, $t1, 48
    syscall

    # ADDIU: li utiliza addiu
    li $t0, 7
    addi $a0, $t0, 48
    syscall

    # ADDU: move utiliza addu
    move $t1, $t0
    addi $a0, $t1, 48
    syscall

    # Intentar escribir en $zero
    addi $zero, $zero, 9

    # Comprobar que $zero sigue siendo 0
    addi $t0, $zero, 0
    addi $a0, $t0, 48
    syscall

    # Terminar
    addi $v0, $zero, 10
    syscall
