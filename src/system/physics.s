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

;;recibe IX
phy_update_forone::

    ld h,e_x(ix)
    ld l,e_x+1(ix)

    ld b,e_vx(ix)
    ld c,e_vx+1(ix)

    add hl,bc

    
    ld a,h
    cp #0
    jp m, no_x
    
    add e_w(ix)
    cp #81
    jr nc, no_x

    ld e_x(ix), h
    ld e_x+1(ix), l


    no_x:
    ld h,e_y(ix)
    ld l,e_y+1(ix)

    ld b,e_vy(ix)
    ld c,e_vy+1(ix)

    add hl,bc

    

    ld a,h
    cp #-2
    jr nc, no_y
    
    add e_h(ix)
    cp #201
    jr nc, no_y

    ld e_y(ix), h
    ld e_y+1(ix), l


    no_y:


ret

