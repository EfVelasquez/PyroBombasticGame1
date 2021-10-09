;; INIT OF PHYSICS.S

.include "cpctelera.h.s"
.include "./manager/entities.h.s"
.globl man_entity_forall

;; --------------------------------------
;;  Update all entities' physics
;;  B -> mask for filter
;; --------------------------------------

sys_physics_update::
    ld hl, #phy_update_forone
    ld b, #e_cmps_input ;; Condition: entity must have input
    call man_entity_forall_matching
ret


phy_update_forone::
ret

