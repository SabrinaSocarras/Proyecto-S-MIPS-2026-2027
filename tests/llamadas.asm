# tests/llamadas.asm
#
# Instrucciones y casos cubiertos:
# jal: llamada desde main a procedimiento_A.
# jal: llamada anidada desde procedimiento_A
#      a procedimiento_B.
# jr: retorno desde procedimiento_B.
# jr: retorno desde procedimiento_A.
# Pila: guardar y restaurar $ra en un
#       procedimiento que realiza otra llamada.
#
# Salida esperada: 1234

.text
.globl main

main:

    # Llamar al procedimiento A
    jal procedimiento_A

    # Si regresamos correctamente desde A,
    # imprimimos 4.
    addi $a0, $zero, 52
    addi $v0, $zero, 11
    syscall

    # Salto de linea
    addi $a0, $zero, 10
    syscall

    # Finalizar
    addi $v0, $zero, 10
    syscall


# =========================================
# PROCEDIMIENTO A (NO HOJA)
#
# Llama a procedimiento_B.
# Debe guardar $ra porque el segundo jal
# modifica el contenido de ese registro.
# =========================================

procedimiento_A:

    # Reservar 4 bytes en la pila
    addi $sp, $sp, -4

    # Guardar direccion de retorno original
    sw $ra, 0($sp)

    # Imprimir 1: entrada en procedimiento A
    addi $a0, $zero, 49
    addi $v0, $zero, 11
    syscall

    # Llamar al procedimiento B
    jal procedimiento_B

    # Si B regresa correctamente, imprimir 3
    addi $a0, $zero, 51
    addi $v0, $zero, 11
    syscall

    # Restaurar direccion de retorno original
    lw $ra, 0($sp)

    # Liberar espacio de la pila
    addi $sp, $sp, 4

    # Regresar a main
    jr $ra


# =========================================
# PROCEDIMIENTO B (HOJA)
#
# No realiza otra llamada, por lo que no
# necesita guardar $ra.
# =========================================

procedimiento_B:

    # Imprimir 2: entrada en procedimiento B
    addi $a0, $zero, 50
    addi $v0, $zero, 11
    syscall

    # Regresar al punto posterior al jal
    jr $ra
