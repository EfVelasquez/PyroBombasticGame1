string1: .asciz "Get Out Of My Store!"
string2: .asciz "Press Space To Play"
screen_man_title_screen::
   cpctm_setBorder_asm HW_BLACK
    ;; Set up draw char colours before calling draw string
   ld    l, #2        ;; D = Background PEN (0)
   ld    h, #0         ;; E = Foreground PEN (3)

   call cpct_setDrawCharM0_asm   ;; Set draw char colours

   ;; Calculate a video-memory location for printing a string
   ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
   ld b, #40
   ld c, #00
   
   call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

   ;; Print the string in video memory
   ;; HL already points to video memory, as it is the return
   ;; value from cpct_getScreenPtr_asm
   ld   iy, #string1   ;; IY = Pointer to the string 
   call cpct_drawStringM0_asm  ;; Draw the string

   ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
   ld    b, #80                 ;; B = y coordinate (24 = 0x18)
   ld    c, #00                 ;; C = x coordinate (16 = 0x10)

   call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL
   ld iy, #string2
   call cpct_drawStringM0_asm

   string_loop:
      call cpct_scanKeyboard_f_asm
      ld hl, #Key_Space
      call cpct_isKeyPressed_asm
      jr z, string_loop
ret

.stringD1:  .asciz "Oh no! You died!"
.stringD2:  .asciz  "Press Space to Restart"
screen_man_death_screen::

    ;; Set up draw char colours before calling draw string
   ld    l, #2        ;; D = Background PEN (0)
   ld    h, #0         ;; E = Foreground PEN (3)

   call cpct_setDrawCharM0_asm   ;; Set draw char colours

   ;; Calculate a video-memory location for printing a string
   ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
   ld b, #40
   ld c, #00
   
   call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

   ;; Print the string in video memory
   ;; HL already points to video memory, as it is the return
   ;; value from cpct_getScreenPtr_asm
   ld   iy, #stringD1   ;; IY = Pointer to the string 
   call cpct_drawStringM0_asm  ;; Draw the string

   ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
   ld    b, #80                 ;; B = y coordinate (24 = 0x18)
   ld    c, #00                 ;; C = x coordinate (16 = 0x10)

   call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL
   ld iy, #stringD2
   call cpct_drawStringM0_asm

   string_loop:
      call cpct_scanKeyboard_f_asm
      ld hl, #Key_Space
      call cpct_isKeyPressed_asm
      jr z, string_loop
ret