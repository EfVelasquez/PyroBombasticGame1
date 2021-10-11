
.include "./manager/entities.h.s"
.globl _sprite_char
cmps == e_cmps_position | e_cmps_alive | e_cmps_physics | e_cmps_render


;;                   cmps - x - y - vx - vy - w - h - color - e_type- -prevpos  
bullet_entity::   .db cmps, 0, 0, #0, #0, #0x01, #0x04, #0x0F, e_type_bullet, #0, #0, #e_ai_st_noAI
                    .dw _sprite_char, #0x0000


bullet_speed == 1

;;recibir en h->x en l->y
;;recibir en a velocidad
create_bullet::
    ld ix, #bullet_entity
    ld e_x(ix), h
    ld e_y(ix), l

    ld e_color(ix), #0xCC
    ld e_sprite(ix), #00
    ld e_sprite+1(ix), #00

    cp #0
    jr z, up
    cp #1
    jr z, right
    cp #2
    jr z, down
    cp #3   
    jr z, left


    up:
    ld e_vy(ix), #-2*bullet_speed
    ld e_vx(ix), #0*bullet_speed

    jr finish_config_bullet


    down:
    ld e_vy(ix), #2*bullet_speed
    ld e_vx(ix), #0*bullet_speed

    jr finish_config_bullet


    left:
    ld e_vy(ix), #0*bullet_speed
    ld e_vx(ix), #-1*bullet_speed

    jr finish_config_bullet


    right:
    ld e_vy(ix), #0*bullet_speed
    ld e_vx(ix), #1*bullet_speed


    finish_config_bullet:


    ld hl, #bullet_entity
    call man_entity_create
ret