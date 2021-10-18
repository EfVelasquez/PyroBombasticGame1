.module UI_System
.include "cpct_globals.h.s"
.include "./manager/entities.h.s"
.include "cpctelera.h.s"

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
    ld c,   #45
    ld b,   #01
    call cpct_getScreenPtr_asm

    ;;ex de, hl

    ld   iy, #foodString   ;; IY = Pointer to the string 
    call cpct_drawStringM0_asm  ;; Draw the string

    ;;  -------------------------------------------------
    ;;
    ;;  POSICION PROVISIONAL DE LAS RONDAS
    ;;
    ;;

    ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
    ld c,   #23
    ld b,   #17
    call cpct_getScreenPtr_asm

    ;;ex de, hl

    ld   iy, #puntString   ;; IY = Pointer to the string 
    call cpct_drawStringM0_asm  ;; Draw the string



ret

sys_ui_update::
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
