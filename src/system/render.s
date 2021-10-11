;; INIT OF RENDER.S

.include "./manager/entities.h.s"
.include "cpct_globals.h.s"
.globl _g_palette
.globl _sprite_char

;; ---------------------------------------------
;; Updates all the entities
;; B -> Mask to filter
;; ---------------------------------------------
sys_render_update::
    ld hl, #sys_render_forone
    ld b, #e_cmps_render ;; e_cmps_render
    call man_entity_forall_matching
ret

;; -----------------------------------------
;; Renders one entity
;; IX -> entity
;; -----------------------------------------
sys_render_forone::

    ld c, e_w(ix)
    ld b, e_h(ix)

    ld e, e_prv_ptr+0(ix)
    ld d, e_prv_ptr+1(ix)
    xor a
    call cpct_drawSolidBox_asm

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
    call cpct_drawSprite_asm
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
ret