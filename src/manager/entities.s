;; INIT OF ENTITIES.S
.include "entities.h.s"
.include "rounds.h.s"
.include "./system/collision.h.s"
.include "./system/render.h.s"
.include "screen.h.s"

next_free_entity: .dw array_entities
current_entity: .dw array_entities
num_entities: .db 0 ;; Actual number of entities created
array_entities: .ds sizeof_e * max_entities
array_end: .db 0x00

num_enemies: .db 0x01
food_life: .db 0x0A
food_life_pos: .db 0x00
.globl spawn_enemy1

more_enemies::
    ld a, (#num_enemies)
    ld a, #1
    ld (#num_enemies), a
ret
;; Functions for entities

;; Initializes the array of entities
man_entity_init::

    call man_entity_collision_init

ret

;;recibo en hl la template
;; Creates the entity
man_entity_create::
    ;; Is there free space?
    ld a, (num_entities)
    cp #max_entities
    jr z, skip_ce
     
    ;; Free space -> create entity
    ;; ld hl, #mainchar_entity ;; From
    ld de, (next_free_entity) ;; To
    ld bc, #sizeof_e ;; Size
    ldir    ;; Changes AF, BC, DE, HL

    ld ix, (next_free_entity)
    ld a, e_cmps(ix)
    and #e_cmps_physics
    call nz, man_entity_collision_add
    ;;volver a cargar 'a' desde 'ix' o se jode todo jeje

    ;; Increase free entity
    ld hl, (next_free_entity)
    ld bc, #sizeof_e
    add hl, bc
    ld (next_free_entity), hl
    call man_entity_increase_num

    ;; No free space -> Skip
    skip_ce:
ret

;DELETES CURRENT ENTITY
man_entity_destroy:

    ld ix, (current_entity)
    call sys_render_delete
    ld a, e_type(ix)
    cp #e_type_enemy
    jr nz, nop

    ;call spawn_enemy1
    call enemy_died

    nop:
    cp #e_type_mainchar
    call z, screen_man_death_screen

    ld a, e_cmps(ix)
    cp #e_cmps_invalid
    jr z, skip_delete ;si la entidad ya esta muerta, no hago nada

    ;; Decrease free entity
    ld hl, (next_free_entity)
    ld bc, #-sizeof_e
    add hl, bc
    ld (next_free_entity), hl


    ld de, (current_entity)

    ;si hl (last_free entity) y de (current entity) son iguales, deberiamos saltar a final_delete
    ld a, h
    cp d
    jr nz, #are_different_delete ;;si h y d son distintos, se hace el memcpy
    ld a, l
    cp e
    jr z, #final_delete ;;si h y d son iguales, y l y e son iguales, no se hace memcpy


    are_different_delete:
    ld bc, #sizeof_e

    push hl

    call cpct_memcpy_asm ;;copiamos el contenido de la ultima entidad en la que vamos a borrar

    pop hl

    final_delete:
    ld (hl), #e_cmps_invalid ;hacemos invalida a la ultima entidad

    call man_entity_decrease_num

    call man_collision_delete
    

    skip_delete:
ret 

;; Pointer to function
function_for_all: .db #0x00, #0x00
;; ----------------------------------------------------------- ;;
;; INPUT -> HL: contains the function                          ;;
;; General function to apply to all entities                   ;;
;; ----------------------------------------------------------- ;;
man_entity_forall::
    ld (function_for_all), hl
    call man_entity_first_entity ;; IX points to the first entity

    ld a,e_cmps(ix) ;;si la primera entidad es invalida, salimos de la funcion
    and #0xFF
    jr z, final

    loop_forall:
        ld hl, #afterjp
        push hl

        ld hl, (function_for_all)
        jp (hl)

        afterjp:


        call man_next_entity
        
        
        ld a,e_cmps(ix)
        and #0xFF
    jr nz, loop_forall

    final:
        call man_entity_first_entity
ret

;; ---------------------------------------------
;; Applies a function filtering specific criteria
;; B -> Mask of bytes (e_cmps)
;; ---------------------------------------------
man_entity_forall_matching::
    ld (function_for_all), hl
    call man_entity_first_entity ;; IX points to the first entity

    ld a,e_cmps(ix) ;;si la primera entidad es invalida, salimos de la funcion
    and #0xFF
    jr z, final

    loop_forall_matching:
        push bc ;;guardo mascara de bytes
        ld a, e_cmps(ix)
        and b
        cp b
        jr nz, afterjp_matching

        
        ld hl, #afterjp_matching
        push hl

        ld hl, (function_for_all)
        jp (hl)

        afterjp_matching:


        call man_next_entity
        
        ld a,e_cmps(ix)
        and #0xFF
        pop bc
    jr nz, loop_forall_matching

    final_matching:
        call man_entity_first_entity
ret

;; ----------------------------------------------------
;;  Compares a pair of entities under a specific criteria
;;  IY -> The other pair
;;  B -> Mask to filter
;; -----------------------------------------------------
man_entity_forall_pairs_matching::
ret 

;; INPUT: A -> ID of the entity
;; OUTPUT: IX -> The entity
man_entity_get_from_idx::

    cp #max_entities
    jr nc, ret_last_ent_gfi ;;si el idx es mayor o igual a max entities, cambio A por max_entities-1 (ultima entidad)
    jr cont_gfi

    ret_last_ent_gfi:
    ld a, #max_entities-1

    cont_gfi:

    ;; Acceder al elemento 4 de un array de 4 campos
    ;; array[3] = inicio + (3*4)
    call man_entity_first_entity

    cp #0
    jr z, end_gfi

    loop_gfi:
        call man_next_entity
        dec a
    jr nz, loop_gfi


    end_gfi:
ret 

;;Receives by ix

man_entity_set4destruction::
    ld e_cmps(ix), #e_cmps_todestroy
ret

man_entity_set4destruction_IY::
    ld e_cmps(iy), #e_cmps_todestroy
    
ret


man_entity_update:: ;; Updates all entities to be destroyed
    
    ld hl, #man_entity_destroy
    ld b, #e_cmps_todestroy
    call man_entity_forall_matching
    
ret

;;Receives by ix

man_entity_damaged::
    ld a, e_lifes(ix)
    dec a
    call z, man_entity_set4destruction
    ld e_lifes(ix), a
ret

man_entity_damaged_IY::
    ld a, e_lifes(iY)
    dec a
    call z, man_entity_set4destruction_IY
    ld e_lifes(iy), a
ret

man_entity_food_damaged::
    ld a, (food_life)
    dec a
    ld (food_life), a
    jr z, end_life_food
    ld h, #0xC0
    ld a, (#food_life_pos)
    inc a
    ld l, a
    ld (#food_life_pos), a
    ld a, #0xFF
    ld (hl), a
    ret
    end_life_food:
    ld h, #0xC0
    ld a, (#food_life_pos)
    inc a
    ld l, a
    ld (#food_life_pos), a
    ld a, #0xF0
    ld (hl), a

ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; ITERADOR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


man_entity_increase_num: ;; Increases the value of the counter num_entities
    ld hl, #num_entities
    inc (hl)
ret

man_entity_decrease_num: ;; Decreases the value of the counter num_entities
    ld hl, #num_entities
    dec (hl)
ret



man_entity_first_entity:: ;; Changes the entity controller to ix register
    ld hl, #array_entities
    ld (current_entity), hl
    ld ix, (current_entity)
ret

man_next_entity:: ;;aumenta la posicion de current entity
    ld hl, (current_entity)
    ld bc, #sizeof_e
    add hl, bc
    ld (current_entity), hl
    ld ix, (current_entity)
ret

;man_next_entity_iy_iterator:: ;;aumenta la posicion de current entity
;    ld hl, (current_entity)
;    ld bc, #sizeof_e
;    add hl, bc
;    ld (current_entity_iy), hl
;    ld iy, (current_entity_iy)
;ret
;
;man_next_entity_iy::
;    ld hl, (current_entity_iy)
;    ld bc, #sizeof_e
;    add hl, bc
;    ld (current_entity_iy), hl
;    ld iy, (current_entity_iy)
;ret

man_get_current_entity::
    ld ix, (current_entity)
ret

man_entity_getFirstEntity_IY::
    ld iy, #array_entities
ret

man_entity_getArray::
    ld hl, #array_entities
ret

man_get_num_entities::
    ld a, #num_entities
ret