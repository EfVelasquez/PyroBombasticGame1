;; INIT OF PHYSICS.S

.include "cpctelera.h.s"
.include "./manager/entities.h.s"

.module sys_ai_control

sys_ai_control_init::

ret

sys_ai_control_update::
    call man_entity_getFirstEntity_IY
    ld hl, #sys_ai_control_update_forone
    call man_entity_forall
ret

sys_ai_stand_by:
    ;; call man_entity_getFirstEntity_IY
    ;; ;; Key is not pressed
    ;; ld a, e_ai_aim_x(iy)
    ;; or a
    ;; ret z
;; 
    ;; ;; Key is pressed. Move to player
    ;; ld a, e_x(iy)
    ;; ld e_ai_aim_x(ix), a
    ;; ld a, e_y(iy)
    ;; ld e_ai_aim_y(ix), a
    ;; ld e_ai_st(ix), #e_ai_st_move_to
    call man_entity_set4destruction
ret 


sys_ia_movement:
    ;;if (a<b)
    ;;a = e_x(ix)+e_w(ix) < e_x(iy)
    ;;a = e_x(ix)+e_w(ix) - e_x(iy) < 0

    ld a, e_x(iy)
    cp e_x(ix)

    jp m, left_ia
    jr z, arrives_x

    ld e_vx(ix), #0
    ld e_vx+1(ix), #0x10
    jr next_pos

    left_ia:
    ld e_vx(ix), #-1
    ld e_vx+1(ix), #0xE0
    jr next_pos

    arrives_x:
    ld e_vx(ix), #0
    ld e_vx+1(ix), #0
    ld a, e_type(ix)

    next_pos:

    ld a, e_y(iy)
    cp e_y(ix)

    jp m, up_ia
    jr z, arrives_y

    ld e_vy(ix), #0
    ld e_vy+1(ix), #0x30
    jr next_pos_Y

    up_ia:
    ld e_vy(ix), #-1
    ld e_vy+1(ix), #0xC0
    jr next_pos_Y

    arrives_y:
    ld e_vy(ix), #0
    ld e_vy+1(ix), #0
    next_pos_Y:




    ;;ld a, e_y(iy)
    ;;add e_y(iy)
    ;;jr c, up_ia
    ;;ld e_vy(ix), #1
    ;;jr skip_ia
    ;;up_ia:
    ;;ld e_vy(ix), #-1
;;
    ;;skip_ia:

ret

enemy_arrived: .db 0x00

sys_ai_movement_food:
    ld a, #50   ;; X Objetivo
    ld (enemy_arrived), a
    cp e_x(ix)  ;; Esto controla al zombi
    jp m, left_ia_food  ;; Esto significa que se mueve hacia la izquierda
    jr z, arrives_x_food

    ld e_vx(ix), #0
    ld e_vx+1(ix), #0x10
    jr next_pos_food

    left_ia_food:
    ld e_vx(ix), #-1
    ld e_vx+1(ix), #0xE0
    jr next_pos_food

    arrives_x_food:
    ld e_vx(ix), #0
    ld e_vx+1(ix), #0
    ld a, #1
    ld (enemy_arrived), a
    ;;ld a, e_type(ix)
    ;;ld e_ai_st(ix), #e_ai_st_stand_by

    next_pos_food:

    ld a, #100  ;; Cargas la Y
    cp e_y(ix)

    jp m, up_ia_food
    jr z, arrives_y_food

    ;; Cuando el enemigo va hacia abajo
    ld e_vy(ix), #0
    ld e_vy+1(ix), #0x30
    jr next_pos_Y_food

    up_ia_food:
    ld e_vy(ix), #-1
    ld e_vy+1(ix), #0xC0
    jr next_pos_Y_food

    arrives_y_food:
    ld e_vy(ix), #0
    ld e_vy+1(ix), #0
    ld a, (enemy_arrived)
    inc a
    ld (enemy_arrived), a
    ;;ld e_ai_st(ix), #e_ai_st_stand_by
    next_pos_Y_food:
    ld a, (enemy_arrived)
    cp #2
    jr nz, _skip
    ;;ld a, e_vy(ix)
    ;;cp #0
    ;;jr nz, _skip
    ;;cp #2
    ;;jr nz, _skip
    ld e_ai_st(ix), #e_ai_st_stand_by
    _skip:
ret


sys_ai_move_to:
    call sys_ia_movement
ret

sys_ai_move_to_food:
    call sys_ai_movement_food
ret


sys_ai_control_update_forone:
    ld a, e_ai_st(ix)
    cp #e_ai_st_noAI
    jr z, no_AI_ent
    AI_ent:
        cp #e_ai_st_stand_by
        call z, sys_ai_stand_by
        cp #e_ai_st_move_to
        call z, sys_ai_move_to
        cp #e_ai_st_move_to_food
        call z, sys_ai_move_to_food
        ;;ld e_vx(ix), #-1
        ;;ld e_vy(ix), #-1
    no_AI_ent:

ret

