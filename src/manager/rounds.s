


.globl spawn_enemy1

spawner_time == 125 ;;en updates max 256
round_end_time == 2

round:: .db #1
max_enems: .db #3
curr_enems: .db #0
enems_to_spawn: .db #5
enems_left_to_spawn: .db #5
enems_left: .db #5

spawn_timer: .db spawner_time

time_to_next_round: .db #round_end_time

get_round::
    ld a, (round)
ret

init_round_1::
    ld hl, #round
    ld (hl), #5

    ld hl, #max_enems
    ld (hl), #3

    ld hl, #curr_enems
    ld (hl), #0

    ld hl, #enems_to_spawn
    ld (hl), #5

    
    ld a, (#enems_to_spawn)
    ld hl, #enems_left
    ld (hl), a

    ld a, (#enems_to_spawn)
    ld hl, #enems_left_to_spawn
    ld (hl), a

    ld hl, #time_to_next_round
    ld (hl), #round_end_time
ret

enemy_died::

    ld hl, #curr_enems
    dec (hl)

    ld hl, #enems_left
    dec (hl)

ret

inc_maxenems:
    ld hl, #max_enems
    inc (hl)
ret

next_round:
    ld hl, #round
    inc (hl)


    ld a, (hl)
    cp #5
    call z, inc_maxenems;;maxenems aumentará de 3 a 4 en la ronda 5
    cp #10
    ;call z, inc_maxenems ;;maxenems aumentará de 4 a 5 en la ronda 10

    ld hl, #curr_enems
    ld (hl), #0

    ld hl, #enems_to_spawn
    inc (hl)
    inc (hl)

    ld a, (#enems_to_spawn)
    ld hl, #enems_left
    ld (hl), a

    ld a, (#enems_to_spawn)
    ld hl, #enems_left_to_spawn
    ld (hl), a

    

    ld hl, #time_to_next_round
    ld (hl), #round_end_time

ret

spawner_check:
    ld a, #spawner_time
    ld (spawn_timer), a ;;actualizo el timer a 100

    ld a, (enems_left) ;;chequeo si ya spawnee todos los enemigos
    or a 
    jr z, next_round_check

    ld a, (max_enems)
    ld b, a
    ld a, (curr_enems)
    cp b
    jr z, end_spawn_check ;;si el numero de enemigos curr y max es distinto, se spawnea enemigo

    ld a, (enems_left_to_spawn) 
    cp #0
    jr z, end_spawn_check

    call spawn_enemy1
    ld hl, #curr_enems
    inc (hl)
    ld hl, #enems_left_to_spawn
    dec (hl)
    jr end_spawn_check

    next_round_check:
    ld a, (time_to_next_round)
    or a
    jr z, go_to_next_round
    dec a
    ld (time_to_next_round), a
    jr end_spawn_check

    go_to_next_round:

    call next_round

    end_spawn_check:
ret



update_rounds::
    ld a, (spawn_timer)
    cp #0
    jr nz, skip_update_rounds

    call spawner_check

    ld a, (round)
    cp #7
    call nc, spawner_check

    skip_update_rounds:
    ld hl, #spawn_timer
    dec (hl)
ret