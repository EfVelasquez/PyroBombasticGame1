.module UI_System
.include "cpct_globals.h.s"
.include "./manager/entities.h.s"
.include "cpctelera.h.s"
.include "./manager/rounds.h.s"
.include "./manager/screen.h.s"


lifeString: .asciz "LIFES"
foodString: .asciz "FOOD"
puntString: .asciz "1"


food_life: .db 0x10
food_life_pos: .ds #2

.globl _sprite_corazon ;4bytes x 9

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
    ;; CORAZON 1
    ld de, #0xC000
    ld c, #02
    ld b, #00
    call cpct_getScreenPtr_asm
    ex de, hl

    ld hl, #_sprite_corazon

    ld c, #4
    ld b, #9
    call cpct_drawSprite_asm

    ;; CORAZON 2

    ld de, #0xC000
    ld c, #06
    ld b, #00
    call cpct_getScreenPtr_asm
    ex de, hl

    ld hl, #_sprite_corazon

    ld c, #4
    ld b, #9
    call cpct_drawSprite_asm

    ;; CORAZON 3

    ld de, #0xC000
    ld c, #10
    ld b, #00
    call cpct_getScreenPtr_asm
    ex de, hl

    ld hl, #_sprite_corazon

    ld c, #4
    ld b, #9
    call cpct_drawSprite_asm

    ;; CORAZON 4

    ld de, #0xC000
    ld c, #14
    ld b, #00
    call cpct_getScreenPtr_asm
    ex de, hl

    ld hl, #_sprite_corazon

    ld c, #4
    ld b, #9
    call cpct_drawSprite_asm

    ;; CORAZON 5

    ld de, #0xC000
    ld c, #18
    ld b, #00
    call cpct_getScreenPtr_asm
    ex de, hl

    ld hl, #_sprite_corazon

    ld c, #4
    ld b, #9
    call cpct_drawSprite_asm

    ;; CORAZON 6

    ld de, #0xC000
    ld c, #22
    ld b, #00
    call cpct_getScreenPtr_asm
    ex de, hl

    ld hl, #_sprite_corazon

    ld c, #4
    ld b, #9
    call cpct_drawSprite_asm



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
    ;;call sys_ui_add_round
    ld l, #0    ;; Color de la letra
    ld h, #9    ;; Color del fondo
    call cpct_setDrawCharM0_asm   ;; Set draw char colours
;      ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
    ld c,   #23
    ld b,   #17
    call cpct_getScreenPtr_asm
    call get_round
    and #0x0F
    add #48  ;; primer digito en Ascii
    ld e, a
    call cpct_drawCharM0_asm    
    
    ;;ex de, hl   
    ;;ld   iy, #puntString   ;; IY = Pointer to the string 
    ;;call cpct_drawStringM0_asm  ;; Draw the string     
    
    call sys_ui_init_food_life

ret


sys_ui_erase_heart::

    ld a, e_lifes(ix)

    cp #5
    jr z, delete_heart_6
    cp #4
    jr z, delete_heart_5
    cp #3
    jr z, delete_heart_4
    cp #2
    jr z, delete_heart_3
    cp #1
    jr z, delete_heart_2
    cp #0
    jr z, delete_heart_1

    delete_heart_6:
        ld de, #0xC000
        ld c, #22
        ld b, #00
        call cpct_getScreenPtr_asm
        ex de, hl

        ld c, #4
        ld b, #9

        ld a, #0x00
        call cpct_drawSolidBox_asm
        ret
    delete_heart_5:
        ld de, #0xC000
        ld c, #18
        ld b, #00
        call cpct_getScreenPtr_asm
        ex de, hl

        ld c, #4
        ld b, #9

        ld a, #0x00
        call cpct_drawSolidBox_asm
        ret
    delete_heart_4:
        ld de, #0xC000
        ld c, #14
        ld b, #00
        call cpct_getScreenPtr_asm
        ex de, hl

        ld c, #4
        ld b, #9

        ld a, #0x00
        call cpct_drawSolidBox_asm
        ret
    delete_heart_3:
        ld de, #0xC000
        ld c, #10
        ld b, #00
        call cpct_getScreenPtr_asm
        ex de, hl

        ld c, #4
        ld b, #9

        ld a, #0x00
        call cpct_drawSolidBox_asm
        ret

    delete_heart_2:
        ld de, #0xC000
        ld c, #06
        ld b, #00
        call cpct_getScreenPtr_asm
        ex de, hl

        ld c, #4
        ld b, #9

        ld a, #0x00
        call cpct_drawSolidBox_asm
        ret
    delete_heart_1:
        ld de, #0xC000
        ld c, #02
        ld b, #00
        call cpct_getScreenPtr_asm
        ex de, hl

        ld c, #4
        ld b, #9

        ld a, #0x00
        call cpct_drawSolidBox_asm
        ret
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

sys_ui_food_damaged::
    ld a, (food_life)
    dec a
    call z, sys_ui_food_die
    ld (food_life), a
    call sys_ui_food_decrease
ret


;;AQUI DIBUJAREMOS SOBRE LA BARRA DE VIDA DISMINUYENDO

sys_ui_draw_food_counter::

    ld de, #0xC000
    ld c, #31      ;; 61
    ld b, #85       ;; 2
    call cpct_getScreenPtr_asm
    ex de, hl
    ld c, #18
    ld b, #6

    ld a, #0xFF
    call cpct_drawSolidBox_asm

    ld de, #0xC000
    ld c, #32       ;; 62
    ld b, #86       ;; 3
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #16
    ld b, #4

    ld a, #0x30
    call cpct_drawSolidBox_asm


    ld a, (food_life)
    and a
    jr z, no_comida

        ld de, #0xC000
        ld c, #32       ;; 62
        ld b, #86       ;; 3
        call cpct_getScreenPtr_asm
        ex de, hl

        ld a, (food_life)
        ld c, a
        ld b, #4

        ld a, #0xF0
        call cpct_drawSolidBox_asm

    ;dibuja barra verde


    no_comida:
ret


sys_ui_init_food_life::

    ld a, #16
    ld (food_life), a

    ld de, #0xC000
    ld c, #31      ;; 61
    ld b, #85       ;; 2
    call cpct_getScreenPtr_asm
    ex de, hl

    ld hl, #food_life_pos

    ld (hl), e
    inc hl
    ld (hl), d

    ld hl, #food_life_pos
    ;;ex de, hl
    ld e, (hl)
    inc hl
    ld d, (hl)

    ld c, #18
    ld b, #6

    ld a, #0xFF
    call cpct_drawSolidBox_asm



    ld de, #0xC000
    ld c, #32       ;; 62
    ld b, #86       ;; 3
    call cpct_getScreenPtr_asm
    ex de, hl

    ld hl, #food_life_pos

    ld (hl), e
    inc hl
    ld (hl), d

    ld hl, #food_life_pos
    ;;ex de, hl
    ld e, (hl)
    inc hl
    ld d, (hl)

    ld c, #16
    ld b, #4

    ld a, #0xF0
    call cpct_drawSolidBox_asm

    ld de, #0xC000
    ld c, #48       ;; 78
    ld b, #86        ;; 3
    call cpct_getScreenPtr_asm
    ex de, hl

    ld hl, #food_life_pos

    ld (hl), e
    inc hl
    ld (hl), d
ret

sys_ui_food_decrease::
    ld hl, #food_life_pos
    dec (hl)
    ld e, (hl)
    inc hl
    ld d, (hl)
    ld c, #1
    ld b, #4
    ld a, #0x30
    call cpct_drawSolidBox_asm
ret

;;AQUI LA VIDA DE LA COMIDA ES 0
sys_ui_food_die::
    call sys_ui_food_decrease
    call screen_man_death_screen
ret
