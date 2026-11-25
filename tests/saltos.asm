# tests/saltos.asm
#
# Instrucciones y casos cubiertos:
# beq: salto tomado.
# beq: salto no tomado.
# bne: salto tomado.
# bne: salto no tomado.
# bne: salto hacia atras mediante un bucle.
# j: salto incondicional.
#
# Cada caso imprime un digito diferente.
# El digito 9 identifica un camino incorrecto.
#
# Salida esperada: 123456

.text
.globl main

main:

    # =====================================
    # 1. BEQ TOMADO
    # 4 == 4: debe saltar.
    # Imprime 1.
    # =====================================

    addi $t0, $zero, 4
    addi $t1, $zero, 4

    beq $t0, $t1, beq_taken

    # Si llega aqui, el salto fallo.
    addi $a0, $zero, 57
    addi $v0, $zero, 11
    syscall
    j beq_done

beq_taken:
    addi $a0, $zero, 49
    addi $v0, $zero, 11
    syscall

beq_done:

    # =====================================
    # 2. BEQ NO TOMADO
    # 4 != 5: no debe saltar.
    # Imprime 2.
    # =====================================

    addi $t0, $zero, 4
    addi $t1, $zero, 5

    beq $t0, $t1, beq_not_taken_error

    addi $a0, $zero, 50
    addi $v0, $zero, 11
    syscall
    j beq_not_taken_done

beq_not_taken_error:
    addi $a0, $zero, 57
    addi $v0, $zero, 11
    syscall

beq_not_taken_done:

    # =====================================
    # 3. BNE TOMADO
    # 3 != 7: debe saltar.
    # Imprime 3.
    # =====================================

    addi $t0, $zero, 3
    addi $t1, $zero, 7

    bne $t0, $t1, bne_taken

    addi $a0, $zero, 57
    addi $v0, $zero, 11
    syscall
    j bne_done

bne_taken:
    addi $a0, $zero, 51
    addi $v0, $zero, 11
    syscall

bne_done:

    # =====================================
    # 4. BNE NO TOMADO
    # 8 == 8: no debe saltar.
    # Imprime 4.
    # =====================================

    addi $t0, $zero, 8
    addi $t1, $zero, 8

    bne $t0, $t1, bne_not_taken_error

    addi $a0, $zero, 52
    addi $v0, $zero, 11
    syscall
    j bne_not_taken_done

bne_not_taken_error:
    addi $a0, $zero, 57
    addi $v0, $zero, 11
    syscall

bne_not_taken_done:

    # =====================================
    # 5. BUCLE CON SALTO HACIA ATRAS
    # Cuenta desde 3 hasta 0.
    # bne vuelve a loop.
    # Imprime 5 al terminar.
    # =====================================

    addi $t0, $zero, 3

loop:
    addi $t0, $t0, -1
    bne $t0, $zero, loop

    addi $a0, $zero, 53
    addi $v0, $zero, 11
    syscall

    # =====================================
    # 6. SALTO INCONDICIONAL J
    # Debe saltar sobre el digito 9.
    # Imprime 6.
    # =====================================

    j jump_target

    # Si j falla, aparece el 9.
    addi $a0, $zero, 57
    addi $v0, $zero, 11
    syscall

jump_target:
    addi $a0, $zero, 54
    addi $v0, $zero, 11
    syscall

    # =====================================
    # FINALIZAR
    # =====================================

    addi $a0, $zero, 10
    addi $v0, $zero, 11
    syscall

    addi $v0, $zero, 10
    syscall
