;; This file contains all the indexes to adress to the entities

.module Entity_Manager

;;------------------------------------------------------
;; Entities
;; Definition of entity structure fields

e_cmps      == 0
e_x         == 1 ;2 bytes
e_y         == 3 ;2 bytes
e_vx        == 5 ;2 bytes
e_vy        == 7 ;2 bytes
e_w         == 9
e_h         == 10
e_type      == 11
e_ai_st     == 12
e_sprite    == 13    ;; Pointer, 2 bytes
e_prv_ptr   == 15    ;; Pointer, 2 bytes
e_lifes     == 17    ;; Lifes of both character and enemy
e_level     == 18    ;; Dificultad de los enemigos (velocidad)

e_fs1       == 19
e_fs2       == 20
e_fs3       == 21
e_fs4       == 22
e_fs5       == 23

;; Entity info
sizeof_e        == 24
max_entities    == 30

;; Entity AI enum status
e_ai_st_noAI            == 0
e_ai_st_stand_by        == 1
e_ai_st_move_to         == 2
e_ai_st_move_to_food    == 3
;; Bit for matching & properties

e_cmps_alive_bit     = 7
e_cmps_position_bit  = 6
e_cmps_input_bit     = 5
e_cmps_physics_bit   = 4
e_cmps_render_bit    = 3
;;-----
e_cmps_todestroy_bit = 1

;; Component Types (masks)
e_cmps_invalid    = 0x00
e_cmps_alive      = (1 << e_cmps_alive_bit)
e_cmps_position   = (1 << e_cmps_position_bit)
e_cmps_input      = (1 << e_cmps_input_bit)
e_cmps_physics    = (1 << e_cmps_physics_bit)
e_cmps_render     = (1 << e_cmps_render_bit)
e_cmps_todestroy  = (1 << e_cmps_todestroy_bit)
e_cmps_default    = 0xFF

;; Entity types
e_type_mainchar     = 0
e_type_enemy        = 1
e_type_floor        = 2
e_type_bullet       = 3

;; Public functions
.globl man_entity_init
.globl man_entity_create
.globl man_entity_destroy
.globl man_entity_forall
.globl man_entity_forall_matching
.globl man_entity_forall_pairs_matching
.globl man_entity_get_from_idx
.globl man_entity_set4destruction
.globl man_entity_update
.globl cpct_memcpy_asm
.globl man_entity_increase_num
.globl man_entity_decrease_num
.globl mainchar_entity
.globl man_entity_first_entity
.globl man_entity_getFirstEntity_IY
.globl man_entity_set4destruction_IY
;.globl man_next_entity_iy_iterator
;.globl man_next_entity_iy
.globl man_next_entity
.globl more_enemies
