.include "./manager/entities.h.s"
.include "cpctelera.h.s"
.include "collision.h.s"
.globl spawn_enemy1

.module sys_collision

num_entities2: .db 0x00
cooldown_damaged: .db 0x01
damaged: .db 0x01
collision_entities: .db 0x00

sys_collision_control_init::
    call man_entity_collision_getArray
    ld (_ent_array_ptr), hl
ret
 
.macro saveSetBorder _color
    push hl
    cpctm_setBorder_asm _color
    pop hl
.endm
;;HL funciona como iterador
;;DE almacenamos el puntero
;;IX funciona como entidad 1
;;IY funciona como entidad 2


sys_collision_control_init_entities::
    call man_entity_first_entity
    ld (_ent_array_ptr), hl
ret

sys_collision_update_all_entities::
;;    ld b, #e_cmps_physics
;;
;;    call man_entity_first_entity
;;
;;    ld a, (num_entities2)
;;    cp #1
;;    jr z, exit
;;
;;    ld a,e_cmps(ix) ;;si la primera entidad es invalida, salimos de la funcion
;;    and #0xFF
;;    jr z, exit
;;
;;    next_ix:
;;        push bc
;;
;;        ld a, e_cmps(ix)
;;        and b
;;        cp b
;;        jr nz, next_ix_valid
;;
;;        call man_next_entity_iy_iterator
;;        pop bc
;;        jr next_iy
;;
;;        next_ix_valid:
;;            call man_next_entity
;;
;;            ld a,e_cmps(ix)
;;            and #0xFF
;;            pop bc
;;            jr nz, next_ix
;;            jr exit
;;        next_ix_after_iy:
;;            push bc
;;            call man_next_entity
;;            pop bc
;;            ld a,e_cmps(ix)
;;            and #0xFF
;;            jr nz, next_ix
;;            jr exit
;;
;;    next_iy:
;;        push bc
;;
;;        ld a, e_cmps(iy)
;;        and b
;;        cp b
;;        jr nz, next_iy_valid
;;        jr check
;;
;;        next_iy_valid:
;;            call man_next_entity_iy
;;            ld a,e_cmps(iy)
;;            and #0xFF
;;            pop bc
;;            jr nz, next_ix_after_iy
;;            jr next_iy
;;
;;        ;;CHECK COLLISION BETWEEN ENTITIES IX AND IY
;;        ;;DESTROY AF
;;        check:
;;            call sys_collision_check
;;            jr nc, collision;; jr c, no_collision
;;            
;;            
;;            no_collision:
;;                ld a, #0xFF
;;                ld (0xC01A), a
;;                call man_next_entity_iy
;;                pop bc
;;                jr next_iy
;;            collision:
;;                call check_entities_type_collision
;;                call man_next_entity_iy
;;                pop bc
;;                jr next_iy
;;    exit:
;;        ;;ld a, #0xFF
;;        ;;ld (0xC000), a
;;    call man_entity_first_entity
ret





sys_collision_update::    
    _ent_array_ptr = . + 1  ld hl, #0x0000
    ld a, (num_entities2)
    cp #1
    jr z, exit
    next_ix:
        ld e, (hl)
        inc hl
        ld d, (hl)
        inc hl

        ;;Comprobamos que el puntero no es null
        ld a, e
        or d
        ;;ret z ;;Fin
        jr z, exit
        ;;Almacenamos la siguiente posicion para la siguiente iteración
        push hl
        
        ld__ixl_e
        ld__ixh_d

    next_iy:

        ld e, (hl)
        inc hl
        ld d, (hl)
        inc hl

        ;;Comprobamos que el "segundo iterador" no es null
        ld a, e
        or d
        jr z, null
        
        ld a, (collision_entities)
        cp #1
        jr z, null

        ld__iyl_e
        ld__iyh_d

        ;;CHECK COLLISION BETWEEN ENTITIES IX AND IY
        ;;DESTROY AF
        call check_entities_type_collision
        jr next_iy

    null:
        pop hl
        ld a, #0
        ld (collision_entities), a
        jr next_ix
    exit:
        ;;ld a, #0xFF
        ;;ld (0xC000), a
ret

;;IX entity 1
;;IY entity 2

check_entities_type_collision::

    ld a, e_type(ix)
    cp #0
    jr z, mainCharacter

    cp #1
    jr z, enemyCollision

    cp #3
    jr z, bulletCollision


    enemyCollision:

    ld b, e_type(iy)
    add a, b ;;Enemy
    cp #4
    jr z, bulletEnemy
    jr nz, skip

    bulletEnemy:
        call sys_collision_check
        jr nc, collision
    ret


    bulletCollision:

    ld b, e_type(iy)
    add a, b ;;Enemy
    cp #4
    jr z, bulletEnemy2
    jr nz, skip

    bulletEnemy2:
        call sys_collision_check
        jr nc, collision
    ret

    mainCharacter:
    ld b, e_type(iy)
    add a, b ;;Enemy/Bullet
    cp #1
    jr z, enemy
    jr nz, skip

    enemy:
        call sys_collision_check
        jr nc, collision_character

        ld a, (#cooldown_damaged)
        cp #1
        jr z, skip

        ld a, (#cooldown_damaged)
        dec a
        ld (#cooldown_damaged), a

    ret

    ;;Personaje principal muere

    collision_character:
        ld a, (#cooldown_damaged)
        dec a
        jr nz, not_damaged
            call man_entity_damaged
            ld a, #200
            ld (#cooldown_damaged), a
            ld a, #1
            ld (#damaged), a
            call spawn_enemy1
            jp skip
        not_damaged:
            ld (#cooldown_damaged), a
    jp skip

    collision:
        call man_entity_damaged
        call man_entity_damaged_IY
        ld a, #1
        ld (collision_entities), a
    skip:

ret

sys_collision_check::
    ;;if (a<b)
    ;;a = e_x(ix)+e_w(ix) < e_x(iy)
    ;;a = e_x(ix)+e_w(ix) - e_x(iy) < 0

    ld a, e_x(ix)
    add e_w(ix)
    sub e_x(iy)
    ret c

    ld a, e_y(ix)
    add e_h(ix)
    sub e_y(iy)
    ret c

    ;;if (c<d)
    ;;a = e_x(iy)+e_w(iy) < e_x(ix)
    ;;a = e_x(iy)+e_w(iy) - e_x(ix) < 0

    ld a, e_x(iy)
    add e_w(iy)
    sub e_x(ix)
    ret c

    ;;Colision en Y

    ld a, e_y(iy)
    add e_h(iy)
    sub e_y(ix)

ret

