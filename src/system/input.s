;; INIT OF PHYSICS.S

.include "cpctelera.h.s"
.include "./manager/entities.h.s"
.globl man_entity_forall
.globl man_entity_create
.globl cpct_isKeyPressed_asm
.globl cpct_scanKeyboard_f_asm

;; ----------------------------------------
;; Puts actions in certain keys
;; ----------------------------------------
keyactions::
    .dw Key_A, key_left_action
    .dw Key_D, key_right_action
    .dw Key_W, key_up_action
    .dw Key_S, key_down_action
    .dw Key_Space, key_space_action
    .dw 0x0000

;; ------------------------------------
;;  Horizontal movement
;; ------------------------------------
key_left_action::
    ld e_vx(ix), #-1
ret

key_right_action::
    ld e_vx(ix), #1
ret

;; ------------------------------------
;;  Vertical movement
;; ------------------------------------
key_up_action::
    ld e_vy(ix), #-2
ret

key_down_action::
    ld e_vy(ix), #3
ret

;; ------------------------------------
;;  Extra action: shoot
;; ------------------------------------

cmps == e_cmps_position | e_cmps_alive | e_cmps_physics | e_cmps_render
bullet_entity:: .db cmps, 0, 0, #0, #-1, #0x08, #0x01, #0x0F, e_type_bullet

key_space_action::
    ;; TODO: shoot
    ld hl, #bullet_entity
    call man_entity_create
ret

;;ix entidad
sys_input_check_keyboard_and_update_player::
    ld e_vx(ix), #0
    ld e_vy(ix), #0


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

