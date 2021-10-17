.include "./manager/entities.h.s"

.globl cpct_getRandom_lcg_u8_asm

.globl _sprite_e1_1


en_cmps == e_cmps_position | e_cmps_alive | e_cmps_physics | e_cmps_render
enemy_entity: .db en_cmps
.ds sizeof_e-1




;-------
spwn1_x =  39
spwn1_y =  30 ;arriba
spwn1_vx = 0
spwn1_vy = 1

spwn2_x =  39
spwn2_y =  178 ;abajo
spwn2_vx = 0
spwn2_vy = -1

spwn3_x =  2
spwn3_y =  60 ;izq arr
spwn3_vx = 1
spwn3_vy = 0

spwn4_x =  75
spwn4_y =  60 ;der arr
spwn4_vx = -1
spwn4_vy = 0

spwn5_x =  2
spwn5_y =  140 ;izq abaj
spwn5_vx = 1
spwn5_vy = 0

spwn6_x =  75
spwn6_y =  140 ;der abaj
spwn6_vx = -1
spwn6_vy = 0
;--------





spawn_enemy1::
   ld ix, #enemy_entity
   ;----
   ld l, #0
   call cpct_getRandom_lcg_u8_asm
   ld a,l
   and #7

   cp #0
   jp z, es_0

   cp #1
   jp z, es_1

   cp #2
   jp z, es_2

   cp #3
   jp z, es_3

   cp #4
   jp z, es_4

   cp #5
   jp z, es_5

   cp #6
   jp z, es_0

   cp #7
   jp z, es_1




   es_0:
   ld e_x(ix), #spwn1_x
   ld e_y(ix), #spwn1_y
   ld e_vx(ix), #0
   ld e_vy(ix), #0
   ld e_vy+1(ix), #0x80
   jr after_calc_enem


   es_1:
    ld e_x(ix), #spwn2_x
   ld e_y(ix), #spwn2_y
   ld e_vx(ix), #0
   ld e_vy(ix), #-1
   ld e_vy+1(ix), #0x80
   jr after_calc_enem

   es_2:
    ld e_x(ix), #spwn3_x
   ld e_y(ix), #spwn3_y
   ld e_vx(ix), #0
   ld e_vx+1(ix), #0x40
   ld e_vy(ix), #0
   ld e_vy+1(ix), #0
   jr after_calc_enem

   es_3:
   ld e_x(ix), #spwn4_x
   ld e_y(ix), #spwn4_y
   ld e_vx(ix), #-1
   ld e_vx+1(ix), #0xC0
   ld e_vy(ix), #0
   ld e_vy+1(ix), #0
   jr after_calc_enem


   es_4:
    ld e_x(ix), #spwn5_x
   ld e_y(ix), #spwn5_y
   ld e_vx(ix), #0
   ld e_vx+1(ix), #0x40
   ld e_vy(ix), #0
   ld e_vy+1(ix), #0
   jr after_calc_enem


   es_5:
    ld e_x(ix), #spwn6_x
   ld e_y(ix), #spwn6_y
   ld e_vx(ix), #-1
   ld e_vx+1(ix), #0xC0
   ld e_vy(ix), #0
   ld e_vy+1(ix), #0
   jr after_calc_enem


   ;ld e_x(ix), h
   ;ld e_y(ix), l
   ;ld e_vx(ix), #1
   ;ld e_vy(ix), #0
   after_calc_enem:
   ;----
   
   ;;ld e_vx(ix), #0x00
   ;;ld e_vx+1(ix), #0x00
   ;;ld e_vy(ix), #0x00
   ;;ld e_vy+1(ix), #0
   ld e_w(ix), #4
   ld e_h(ix), #18
   ld e_type(ix), #e_type_enemy

   ld e_ai_st(ix), #e_ai_st_move_to_food

   ld hl, #_sprite_e1_1
   ld (#enemy_entity+e_sprite), hl

   ld hl, #enemy_entity
   call man_entity_create
ret