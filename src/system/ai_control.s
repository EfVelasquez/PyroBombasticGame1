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
    ld a, e_fs1(ix)
    dec a
    jr nz, not_damaged_food
        call man_entity_food_damaged
        ld a, #200 ;;Tiempo entre hit y hit 50 = 1 Segundo
        ld e_fs1(ix), a
        ret
    not_damaged_food:
        ld e_fs1(ix), a
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
    ;;chequear que este (por ejemplo, ya lo cambiaremos)
    ;; x entre 35 y 45
    ;; y entre 90 y 10

    ;jr (lo que sea), standby ;;Si el chequeo dio true, se vuelve standby
    ld a, e_x(ix)
    cp #31
    jp m, move_to_food
    cp #45
    jr nc, move_to_food

    ld a, e_y(ix)
    cp #78
    jp m, move_to_food
    cp #128
    jr nc, move_to_food

    jp standby
 
    move_to_food:

    ld a, #36   ;; X Objetivo
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
    standby:
    ld e_ai_st(ix), #e_ai_st_stand_by
    ld e_vx(ix), #0
    ld e_vx+1(ix), #0
    ld e_vy(ix), #0
    ld e_vy+1(ix), #0
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

    cp #e_ai_st_move_to
    jr nz, next_movement
    call sys_ai_move_to
    ret
    next_movement:
    cp #e_ai_st_move_to_food
    jr nz, next_movement_food
    call sys_ai_move_to_food
    ret
    next_movement_food:
    cp #e_ai_st_stand_by
    jr nz, no_AI_ent
    call sys_ai_stand_by

    no_AI_ent:

ret

