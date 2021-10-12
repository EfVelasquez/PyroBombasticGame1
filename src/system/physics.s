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

    ld e_x(ix), h
    ld e_x+1(ix), l



    ld h,e_y(ix)
    ld l,e_y+1(ix)

    ld b,e_vy(ix)
    ld c,e_vy+1(ix)

    add hl,bc

    ld e_y(ix), h
    ld e_y+1(ix), l


    ;ld a, e_x(ix)
    ;ld b, e_vx(ix) ;se carga en a la posicion en x
    ;add a,b ;se suman, posicion en x + velocidad
    ;
    ;jp m, no_x
;
;
    ;ld b, e_w(ix)
    ;add a,b
    ;
    ;cp #81
    ;
;
    ;jr nc, no_x
    ;sub b
;
    ;ld e_x(ix), a ;se guarda en la posicion en x la nueva
;
    ;no_x:
;
;
    ;;ld a, e_y(ix)
    ;;ld b, e_vy(ix) ;se carga en a la posicion en x
    ;;add a,b ;se suman, posicion en x + velocidad
    ;;ld e_y(ix), a ;se guarda en la posicion en x la nueva
;
;
    ;;;;;;;;;;;;;;;;;;
    ;ld a, e_y(ix)
    ;ld b, e_vy(ix) ;se carga en a la posicion en y
    ;add a,b ;se suman, posicion en x + velocidad
    ;
    ;;jp m, end_rend ;;;;ESTA LINEA ME DETIENE A MITAD DE LA PANTALLA
    ;inc a
    ;jp z, end_rend
    ;dec a
;
;
    ;ld b, e_h(ix)
    ;add a,b
    ;
    ;cp #201
    ;
;
    ;jr nc, end_rend
    ;sub b
;
    ;ld e_y(ix), a ;se guarda en la posicion en x la nueva
;
    ;end_rend:
;
ret

