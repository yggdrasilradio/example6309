 setdp 0

 org $0

even  rmb 1
joyf  rmb 1
vsync rmb 1
seed  rmb 2
tick  rmb 1
xpos  rmb 1
yline rmb 1
xline rmb 1
addr1 rmb 2
addr2 rmb 2
joyx  rmb 1
joyy  rmb 1
lastb rmb 1
joyb  rmb 1
flag  rmb 1
sptr  rmb 2
 IFDEF M6809
sreg rmb 2
wreg rmb 0
ereg rmb 1
freg rmb 1
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

 org $2000

start

 * Enable 6309 native mode
 IFDEF M6309
 lbsr enable6309
 ENDC

 * Disable IRQ and FIRQ
 lbsr DisableIRQ

 * Relocate stack
 lds #STACK

 * Set direct page
 clra
 clrb
 tfr a,dp

 * Clear sound sample pointer
 std sptr

 * Clear joystick fire button flag
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

 * Clear screens
 lbsr Task0
 lbsr gfxcls
 lbsr Task1
 lbsr gfxcls

 * Initialize IRQ routine
 lbsr InitIRQ

 * Enable IRQ interrupts
 lbsr EnableIRQ

 * Start green lines at center of screen
 clr xpos
 lda #128/2
 sta xline
 lda #96/2
 sta yline

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
 lda #93
 mul
 inca
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

mainloop

 lbsr FlipScreens

* Turn on border (DEBUG)
; lda #100
; sta $ff9a

 tst joyb	; joystick button pressed?
 beq no@
 leau laser,pcr ; start laser sound
 stu sptr
 clr joyb
no@

 ldd sptr  ; is sound being played?
 beq no@
 lda #100  ; if so, set border to red
no@
 sta $ff9a ; otherwise set to black

 * BEGIN SCREEN DRAWING
 lbsr DrawFrame
 * END SCREEN DRAWING

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

SCREEN EQU $E000

 end start
