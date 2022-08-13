 opt c

 setdp 0

 org $0

collision rmb 1
color	rmb 1
frame	rmb 1
joyf	rmb 1
vsync	rmb 1
seed	rmb 2
tick	rmb 1
xcurs	rmb 1
ycurs	rmb 1
joyx	rmb 1
joyy	rmb 1
lastb	rmb 1
joyb	rmb 1
sptr	rmb 2
temp	rmb 1
* FIREBALL
xfire	rmb 1
yfire	rmb 1
xfired	rmb 1	; direction
* SPIDER
xspid	rmb 1
yspid	rmb 1
xspidd	rmb 1	; direction
 IFDEF M6809
sreg	rmb 2
wreg	rmb 0
ereg	rmb 1
freg	rmb 1
 ENDC

 org $1000

STACK rmb 1

NDOTS equ 15

DOT struct
XPOS rmb 1
YPOS rmb 1
XDELTA rmb 1
YDELTA rmb 1
COLOR rmb 1
 endstruct

table rmb sizeof{DOT}*(NDOTS+1)

NSPRITES equ 8

SPRITE struct
ADDR rmb 2
XPOS rmb 1
YPOS rmb 1
 endstruct

sprites rmb sizeof{SPRITE}*(NSPRITES+1)

 org $2000

start

 * Disable IRQ and FIRQ
 lbsr DisableIRQ

 * Enable 6309 native mode
 IFDEF M6309
 lbsr enable6309
 ENDC

 * Relocate stack
 lds #STACK

 * Set direct page
 clra
 clrb
 tfr a,dp

 * Clear sound sample pointer
 std sptr

 * Clear joystick fire button flag
 sta joyb
 sta joyf

 * Turn off ROMs
 lbsr romsoff

 * 1.78 Mhz CPU
 lbsr fast

 * Initialize MMU
 lbsr InitMMU

 * Seed random number routine
 IFDEF M6309
 tfr v,d	; get seed from nonvolatile storage
 ENDC
 addd $112	; throw in the BASIC timer
 bne no@	; can't be zero
 ldd #123
no@
 std seed

 * Init CPU
 lbsr cpuinit

 * Init graphics
 lbsr gfxinit

 * Init sprites
 lbsr InitSprites

 * Clear screens
 lbsr Task0
 lbsr gfxcls
 lbsr Task1
 lbsr gfxcls

 * Start cursor at center of screen
 lda #128/2
 sta xcurs
 lda #96/2
 sta ycurs

 * Init dot table
 lda #NDOTS 	; number of dots
 pshs a
 ldu #table
 leax colors,pcr
loop@
 lbsr rand	; random x
 lda #125
 mul
 inca
 sta DOT.XPOS,u
 lbsr rand	; random y
 lda #93-8
 mul
 inca
 adda #8
 sta DOT.YPOS,u
 lbsr rand	; random xdelta, going to be 1 or FF
 lda #1
 andb #1
 beq no@
 lda #$FF
no@
 sta DOT.XDELTA,u
 lbsr rand	; random ydelta, going to be 1 or FF
 lda #1
 andb #1
 beq no@
 lda #$FF
 sta DOT.YDELTA,u
 lda ,s		; color
 anda #$0f
 lda a,x
 sta DOT.COLOR,u
 leau sizeof{DOT},u ; next table entry
 dec ,s
 bne loop@
 clr ,u		; end of table
 puls a

 * Init fireball and spider
 lda #30 ; y
 ldb #30 ; x
 sta yspid
 stb xspid
 lda #60 ; y
 ldb #90 ; x
 sta yfire
 stb xfire
 lda #1
 stb xspidd
 lda #$ff
 stb xfired

 * Initialize IRQ routine
 lbsr InitIRQ

 * Enable IRQ interrupts
 lbsr EnableIRQ

mainloop

 lbsr FlipScreens

* Turn on border (DEBUG)
; lda #100
; sta $ff9a

 lbsr DrawFrame

 tst joyb	; joystick button pressed?
 beq no@
 * Start laser sound
 leau laser,pcr
 stu sptr
 clr joyb
 * Add explosion sprite
 leau explosion,pcr
 clra
 ldb xcurs
 addd #1
 tfr d,x
 ldb ycurs
 addd #1
 tfr d,y
 lbsr AddSprite
no@

* Turn off border (DEBUG)
; lda #0
; sta $ff9a

 lbra mainloop

FIRQ
 pshs a,u
 ldu sptr	; pointer to sound data
 beq no@	; sample to play?
 lda ,u+	; get next sample
 bne notdone@
 ldu #0		; last sample, clear pointer
notdone@
 ora #$02	; keep RS232 high
 sta $ff20	; save to DAC
 stu sptr	; save new pointer value
no@
 lda $FF93
 puls a,u	; dismiss interrupt
 rti

IRQ

 * Countdown timer for joystick fire button
 tst joyf
 beq no@
 dec joyf
no@

 * Poll joystick
 lbsr JoyIn

 * Hard boot to RSDOS if BREAK pressed
 ldb #KEYBREAK
 lbsr KeyIn
 bne no@
 lbsr reset
no@

 * Set VSYNC flag
 inc vsync

 * Dismiss interrupt
 lda $FF92
 rti

 incl video.asm
 incl utils.asm
 incl joystick.asm
 incl drawframe.asm
 incl laser.asm
 incl sprites.asm
 incl spritedata.asm

SCREEN EQU $E000

 end start
