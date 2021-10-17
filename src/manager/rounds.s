


.globl spawn_enemy1

spawner_time == 100 ;;en updates


round:: .db #1
max_enems: .db #3
curr_enems: .db #0
enems_to_spawn: .db #5

spawn_timer: .db spawner_time


init_round_1::
    ld hl, #round
    ld (hl), #1

    ld hl, #max_enems
    ld (hl), #3

    ld hl, #curr_enems
    ld (hl), #0
ret

enemy_died::

    ld hl, #curr_enems
    dec (hl)

ret

spawner_check:
    ld a, #spawner_time
    ld (spawn_timer), a

    ld a, (max_enems)
    ld b, a
    ld a, (curr_enems)
    cp b
    jr z, no_spawn

    ld a, (enems_to_spawn)
    cp #0
    jr z, no_spawn

    call spawn_enemy1
    ld hl, #curr_enems
    inc (hl)
    ld hl, #enems_to_spawn
    dec (hl)

    no_spawn:
ret



update_rounds::
    ld a, (spawn_timer)
    cp #0
    call z, spawner_check

    dec a
    ld (spawn_timer), a
ret