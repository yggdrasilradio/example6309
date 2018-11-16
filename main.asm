 org $0

vsync rmb 1
seed  rmb 2
tick  rmb 1
xpos  rmb 1
yline rmb 1
xline rmb 1
addr1 rmb 2
addr2 rmb 2
dac   rmb 1
joyx  rmb 1
joyy  rmb 1
joyb  rmb 1
 IFDEF M6809
sreg rmb 2
wreg rmb 0
ereg rmb 1
freg rmb 1
 ENDC

 org $1000

STACK rmb 1

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

 * Clear VSYNC flag
 clr vsync

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

 clr xpos
 clr xline
 clr yline

mainloop

 lbsr FlipScreens

* Get joystick input
 lbsr JoyIn

* Turn on border (DEBUG)
 ;lda #100
 ;sta $ff9a

 * BEGIN SCREEN DRAWING
 lbsr gfxcls

* Turn on border (DEBUG)
 ;lda #55
 ;sta $ff9a

 * Horizontal lines at top and bottom edges of screen
 ldx #1
 ldy #0
 ldb #$11
 lda #126
 lbsr HLine
 ldx #1
 ldy #95
 ldb #$11
 lda #126
 lbsr HLine

 * Vertical lines at left and right edges of screen
 ldx #0
 ldy #1
 ldb #$11
 lda #94
 lbsr VLine
 ldx #127
 ldy #1
 ldb #$11
 lda #94
 lbsr VLine

 * Vertical line following joystick
 lda joyx
 cmpa #32
 bgt xinc@
 dec xline
 bra cont@
xinc@
 inc xline
cont@
no@
 ldx #0
 ldy #0
 ldb xline
 andb #$7F
 abx
 ldb #$22
 lda #96
 lbsr VLine

; ldx #0
; ldy #0
; lda ljoyy
; cmpa #32
; bls yinc@
; inc ypos
; bra cont@
;yinc@
; dec ypos
; blt cont@
; lda #95
; sta ypos
;cont@
; ldb ypos
; cmpb #96
; bne no@
; clrb
; clr ypos
;no@
; leay b,y
; ldb #$22
; lda #128
; lbsr HLine

* Turn on border (DEBUG)
 ;lda #5
 ;sta $ff9a

 * Moving colored dots to show palette colors
 clra
 ldb xpos
 tfr d,x
 cmpd #128-20
 blo no@
 ldx #0
 clr xpos
no@
 inc xpos
 leax 10,x
 ldy #5
 lda #15
 ldb #$11 ; first color
loop@
 lbsr gfxpset
 leax 1,x
 lbsr gfxpset
 leay 1,y
 lbsr gfxpset
 leax -1,x
 lbsr gfxpset
 leay -1,y
 leay 6,y
 addb #$11 ; next color
 deca
 bne loop@
 * END SCREEN DRAWING

* Turn off border (DEBUG)
 ;lda #0
 ;sta $ff9a

 lbra mainloop

IRQ
 clr vsync
 inc vsync	  ; set VSYNC flag
 lda $FF02	  ; dismiss interrupt
 rti

 incl video.asm
 incl utils.asm
 incl joystick.asm

SCREEN EQU $E000

 end start
