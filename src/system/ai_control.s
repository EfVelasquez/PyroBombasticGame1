;; INIT OF PHYSICS.S

.include "cpctelera.h.s"
.include "./manager/entities.h.s"

.module sys_ai_control

sys_ai_control_init::

ret

sys_ai_control_update::

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

    ld e_vx(ix), #1
ret 

sys_ai_move_to:
    ld e_vx(ix), #0
    ld e_vy(ix), #0
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
        ;;ld e_vx(ix), #-1
        ;;ld e_vy(ix), #-1
    no_AI_ent:

ret

