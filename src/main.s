;;-----------------------------LICENSE NOTICE------------------------------------
;;  This file is part of CPCtelera: An Amstrad CPC Game Engine 
;;  Copyright (C) 2018 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
;;
;;  This program is free software: you can redistribute it and/or modify
;;  it under the terms of the GNU Lesser General Public License as published by
;;  the Free Software Foundation, either version 3 of the License, or
;;  (at your option) any later version.
;;
;;  This program is distributed in the hope that it will be useful,
;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;  GNU Lesser General Public License for more details.
;;
;;  You should have received a copy of the GNU Lesser General Public License
;;  along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;-------------------------------------------------------------------------------

;; Include all CPCtelera constant definitions, macros and variables
.include "cpctelera.h.s"
.include "manager/entities.h.s"

;;
;; Start of _DATA area 
;;  SDCC requires at least _DATA and _CODE areas to be declared, but you may use
;;  any one of them for any purpose. Usually, compiler puts _DATA area contents
;;  right after _CODE area contents.
;;
.area _DATA

;;
;; Start of _CODE area
;; 
.area _CODE

;; 
;; Declare all function entry points as global symbols for the compiler.
;; (The linker will know what to do with them)
;; WARNING: Every global symbol declared will be linked, so DO NOT declare 
;; symbols for functions you do not use.
;;
.globl cpct_disableFirmware_asm
.globl cpct_getScreenPtr_asm
.globl sys_render_update
.globl sys_physics_update
.globl sys_render_wait
.globl cpct_waitVSYNC_asm
.globl sys_input_update



.globl man_entity_update


;;temp
;;.globl man_entity_set4destruction
;;.globl man_entity_first_entity
;;.globl man_next_entity
;;



cmps == e_cmps_position | e_cmps_alive | e_cmps_render | e_cmps_physics

;; Structure of templates:
;;                   cmps -  x -  y - vx-vy- w-h -color - e_type-         -prevpos     - width- height
mainchar_entity:: .db cmps, #20, #50, #1, #0, #0x08, #0x02, #0xFF , e_type_mainchar, #0x00, #0x00,  #5,  #07

cmps == e_cmps_position | e_cmps_alive | e_cmps_physics | e_cmps_render
enemy_entity:: .db cmps, #12, #10, 0, #1, #0x08, #0x02, #0xF0, e_type_enemy, #0x01, #0x01,  #8,  #10

_main::
   ;; Disable firmware to prevent it from interfering with string drawing
   call cpct_disableFirmware_asm

   
   
   ;; call man_entity_init
   ;; call sys_render_init

   ld hl, #mainchar_entity 
   call man_entity_create

   ld hl, #enemy_entity
   call man_entity_create

   ;call man_entity_first_entity
   ;call man_next_entity
   ;call man_entity_set4destruction


   ;; Loop forever
loop:
   cpctm_setBorder_asm HW_RED
      call sys_render_update

   cpctm_setBorder_asm HW_GREEN
      call sys_input_update

   cpctm_setBorder_asm HW_YELLOW
      call man_entity_update

   cpctm_setBorder_asm HW_BLUE
      call sys_physics_update
   
   cpctm_setBorder_asm HW_WHITE

   
   ;;call sys_render_wait
   call cpct_waitVSYNC_asm
   jr    loop