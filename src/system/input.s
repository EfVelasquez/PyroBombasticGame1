;; INIT OF PHYSICS.S

.include "cpctelera.h.s"
.include "./manager/entities.h.s"
.include "cpct_globals.h.s"
.include "./entities/bullet.h.s"

cooldown: .db #0
shoot_dir: .db #0
is_shooting: .db #0
;; ----------------------------------------
;; Puts actions in certain keys
;; ----------------------------------------
keyactions::
    .dw Key_Space, key_space_action
    .dw Key_A, key_left_action
    .dw Key_D, key_right_action
    .dw Key_W, key_up_action
    .dw Key_S, key_down_action
    .dw 0x0000



;;receives A
change_shoot_dir:
    ld hl, #is_shooting
    inc (hl)
    dec (hl)
    jr nz, end_csd


    ld hl, #shoot_dir
    ld (hl), a
    
    end_csd:
ret

;; ------------------------------------
;;  Horizontal movement
;; ------------------------------------

key_left_action::
    ld e_vx(ix), #-1

    ld a, #3
    call change_shoot_dir
ret

key_right_action::
    ld e_vx(ix), #1

    ld a, #1
    call change_shoot_dir
ret

;; ------------------------------------
;;  Vertical movement
;; ------------------------------------
key_up_action::
    ld e_vy(ix), #-1

    ld a, #0
    call change_shoot_dir
ret

key_down_action::
    ld e_vy(ix), #1

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

    ld (hl), #19

    ld h, e_x(ix)
    ld l, e_y(ix)
    ld a, (#shoot_dir)
    call create_bullet

    no_bullet:
ret




;;ix entidad
sys_input_check_keyboard_and_update_player::
    ld e_vx(ix), #0
    ld e_vy(ix), #0

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
    xor a   ;; A = 0
    call man_entity_get_from_idx
    call sys_input_check_keyboard_and_update_player

    ;ld hl, #sys_input_check_keyboard_and_update_player
    ;ld b, #e_cmps_input
    ;call man_entity_forall_matching
ret

