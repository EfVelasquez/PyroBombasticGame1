;; GAME MANAGER

.include "entities.h.s"
.include "rounds.h.s"
.include "./entities/bullet.h.s"
.include "./system/physics.h.s"
.include "./system/input.h.s"
.include "./system/render.h.s"
.include "cpctelera.h.s"
.include "./system/cpct_globals.h.s"
.include "./system/ai_control.h.s"
.include "./system/collision.h.s"
.include "./system/collision_sys.h.s"
.include "screen.h.s"
.include "./system/ui.h.s"

.globl _sprite_char_D1
.globl spawn_enemy1

cmps == e_cmps_position | e_cmps_alive | e_cmps_render | e_cmps_physics | e_cmps_input

;; Structure of templates:
;;  cmps - x - y - vx - vy - w - h - color - e_type - sprite_ptr - prevpos
;mainchar_entity: .db cmps , #0, #0, #0, #0, #3, #12,#0x0F, #e_type_mainchar, #0, #0, #e_ai_st_noAI
;.dw #0x0000, #0x0000
               ;.ds sizeof_e-1
mainchar_entity: .db cmps
.ds sizeof_e-1

restart_game:: .db #0


pos_enemies: .db #0

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
   ld e_y(ix), #140
   ld e_vx(ix), #0
   ld e_vy(ix), #0
   ld e_w(ix), #4
   ld e_h(ix), #18
   ld e_type(ix), #e_type_mainchar
   ld e_lifes(ix), #6
   ld e_playerctr(ix), #1

   ld hl, #_sprite_char_D1
   ld (#mainchar_entity+e_sprite), hl

   ld hl, #mainchar_entity 
   call man_entity_create

ret


;;HL -> coordenadas
;spawn_enemy1::
;   ld ix, #enemy_entity
;   ld e_x(ix), h
;   ld e_y(ix), l
;   ld e_vx(ix), #1
;   ld e_vy(ix), #0
;   ld e_w(ix), #4
;   ld e_h(ix), #18
;   ld e_type(ix), #e_type_enemy
;
;   ld e_color(ix), #0x0F
;
;   ld hl, #_sprite_e1_1
;   ld (#enemy_entity+e_sprite), hl
;
;   ld hl, #enemy_entity
;   call man_entity_create
;ret

create_enemies:
   ld b, #1
   bucle:
   ld a, (pos_enemies)
   
   ld h,#10;;coordenada x
   ld l,a;;coordenada y
   push af
   push bc
   call spawn_enemy1
   pop bc
   pop af
   add a,#30
   ld (pos_enemies),a

   dec b
   jr nz, bucle
ret

game_man_init::
   call sys_render_init_palette
   call screen_man_title_screen
   
   call man_entity_init
   call sys_collision_control_init
   call init_round_1


   ;call build_enemy
   ;call create_enemies

   call sys_render_init

   call build_player
   
   call sys_ui_init

   
    ;;ld hl, #enemy_entity
    ;;call man_entity_create
    ;;call build_enemy2
    ;;ld hl, #enemy_entity
    ;;call man_entity_create
    ld a, #0
    ld (restart_game), a

ret

game_man_update::
   cpctm_setBorder_asm HW_RED
   call sys_render_update

   cpctm_setBorder_asm HW_YELLOW
   call man_entity_update


   cpctm_setBorder_asm HW_GREEN
   call sys_input_update
   call sys_ai_control_update

   cpctm_setBorder_asm HW_PINK
      call sys_collision_update
      
   cpctm_setBorder_asm HW_BLUE
      call sys_ai_control_update
      call sys_physics_update

   call update_rounds
   
    
   
   cpctm_setBorder_asm HW_BRIGHT_WHITE


   ld a, (restart_game)
   and a
   call nz, screen_man_death_screen
   

   call cpct_waitVSYNC_asm
ret