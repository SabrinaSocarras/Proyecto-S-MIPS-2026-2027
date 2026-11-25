
# tests/logica.asm
#
# Instrucciones y casos cubiertos:
# and, or: operandos con unos en los 16 bits altos.
# sll: shamt = 0 y shamt distinto de 0.
# srl: shamt = 0 y shamt distinto de 0,
#      sobre un operando negativo, introduciendo ceros.
# andi, ori: inmediato 0x8001, con bit 15 = 1.
# lui: inmediato 0x8001, con bit 15 = 1.
#
# Los resultados se imprimen en hexadecimal mediante syscall 11.
 
.text
.globl main
 
main:
 
    # --------------------------------
    # 1. AND: operandos con bits altos
    # F0F0A55A AND 8001FFFF = 8000A55A
    # --------------------------------
 
    lui $t4, 0xF0F0
    ori $t4, $t4, 0xA55A
 
    lui $t5, 0x8001
    ori $t5, $t5, 0xFFFF
 
    and $s0, $t4, $t5
 
    # --------------------------------
    # 2. OR: operandos con bits altos
    # 0000F00F OR 80010000 = 8001F00F
    # --------------------------------
 
    ori $t4, $zero, 0xF00F
    lui $t5, 0x8001
 
    or $s1, $t4, $t5
 
    # --------------------------------
    # 3. SLL con shamt = 0
    # 80010001 << 0 = 80010001
    # --------------------------------
 
    lui $t4, 0x8001
    ori $t4, $t4, 1
 
    sll $s2, $t4, 0
 
    # --------------------------------
    # 4. SLL con shamt = 4
    # 00018001 << 4 = 00180010
    # --------------------------------
 
    lui $t4, 0x0001
    ori $t4, $t4, 0x8001
 
    sll $s3, $t4, 4
 
    # --------------------------------
    # 5. SRL con shamt = 0
    # 80000001 >> 0 = 80000001
    # --------------------------------
 
    lui $t4, 0x8000
    ori $t4, $t4, 1
 
    srl $s4, $t4, 0
 
    # --------------------------------
    # 6. SRL con shamt = 4
    # 80000001 >> 4 = 08000000
    # Desplazamiento logico: entran ceros.
    # --------------------------------
 
    srl $s5, $t4, 4
 
    # --------------------------------
    # 7. ANDI con inmediato 0x8001
    # FFFFA55A AND 00008001 = 00008000
    # El inmediato se extiende con ceros.
    # --------------------------------
 
    lui $t4, 0xFFFF
    ori $t4, $t4, 0xA55A
 
    andi $s6, $t4, 0x8001
 
    # --------------------------------
    # 8. ORI con inmediato 0x8001
    # 12340000 OR 00008001 = 12348001
    # El inmediato se extiende con ceros.
    # --------------------------------
 
    lui $t4, 0x1234
 
    ori $s7, $t4, 0x8001
 
    # --------------------------------
    # 9. LUI con inmediato 0x8001
    # Resultado = 80010000
    # --------------------------------
 
    lui $t6, 0x8001
 
    # --------------------------------
    # IMPRIMIR RESULTADOS
    # --------------------------------
 
    add $a0, $s0, $zero
    jal print_hex
 
    add $a0, $s1, $zero
    jal print_hex
 
    add $a0, $s2, $zero
    jal print_hex
 
    add $a0, $s3, $zero
    jal print_hex
 
    add $a0, $s4, $zero
    jal print_hex
 
    add $a0, $s5, $zero
    jal print_hex
 
    add $a0, $s6, $zero
    jal print_hex
 
    add $a0, $s7, $zero
    jal print_hex
 
    # 9. LUI (resultado guardado en $t6)
    add $a0, $t6, $zero
    jal print_hex
 
    # Terminar
    addi $v0, $zero, 10
    syscall
 
 
# ====================================
# RUTINA: print_hex
# Entrada: $a0 = valor de 32 bits
# Imprime 8 digitos hexadecimales.
# Utiliza solamente syscall 11.
# Destruye $t0, $t1, $t2 y $t3.
# ====================================
 
print_hex:
 
    add $t0, $a0, $zero
    addi $t1, $zero, 8
 
hex_loop:
 
    # Extraer el nibble mas significativo
    srl $t2, $t0, 28
    andi $t2, $t2, 15
 
    # Es un digito entre 0 y 9?
    slti $t3, $t2, 10
    beq $t3, $zero, hex_letter
 
    # Convertir 0-9 a ASCII
    addi $a0, $t2, 48
    j hex_emit
 
hex_letter:
 
    # Convertir 10-15 a A-F
    addi $a0, $t2, 55
 
hex_emit:
 
    # Imprimir caracter
    addi $v0, $zero, 11
    syscall
 
    # Desplazar el valor para extraer
    # el siguiente nibble
    sll $t0, $t0, 4
 
    addi $t1, $t1, -1
    bne $t1, $zero, hex_loop
 
    # Salto de linea
    addi $a0, $zero, 10
    syscall
 
    jr $ra
 