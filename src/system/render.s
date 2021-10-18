;; INIT OF RENDER.S

.include "cpctelera.h.s"
.include "./manager/entities.h.s"
.include "cpct_globals.h.s"
.globl _g_palette
.globl _sprite_char
.globl _sprite_puerta_arr
.globl _sprite_puerta_abaj
.globl _sprite_puerta_lat
.globl _sprite_puerta_lat_der
.globl _sprite_vent
.globl _sprite_vent_abaj
.globl _sprite_poster
.globl _sprite_comida


;; ---------------------------------------------
;; Updates all the entities
;; B -> Mask to filter
;; ---------------------------------------------
sys_render_update::
    ;call sys_render_clear_screen
    call draw_food
    
    ld hl, #sys_render_forone
    call man_entity_forall
ret





draw_room::

    ;;;;;;;;Barra negra de arriba

    ld de, #0xC000
    ld c, #0 ;x
    ld b, #0;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #64 ;x
    ld b, #10;y

    ld a, #0x00
    call cpct_drawSolidBox_asm

    ld de, #0xC000
    ld c, #64 ;x
    ld b, #0;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #16 ;x
    ld b, #10;y

    ld a, #0x00
    call cpct_drawSolidBox_asm
    ;;;;;;Pared Superior

    ld de, #0xC000
    ld c, #0 ;x
    ld b, #10;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #64 ;x
    ld b, #20;y

    ld a, #0xC3
    call cpct_drawSolidBox_asm

    ld de, #0xC000
    ld c, #64 ;x
    ld b, #10;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #16 ;x
    ld b, #20;y

    ld a, #0xC3
    call cpct_drawSolidBox_asm

    ;;;Paredes laterales

    ld de, #0xC000
    ld c, #0 ;x
    ld b, #30;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #1 ;x
    ld b, #170;y

    ld a, #0xC3
    call cpct_drawSolidBox_asm

    ld de, #0xC000
    ld c, #79 ;x
    ld b, #30;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #1 ;x
    ld b, #170;y

    ld a, #0xC3
    call cpct_drawSolidBox_asm

    ;; Pared abajo

    ld de, #0xC000
    ld c, #1 ;x
    ld b, #195;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #64 ;x
    ld b, #5;y

    ld a, #0xC3
    call cpct_drawSolidBox_asm

    ld de, #0xC000
    ld c, #64 ;x
    ld b, #195;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #16 ;w
    ld b, #5;h

    ld a, #0xC3
    call cpct_drawSolidBox_asm

    ;;;;Contornos arriba

    ld de, #0xC000
    ld c, #2 ;x
    ld b, #29;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #64 ;w
    ld b, #1;h

    ld a, #0x00
    call cpct_drawSolidBox_asm

    ld de, #0xC000
    ld c, #66 ;x
    ld b, #29;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #12 ;w
    ld b, #1;h

    ld a, #0x00
    call cpct_drawSolidBox_asm
    ;;contornos abajo

    ld de, #0xC000
    ld c, #2 ;x
    ld b, #195;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #64 ;w
    ld b, #1;h

    ld a, #0x00
    call cpct_drawSolidBox_asm

    ld de, #0xC000
    ld c, #66 ;x
    ld b, #195;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #12 ;w
    ld b, #1;h

    ld a, #0x00
    call cpct_drawSolidBox_asm

    ;;;Contornos

    ld de, #0xC000
    ld c, #1 ;x
    ld b, #29;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #1 ;x
    ld b, #167;y

    ld a, #0x82
    call cpct_drawSolidBox_asm

    ld de, #0xC000
    ld c, #78 ;x
    ld b, #29;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #1 ;x
    ld b, #167;y

    ld a, #0x41
    call cpct_drawSolidBox_asm

    ;;puertas
    ld de, #0xC000
    ld c, #34 ;x
    ld b, #15;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #12 ;x
    ld b, #15;y

    ld a, #0x00
    call cpct_drawSolidBox_asm

    ld de, #0xC000
    ld c, #34 ;x
    ld b, #195;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #12 ;x
    ld b, #5;y

    ld a, #0x00
    call cpct_drawSolidBox_asm

    ;lados 48 alto

    ld de, #0xC000
    ld c, #0 ;x
    ld b, #49;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #2 ;x
    ld b, #48;y

    ld a, #0x00
    call cpct_drawSolidBox_asm

    ld de, #0xC000
    ld c, #78 ;x
    ld b, #49;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #2 ;x
    ld b, #48;y

    ld a, #0x00
    call cpct_drawSolidBox_asm

    ;;;;
    ld de, #0xC000
    ld c, #0 ;x
    ld b, #128;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #2 ;x
    ld b, #48;y

    ld a, #0x00
    call cpct_drawSolidBox_asm

    ld de, #0xC000
    ld c, #78 ;x
    ld b, #128;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #2 ;x
    ld b, #48;y

    ld a, #0x00
    call cpct_drawSolidBox_asm

    ld de, #0xC000
    ld c, #32 ;x
    ld b, #16;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #2 ;x
    ld b, #13;y

    ld hl, #_sprite_puerta_arr

    call cpct_drawSprite_asm

    ld de, #0xC000
    ld c, #46 ;x
    ld b, #16;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #2 ;x
    ld b, #13;y

    ld hl, #_sprite_puerta_arr

    call cpct_drawSprite_asm

    ;;puerta abajo

    ld de, #0xC000
    ld c, #46 ;x
    ld b, #196;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #2 ;x
    ld b, #4;y

    ld hl, #_sprite_puerta_abaj

    call cpct_drawSprite_asm

    ld de, #0xC000
    ld c, #32 ;x
    ld b, #196;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #2 ;x
    ld b, #4;y

    ld hl, #_sprite_puerta_abaj

    call cpct_drawSprite_asm

    ;;puertas laterales

    ld de, #0xC000
    ld c, #0 ;x
    ld b, #176;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #2 ;x
    ld b, #6;y

    ld hl, #_sprite_puerta_lat

    call cpct_drawSprite_asm

    ld de, #0xC000
    ld c, #0 ;x
    ld b, #97;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #2 ;x
    ld b, #6;y

    ld hl, #_sprite_puerta_lat

    call cpct_drawSprite_asm

    ld de, #0xC000
    ld c, #0 ;x
    ld b, #43;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #2 ;x
    ld b, #6;y

    ld hl, #_sprite_puerta_lat

    call cpct_drawSprite_asm

    ld de, #0xC000
    ld c, #0 ;x
    ld b, #122;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #2 ;x
    ld b, #6;y

    ld hl, #_sprite_puerta_lat

    call cpct_drawSprite_asm

    ;;puertas laterales derecha

    ld de, #0xC000
    ld c, #78 ;x
    ld b, #176;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #2 ;x
    ld b, #6;y

    ld hl, #_sprite_puerta_lat_der

    call cpct_drawSprite_asm

    ld de, #0xC000
    ld c, #78 ;x
    ld b, #97;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #2 ;x
    ld b, #6;y

    ld hl, #_sprite_puerta_lat_der

    call cpct_drawSprite_asm

    ld de, #0xC000
    ld c, #78 ;x
    ld b, #43;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #2 ;x
    ld b, #6;y

    ld hl, #_sprite_puerta_lat_der

    call cpct_drawSprite_asm

    ld de, #0xC000
    ld c, #78 ;x
    ld b, #122;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #2 ;x
    ld b, #6;y

    ld hl, #_sprite_puerta_lat_der

    call cpct_drawSprite_asm

ret


draw_decorations:
    
    ld de, #0xC000
    ld c, #4 ;x
    ld b, #10;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #15 ;x
    ld b, #19;y

    ld hl, #_sprite_vent

    call cpct_drawSprite_asm

    ld de, #0xC000
    ld c, #51 ;x
    ld b, #10;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #15 ;x
    ld b, #19;y

    ld hl, #_sprite_vent

    call cpct_drawSprite_asm

    ld de, #0xC000
    ld c, #53 ;x
    ld b, #196;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #18 ;x
    ld b, #4;y

    ld hl, #_sprite_vent_abaj

    call cpct_drawSprite_asm
    
    ld de, #0xC000
    ld c, #7 ;x
    ld b, #196;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #18 ;x
    ld b, #4;y

    ld hl, #_sprite_vent_abaj

    call cpct_drawSprite_asm
    



    ld de, #0xC000
    ld c, #69 ;x
    ld b, #12;y
    call cpct_getScreenPtr_asm
    ex de, hl

    ld c, #7 ;x
    ld b, #16;y

    ld hl, #_sprite_poster

    call cpct_drawSprite_asm
ret


draw_food:
    ld de, #0xFB93
    ;ld c, #36 ;x
    ;ld b, #93;y
    ;call cpct_getScreenPtr_asm
    ;ex de, hl

    ld c, #9 ;x
    ld b, #33;y

    ld hl, #_sprite_comida

    call cpct_drawSprite_asm

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
    ;;cpctm_setBorder_asm HW_WHITE
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

    ;;inc h
    ;;dec h
    ;;jr nz, rend_sprite
    ;;inc l
    ;;dec l
    ;;jr nz, rend_sprite
    ld a, e_type(ix)
    cp #e_type_bullet
    jr nz, rend_sprite


    ld a, e_color(ix) ;; Color de la bala
    call cpct_drawSolidBox_asm
    jr final_rend

    rend_sprite:

    call cpct_drawSprite_asm

    final_rend:
    ;;cpctm_setBorder_asm HW_RED
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

    cpctm_clearScreen_asm #0x3C
    call draw_room
    call draw_decorations
ret

sys_render_init_palette::
    ld c, #0 ;modo 0
    call cpct_setVideoMode_asm

    ld hl, #_g_palette
    ld de, #16
    call cpct_setPalette_asm
    ret