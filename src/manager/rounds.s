


.globl spawn_enemy1

spawner_time == 100 ;;en updates
round_end_time == 2

round:: .db #1
max_enems: .db #3
curr_enems: .db #0
enems_to_spawn: .db #5

spawn_timer: .db spawner_time

time_to_next_round: .db #round_end_time

init_round_1::
    ld hl, #round
    ld (hl), #1

    ld hl, #max_enems
    ld (hl), #3

    ld hl, #curr_enems
    ld (hl), #0

    ld hl, #enems_to_spawn
    ld (hl), #5

    ld hl, #time_to_next_round
    ld (hl), #round_end_time
ret

enemy_died::

    ld hl, #curr_enems
    dec (hl)

ret

next_round:
    call init_round_1

ret

spawner_check:
    ld a, #spawner_time
    ld (spawn_timer), a ;;actualizo el timer a 100

    ld a, (enems_to_spawn) ;;chequeo si ya spawnee todos los enemigos
    or a 
    jr z, next_round_check

    ld a, (max_enems)
    ld b, a
    ld a, (curr_enems)
    cp b
    jr z, end_spawn_check ;;si el numero de enemigos curr y max es distinto, se spawnea enemigo

    ;ld a, (enems_to_spawn) 
    ;cp #0
    ;jr z, end_spawn_check

    call spawn_enemy1
    ld hl, #curr_enems
    inc (hl)
    ld hl, #enems_to_spawn
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
    call z, spawner_check

    dec a
    ld (spawn_timer), a
ret