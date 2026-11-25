
# tests/memoria.asm
#
# Instrucciones y casos cubiertos:
# sw, lw: desplazamientos positivos (+8) y negativos (-8).
# lb, lbu: bytes con bit 7 = 1 en dos posiciones:
#          byte 1 (F3) y byte 2 (80).
#          Comprueba extension de signo y con ceros.
# sb: escritura en los cuatro bytes de una palabra.
#     Se utiliza lw despues de cada escritura para
#     comprobar que los otros bytes no cambian.
#
# Los resultados se imprimen en hexadecimal.
# Se utiliza syscall 11 para imprimir caracteres.

.text
.globl main

main:

    # =========================================
    # 1. SW Y LW: DESPLAZAMIENTO POSITIVO
    # =========================================

    lui $t0, 0x1234
    ori $t0, $t0, 0x5678

    sw $t0, 8($gp)
    lw $t1, 8($gp)

    add $a0, $t1, $zero
    jal print_hex

    # =========================================
    # 2. SW Y LW: DESPLAZAMIENTO NEGATIVO
    # =========================================

    lui $t0, 0x89AB
    ori $t0, $t0, 0xCDEF

    sw $t0, -8($gp)
    lw $t1, -8($gp)

    add $a0, $t1, $zero
    jal print_hex

    # =========================================
    # 3. PREPARAR PALABRA PARA LB Y LBU
    #
    # Palabra: 2C80F35A
    #
    # Byte 0 = 5A
    # Byte 1 = F3
    # Byte 2 = 80
    # Byte 3 = 2C
    # =========================================

    lui $t0, 0x2C80
    ori $t0, $t0, 0xF35A

    sw $t0, 16($gp)

    # =========================================
    # 4. LB: LEER BYTE F3 (POSICION 1)
    # =========================================

    lb $t1, 17($gp)

    add $a0, $t1, $zero
    jal print_hex

    # =========================================
    # 5. LBU: LEER BYTE F3 (POSICION 1)
    # =========================================

    lbu $t1, 17($gp)

    add $a0, $t1, $zero
    jal print_hex

    # =========================================
    # 6. LB: LEER BYTE 80 (POSICION 2)
    # =========================================

    lb $t1, 18($gp)

    add $a0, $t1, $zero
    jal print_hex

    # =========================================
    # 7. LBU: LEER BYTE 80 (POSICION 2)
    # =========================================

    lbu $t1, 18($gp)

    add $a0, $t1, $zero
    jal print_hex

    # =========================================
    # 8. PREPARAR PALABRA PARA SB
    #
    # Palabra inicial: 11223344
    #
    # Byte 0 = 44
    # Byte 1 = 33
    # Byte 2 = 22
    # Byte 3 = 11
    # =========================================

    lui $t0, 0x1122
    ori $t0, $t0, 0x3344

    sw $t0, 24($gp)

    # =========================================
    # 9. SB: ESCRIBIR EN BYTE 1
    # AA -> posicion 1
    # Resultado esperado: 1122AA44
    # =========================================

    addi $t0, $zero, 170
    sb $t0, 25($gp)

    lw $t1, 24($gp)

    add $a0, $t1, $zero
    jal print_hex

    # =========================================
    # 10. SB: ESCRIBIR EN BYTE 3
    # BB -> posicion 3
    # Resultado esperado: BB22AA44
    # =========================================

    addi $t0, $zero, 187
    sb $t0, 27($gp)

    lw $t1, 24($gp)

    add $a0, $t1, $zero
    jal print_hex

    # =========================================
    # 11. SB: ESCRIBIR EN BYTE 0
    # CC -> posicion 0
    # Resultado esperado: BB22AACC
    # =========================================

    addi $t0, $zero, 204
    sb $t0, 24($gp)

    lw $t1, 24($gp)

    add $a0, $t1, $zero
    jal print_hex

    # =========================================
    # 12. SB: ESCRIBIR EN BYTE 2
    # DD -> posicion 2
    # Resultado esperado: BBDDAACC
    # =========================================

    addi $t0, $zero, 221
    sb $t0, 26($gp)

    lw $t1, 24($gp)

    add $a0, $t1, $zero
    jal print_hex

    # =========================================
    # FINALIZAR
    # =========================================

    addi $v0, $zero, 10
    syscall


# =============================================
# RUTINA print_hex
#
# Entrada: $a0 = valor de 32 bits.
# Imprime ocho digitos hexadecimales.
# Destruye $t0, $t1, $t2 y $t3.
# =============================================

print_hex:

    add $t0, $a0, $zero
    addi $t1, $zero, 8

hex_loop:

    srl $t2, $t0, 28
    andi $t2, $t2, 15

    slti $t3, $t2, 10
    beq $t3, $zero, hex_letter

    # Digitos 0-9
    addi $a0, $t2, 48
    j hex_emit

hex_letter:

    # Letras A-F
    addi $a0, $t2, 55

hex_emit:

    addi $v0, $zero, 11
    syscall

    sll $t0, $t0, 4

    addi $t1, $t1, -1
    bne $t1, $zero, hex_loop

    # Salto de linea
    addi $a0, $zero, 10
    syscall

    jr $ra
