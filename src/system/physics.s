;; INIT OF PHYSICS.S

.include "cpctelera.h.s"
.include "./manager/entities.h.s"
;; --------------------------------------
;;  Update all entities' physics
;;  B -> mask for filter
;; --------------------------------------

sys_physics_update::
    ld hl, #phy_update_forone
    ld b, #e_cmps_physics ;; Condition: entity must have physics
    call man_entity_forall_matching
ret


wall: .db #0

;;recibe IX
phy_update_forone::
    cpctm_setBorder_asm HW_WHITE
    ld hl, #wall
    ld (hl), #0

    ld h,e_x(ix)
    ld l,e_x+1(ix)

    ld b,e_vx(ix)
    ld c,e_vx+1(ix)

    add hl,bc

    
    ld a,h
    cp #2
    jp m, no_x
    
    add e_w(ix)
    cp #79
    jr nc, no_x

    ld e_x(ix), h
    ld e_x+1(ix), l

    jr skip_x

    no_x:
    ld hl, #wall
    ld (hl), #1

    skip_x:

;;;;;;;;;;;;;;;;;;;;;;;;;; Y
    ld h,e_y(ix)
    ld l,e_y+1(ix)

    ld b,e_vy(ix)
    ld c,e_vy+1(ix)

    add hl,bc

    

    ld a,h
    cp #30
    jr c, no_y
    
    add e_h(ix)
    cp #196
    jr nc, no_y

    ld e_y(ix), h
    ld e_y+1(ix), l


    jr skip_y

    no_y:
    ld hl, #wall
    ld (hl), #1

    skip_y:




    ld a, e_type(ix)
    cp #e_type_bullet
    jr nz, end_phy

    ;ld a, e_vx(ix)
    ;add a, e_vx+1(ix)
    ;add a, e_vy(ix)
    ;add a, e_vy+1(ix)

    ld a, (#wall)
    cp #0

    jr z, end_phy
    call man_entity_set4destruction

    end_phy:
    cpctm_setBorder_asm HW_BLUE
ret

