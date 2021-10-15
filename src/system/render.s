;; INIT OF RENDER.S

.include "cpctelera.h.s"
.include "./manager/entities.h.s"
.include "cpct_globals.h.s"
.globl _g_palette
.globl _sprite_char

;; ---------------------------------------------
;; Updates all the entities
;; B -> Mask to filter
;; ---------------------------------------------
sys_render_update::
<<<<<<< HEAD
    ;call sys_render_clear_screen
=======
>>>>>>> b0d6138c94ab0ea399b8e84291467c0e1ea9d94d
    ld hl, #sys_render_forone
    call man_entity_forall
ret

;; -----------------------------------------
;; Renders one entity
;; IX -> entity
;; -----------------------------------------

sys_render_delete::

    ld c, e_w(ix)
    ld b, e_h(ix)

    ld e, e_prv_ptr+0(ix)
    ld d, e_prv_ptr+1(ix)
    ld a, #0x3C
    call cpct_drawSolidBox_asm
ret


sys_render_forone::
    cpctm_setBorder_asm HW_WHITE
    call sys_render_delete

    ld de, #0xC000
    ld c, e_x(ix)
    ld b, e_y(ix)
    call cpct_getScreenPtr_asm
    ex de, hl

    ld e_prv_ptr+0(ix), e
    ld e_prv_ptr+1(ix), d

    ;ld hl, #_sprite_char

    ld h, e_sprite+1(ix)
    ld l, e_sprite+0(ix)

    ld c, e_w(ix)
    ld b, e_h(ix)

    inc h
    dec h
    jr nz, rend_sprite
    inc l
    dec l
    jr nz, rend_sprite


    ld a, e_color(ix)
    call cpct_drawSolidBox_asm
    jr final_rend

    rend_sprite:

    call cpct_drawSprite_asm

    final_rend:
    cpctm_setBorder_asm HW_RED
ret

sys_render_wait::
    ld a, #18
    halts:
        halt
        halt
        dec a
        jr nz, halts
ret


sys_render_init::
    ld c, #0 ;modo 0
    call cpct_setVideoMode_asm

    ld hl, #_g_palette
    ld de, #16
    call cpct_setPalette_asm


    cpctm_clearScreen_asm #0x3C
ret