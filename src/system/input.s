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
key_actions::
    .dw Key_O, key_left_action
    .dw Key_P, key_right_action
    .dw Key_Q, key_up_action
    .dw Key_A, key_down_action
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
    ld e_vy(ix), #2
ret

;; ------------------------------------
;;  Extra action: shoot
;; ------------------------------------
key_space_action::
    ;; TODO
ret

sys_input_check_keyboard_and_update_player:
    ;; Reset velocity
    ld e_vx(ix), #0
    ld e_vy(ix), #0

    ;; Check keyboard for input
    call cpct_scanKeyboard_f_asm

    ;; Key-Action Check-call Looop
    ld iy, #key_actions-4

    loop_keys:
        ld bc, #4
        add iy, bc
        ld l, 0(iy) ;; HL = Next Key
        ld h, 1(iy) ;;

        ;; Check if key is null
        ld a, l ;; A = H | L
        or h
        ret z   ;; A = 0, Key = null, ret
        
        ld hl, #loop_keys ;; ret
        push hl
        call cpct_isKeyPressed_asm
        ld l, 2(iy)
        ld h, 3(iy)
        jp(hl)
    ;; ret is implicit
;; --------------------------------------
;;  Update all entities' physics
;;  B -> mask for filter
;; --------------------------------------

sys_input_update::
    ;;xor a   ;; A = 0
    ;;call man_entity_get_from_idx
    ;;call sys_input_check_keyboard_and_update_player

    ld hl, #sys_input_check_keyboard_and_update_player
    ld b, #e_cmps_input
    call man_entity_forall_matching
ret

