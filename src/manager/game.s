;; GAME MANAGER

.include "entities.h.s"
.include "./entities/bullet.h.s"
.include "./system/physics.h.s"
.include "./system/input.h.s"
.include "./system/render.h.s"
.include "cpctelera.h.s"
.include "./system/cpct_globals.h.s"
.include "./system/ai_control.h.s"

.globl _sprite_char

cmps == e_cmps_position | e_cmps_alive | e_cmps_render | e_cmps_physics | e_cmps_input

;; Structure of templates:
;;  cmps - x - y - vx - vy - w - h - color - e_type - sprite_ptr - prevpos
;mainchar_entity: .db cmps , #0, #0, #0, #0, #3, #12,#0x0F, #e_type_mainchar, #0, #0, #e_ai_st_noAI
;.dw #0x0000, #0x0000
               ;.ds sizeof_e-1
mainchar_entity: .db cmps
.ds sizeof_e-1

cmps == e_cmps_position | e_cmps_alive | e_cmps_physics | e_cmps_render
enemy_entity: .db cmps
.ds sizeof_e-1


;e_cmps      == 0
;e_x         == 1
;e_y         == 2
;e_vx        == 3
;e_vy        == 4
;e_w         == 5
;e_h         == 6
;e_type      == 7
;
;e_ai_aim_x  == 8
;e_ai_aim_y  == 9
;e_ai_st     == 10
;
;e_color == 11
;
;e_sprite    == 12     ;; Pointer, 2 bytes
;e_prv_ptr   == 14     ;; Pointer, 2 bytes

build_player:
   ld ix, #mainchar_entity
   ld e_x(ix), #20
   ld e_y(ix), #20
   ld e_vx(ix), #0
   ld e_vy(ix), #0
   ld e_w(ix), #4
   ld e_h(ix), #18
   ld e_type(ix), #e_type_mainchar

   ld e_color(ix), #0x0F

   ld hl, #_sprite_char
   ld (#mainchar_entity+e_sprite), hl

ret

build_enemy:
   ld ix, #enemy_entity
   ld e_x(ix), #20
   ld e_y(ix), #20
   ld e_vx(ix), #0
   ld e_vy(ix), #0
   ld e_w(ix), #4
   ld e_h(ix), #18
   ld e_type(ix), #e_type_enemy

   ld e_color(ix), #0x0F

   ld hl, #_sprite_char
   ld (#enemy_entity+e_sprite), hl

ret


game_man_init::

    call build_player
    call build_enemy

    call sys_render_init

    ld hl, #mainchar_entity 
    call man_entity_create

    ld hl, #enemy_entity
    call man_entity_create
ret

game_man_update::
   cpctm_setBorder_asm HW_RED
   call sys_render_update

   cpctm_setBorder_asm HW_YELLOW
   call man_entity_update


   cpctm_setBorder_asm HW_GREEN
   call sys_input_update

   
   cpctm_setBorder_asm HW_BLUE
      call sys_ai_control_update
      call sys_physics_update

    
   
   cpctm_setBorder_asm HW_WHITE

   call cpct_waitVSYNC_asm
ret