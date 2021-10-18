.include "./manager/entities.h.s"
.include "cpctelera.h.s"

.module entity_collision_manager

_collision_ptr_array: .ds #2*max_entities
.dw #00
_collision_ptr_pend: .dw _collision_ptr_array

collisions == 0

;;DefineComponentPointersArrayStructure_Size, _collision , max_entities

;;Devuelve Hl como puntero al principio del array

man_entity_collision_init::

    ld hl, #_collision_ptr_array
    ld (_collision_ptr_pend), hl
    
    ;;Poner todas las posiciones a null
    xor a
    ld (hl), a
    ld d, h
    ld e, l
    inc de
    ld bc, #2*max_entities-1
    ldir
    
    ;;Esto no acaba aqui, si no en la siguiente funcion que
    ;;forma parte de esta y por si sola tmb funciona

man_entity_collision_getEnd::
    ld hl, #_collision_ptr_pend
ret


man_entity_collision_getArray::
    ld hl, #_collision_ptr_array
ret

man_entity_collision_add::
    ;;Añadir una nueva entidad 
    ;;al array de punteros
    ld hl, (_collision_ptr_pend)
    ld__a_ixl
    ld (hl), a
    inc hl
    ld__a_ixh
    ld (hl), a

    inc hl
    ld (_collision_ptr_pend), hl
    
    ret

man_collision_delete::
    ld hl, (_collision_ptr_pend)
    dec hl
    ld (hl), #0x00
    dec hl
    ld (hl), #0x00
    ld (_collision_ptr_pend), hl
ret