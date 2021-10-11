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

    ld a, e_x(ix)
    ld b, e_vx(ix) ;se carga en a la posicion en x
    add a,b ;se suman, posicion en x + velocidad
    ld e_x(ix), a ;se guarda en la posicion en x la nueva


    ld a, e_y(ix)
    ld b, e_vy(ix) ;se carga en a la posicion en x
    add a,b ;se suman, posicion en x + velocidad
    ld e_y(ix), a ;se guarda en la posicion en x la nueva

ret

