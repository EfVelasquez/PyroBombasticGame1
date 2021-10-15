.include "./manager/entities.h.s"

.globl cpct_getRandom_lcg_u8_asm

.globl _sprite_e1_1


en_cmps == e_cmps_position | e_cmps_alive | e_cmps_physics | e_cmps_render
enemy_entity: .db en_cmps
.ds sizeof_e-1




;-------
spwn1_x =  37
spwn1_y =  0
spwn1_vx = 0
spwn1_vy = 1

spwn2_x =  37
spwn2_y =  170
spwn2_vx = 0
spwn2_vy = -1

spwn3_x =  2
spwn3_y =  100
spwn3_vx = 1
spwn3_vy = 0

spwn4_x =  70
spwn4_y =  100
spwn4_vx = -1
spwn4_vy = 0
;--------





spawn_enemy1::
   ld ix, #enemy_entity
   ;----
   ld l, #0
   call cpct_getRandom_lcg_u8_asm
   ld a,l
   and #3

   cp #0
   jr z, es_0

   cp #1
   jr z, es_1

   cp #2
   jr z, es_2

   cp #3
   jr es_3




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


   ;ld e_x(ix), h
   ;ld e_y(ix), l
   ;ld e_vx(ix), #1
   ;ld e_vy(ix), #0
   after_calc_enem:
   ;----
   

   ld e_w(ix), #4
   ld e_h(ix), #18
   ld e_type(ix), #e_type_enemy

   ld e_color(ix), #0x0F

   ld hl, #_sprite_e1_1
   ld (#enemy_entity+e_sprite), hl

   ld hl, #enemy_entity
   call man_entity_create
ret