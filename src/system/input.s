;; INIT OF PHYSICS.S

.include "cpctelera.h.s"
.include "./manager/entities.h.s"
.include "cpct_globals.h.s"
.include "./entities/bullet.h.s"

.globl _sprite_char_D1
.globl _sprite_char_L1
.globl _sprite_char_U1
.globl _sprite_char_R1


cooldown: .db #0
shoot_dir: .db #0
is_shooting: .db #0

current_cool == 20;19
;; ----------------------------------------
;; Puts actions in certain keys
;; ----------------------------------------
keyactions:: ;;el eje horizontal tendra prioridad ya que hay mas enemigos de los lados
    .dw Key_Space, key_space_action
    .dw Key_W, key_up_action
    .dw Key_S, key_down_action
    .dw Key_A, key_left_action
    .dw Key_D, key_right_action
    .dw 0x0000



;;receives A
change_shoot_dir:
    ld hl, #is_shooting
    inc (hl)
    dec (hl)
    jr nz, exit_csd


    ld hl, #shoot_dir
    ld (hl), a

    cp #0
    jr z, sprite_up
    cp #1

    jr z, sprite_right
    cp #2

    jr z, sprite_down
    cp #3
    jr z, sprite_left

    sprite_up:
    ld hl, #_sprite_char_U1
    jr end_csd

    sprite_right:
    ld hl, #_sprite_char_R1

    jr end_csd

    sprite_down:
    ld hl, #_sprite_char_D1

    jr end_csd

    sprite_left:
    ld hl, #_sprite_char_L1

    
    end_csd:
    ld e_sprite(ix), l
    ld e_sprite+1(ix), h
    exit_csd:
ret

;; ------------------------------------
;;  Horizontal movement
;; ------------------------------------

key_left_action::
    ld e_vx(ix), #-1      ;-1
    ld e_vx+1(ix), #0xA0  ;+0.A0 (hex) (-0.6hex) -0,35 mas o menos

    ld hl, #is_shooting
    inc (hl)
    dec (hl)
    jr z, fast_kla
        ld e_vx(ix), #-1
        ld e_vx+1(ix), #0xD0

    fast_kla:

    ld a, #3
    call change_shoot_dir
ret

key_right_action::
    ld e_vx(ix), #0       ;0
    ld e_vx+1(ix), #0x60  ;+0.60 (hex) (+0.6hex) 0,35 mas o menos


    ld hl, #is_shooting
    inc (hl)
    dec (hl)
    jr z, fast_kra
        ld e_vx(ix), #0
        ld e_vx+1(ix), #0x30

    fast_kra:

    ld a, #1
    call change_shoot_dir
ret

;; ------------------------------------
;;  Vertical movement
;; ------------------------------------
key_up_action::
    ld e_vy(ix), #-1

    ld hl, #is_shooting
    inc (hl)
    dec (hl)
    jr z, fast_kua
        ld e_vy(ix), #-1
        ld e_vy+1(ix), #0x80

    fast_kua:

    ld a, #0
    call change_shoot_dir
ret

key_down_action::
    ld e_vy(ix), #1

    ld hl, #is_shooting
    inc (hl)
    dec (hl)
    jr z, fast_kda
        ld e_vy(ix), #0
        ld e_vy+1(ix), #0x80

    fast_kda:


    ld a, #2
    call change_shoot_dir
ret

;; ------------------------------------
;;  Extra action: shoot
;; ------------------------------------

key_space_action::
    ;; TODO: shoot

    ld hl, #is_shooting
    ld (hl), #1


    ld hl, #cooldown
    inc (hl)
    dec (hl)
    jr nz, no_bullet

    ld (hl), #current_cool;;cooldown

    ld h, e_x(ix)
    ld l, e_y(ix)
    ld a, (#shoot_dir)
    push ix
    call create_bullet
    pop ix

    no_bullet:
ret




;;ix entidad
sys_input_check_keyboard_and_update_player::
    ld e_vx(ix), #0
    ld e_vy(ix), #0
    ld e_vx+1(ix), #0
    ld e_vy+1(ix), #0

    ld hl, #is_shooting
    ld (hl), #0

    ld hl, #cooldown
    inc (hl)
    dec (hl)
    jr z, cont_cool

    dec (hl)
    
    cont_cool:
    call cpct_scanKeyboard_f_asm

    ld iy, #keyactions-4
    
    ;; Checks if any key is pressed
    nextkey:
        ld bc, #4
        add iy, bc
        
        ;; Check next key code
        ld l, (iy)
        ld h, 1(iy)
        
        ;; Check for null to end
        ld a, l
        or h
        ret z

        ;; Test Key and perform
        call cpct_isKeyPressed_asm
    jr z, nextkey

    ;; Key is pressed, perform key_left_action
    ld hl, #nextkey
    push hl
    ld l, 2(iy)
    ld h, 3(iy)
    jp (hl)

;; --------------------------------------
;;  Update all entities' physics
;;  B -> mask for filter
;; --------------------------------------

sys_input_update::


    ;xor a   ;; A = 0
    ;call man_entity_get_from_idx
    ;call sys_input_check_keyboard_and_update_player

    ld hl, #sys_input_check_keyboard_and_update_player
    ld b, #e_cmps_input
    call man_entity_forall_matching
ret

