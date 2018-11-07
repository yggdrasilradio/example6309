 org $0

vsync rmb 1
seed  rmb 2
tick  rmb 1
xpos  rmb 1
color rmb 1
addr1 rmb 2
addr2 rmb 2
byte1 rmb 1
byte2 rmb 1

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

mainloop

 lbsr FlipScreens

* Turn on border (DEBUG)
 ;lda #100
 ;sta $ff9a

 * BEGIN SCREEN DRAWING
 lbsr gfxcls

 * Horizontal lines at top and bottom edges of screen
 ldx #0
 ldy #0
 ldb #$11
 lda #127/2
 lbsr HLine

 ldx #0
 ldy #96/2
 ldb #$11
 lda #127/2
 lbsr HLine

 ldx #127/2
 ldy #96/2+1
 ldb #$11
 lda #127/2
 lbsr HLine

 ldx #0
 ldy #95-1 ; Y ranges from 0 to 94?
 ldb #$11
 lda #127/2
 lbsr HLine

 * Vertical lines at left and right edges of screen
 ldx #0
 ldy #0
 ldb #$11
 lda #96/2
 lbsr VLine
 ldx #127
 ldy #0
 ldb #$11
 lda #96/2
 lbsr VLine

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
 ldy #4
 lda #15
 ldb #$11 ; color
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
 addb #$11
 deca
 bne loop@
 * END SCREEN DRAWING

* Turn off border (DEBUG)
 lda #0
 sta $ff9a

 lbra mainloop

IRQ
 orcc #%01010000  ; disable IRQ
 inc vsync	  ; set VSYNC flag
 tst $FF02	  ; dismiss interrupt
 andcc #%10101111 ; enable IRQ
 rti

 incl video.asm
 incl utils.asm

SCREEN EQU $6000

 end start
