 org $0

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

XPOS equ 0
YPOS equ 1
XDELTA equ 2
YDELTA equ 3
COLOR equ 4
table rmb 5*15

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
 tfr a,dp

 * Clear sound sample pointer
 clrb
 std sptr

 * Turn off ROMs
 lbsr romsoff

 * 1.78 Mhz CPU
 lbsr fast

 * Initialize MMU
 lbsr InitMMU

 * Seed random number routine
 ldd $112
 bne no@ ; can't be zero
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
 lda #15	; number of dots
 pshs a
 ldu #table
 leax colors,pcr
loop@
 lbsr rand	; random x
 lda #125
 mul
 inca
 sta XPOS,u
 lbsr rand	; random y
 lda #93
 mul
 inca
 sta YPOS,u
 lbsr rand	; random xdelta, going to be 1 or FF
 lda #1
 andb #1
 beq no@
 lda #$FF
no@
 sta XDELTA,u
 lbsr rand	; random ydelta, going to be 1 or FF
 lda #1
 andb #1
 beq no@
 lda #$FF
 sta YDELTA,u
 lda ,s		; color
 lda a,x
 sta COLOR,u
 leau 5,u	; next table entry
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
 tst sptr
 bne no@
 leau laser,pcr ; start laser sound
 stu sptr
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
 sta $ff20	; save to DAC
 stu sptr	; save new pointer value
no@
 lda $FF93
 puls a,u	; dismiss interrupt
 rti

IRQ
 lbsr JoyIn
 ldb #KEYBREAK	; is BREAK pressed?
 lbsr KeyIn
 bne no@
 lbsr reset	; hard boot back to RSDOS
no@
 inc vsync	; set VSYNC flag
 lda $FF92	; dismiss interrupt
 rti

 incl video.asm
 incl utils.asm
 incl joystick.asm
 incl drawframe.asm
 incl laser.asm

SCREEN EQU $E000

 end start
