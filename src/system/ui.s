.module UI_System
.include "cpct_globals.h.s"
.include "./manager/entities.h.s"
.include "cpctelera.h.s"
.include "./manager/rounds.h.s"

lifeString: .asciz "LIFES"
foodString: .asciz "FOOD"
puntString: .asciz "1"

sys_ui_init::

    ;; Cargamos los colores
    ld l, #4    ;; Color de la letra
    ld h, #0    ;; Color del fondo
    call cpct_setDrawCharM0_asm   ;; Set draw char colours

    ;;  -------------------------------------------------
    ;;
    ;;  Dibujar "Lifes"
    ;;
    ;;

   ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
    ld c,   #02
    ld b,   #01
    call cpct_getScreenPtr_asm

    ;;ex de, hl

    ld   iy, #lifeString   ;; IY = Pointer to the string 
    call cpct_drawStringM0_asm  ;; Draw the string
    
    ;;  -------------------------------------------------
    ;;
    ;;  Número de vidas
    ;;
    ;;

    ;;call man_entity_first_entity    ;; Conseguimos el player
    ;;ld a, e_lifes(ix)

    ;; Tiene 6 vidas por defecto, se dibujan 6 sprites


    ;;  -------------------------------------------------
    ;;
    ;;  Dibujar "Food"
    ;;
    ;;
    
    ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
    ld c,   #44
    ld b,   #01
    call cpct_getScreenPtr_asm

    ;;ex de, hl

    ld   iy, #foodString   ;; IY = Pointer to the string 
    call cpct_drawStringM0_asm  ;; Draw the string

    ;;  -------------------------------------------------
    ;;
    ;; RONDAS
    ;;
    ;;
    call sys_ui_add_round
    ;;ld l, #0    ;; Color de la letra
    ;;ld h, #9    ;; Color del fondo
    ;;call cpct_setDrawCharM0_asm   ;; Set draw char colours
;;
    ;;;; Calculate a video-memory location for printing a string
    ;;ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
    ;;ld c,   #23
    ;;ld b,   #17
    ;;call cpct_getScreenPtr_asm
;;
    ;;call get_round
    ;;;rra
    ;;;rra
    ;;;rra
    ;;;rra
    ;;and #0x0F
    ;;add #48  ;; primer digito en Ascii
;;
    ;;ld e, a
    ;;call cpct_drawCharM0_asm

    ;;ex de, hl

    ;;ld   iy, #puntString   ;; IY = Pointer to the string 
    ;;call cpct_drawStringM0_asm  ;; Draw the string

    call man_entity_init_food_life

ret

sys_ui_update_lifes::
    call man_entity_first_entity    ;; Conseguimos el player
    ld a, e_lifes(ix)

    ;;  ----------------------------------------
    ;; 
    ;;  Update de las vidas
    ;;
    ;;

    cp #0
    jr z, no_lifes

    cp #1
    jr z, one_life

    cp #2
    jr z, two_lifes

    cp #3
    jr z, three_lifes

    cp #4
    jr z, four_lifes

    cp #5
    jr z, five_lifes

    no_lifes:
    jr skip_ui

    one_life:
    jr skip_ui

    two_lifes:
    jr skip_ui

    three_lifes:
    jr skip_ui

    four_lifes:
    jr skip_ui

    five_lifes:

    skip_ui:
ret

sys_ui_add_round::
    ld l, #0    ;; Color de la letra
    ld h, #9    ;; Color del fondo
    call cpct_setDrawCharM0_asm   ;; Set draw char colours

    ld de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
    ld c,   #23
    ld b,   #17
    call cpct_getScreenPtr_asm

    call get_round  ;; A = rondas

    cp #10
    jp m, less_than_ten

    ld de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
    ld c,   #25
    ld b,   #17
    call cpct_getScreenPtr_asm
    ;; El numero es mayor de 10
    ;;rra
    ;;rra
    call get_round

    dec a
    add  #1
    daa

    push af
    and #0x0F
    add #48 
    ld e, a

    call cpct_drawCharM0_asm
    
    ld de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
    ld c,   #21
    ld b,   #17
    call cpct_getScreenPtr_asm

    pop af
    and #0xF0
    rra
    rra
    rra
    rra
    add #48 
    ld e, a

    call cpct_drawCharM0_asm

    ret

    less_than_ten:
    and #0x0F
    add #48  ;; primer digito en Ascii

    ld e, a
    call cpct_drawCharM0_asm
ret 
