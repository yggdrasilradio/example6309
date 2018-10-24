 org $0

seed rmb 2
tick rmb 1
xpos rmb 2
ypos rmb 2

 org $1000
STACK rmb 1

 org $2000 ; was $3000

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

mainloop

 lbsr FlipScreens

 * BEGIN SCREEN DRAWING
 lbsr gfxcls

 * Line from upper left to lower right
 ldx #46
 ldy #0
 ldb #$22
 lda #224
loop@
 lbsr gfxpset
 leax 1,x
 leay 1,y
 deca
 bne loop@

 * Line from lower left to upper right
 ldx #46
 ldy #224
 ldb #$22
 lda #224
loop@
 lbsr gfxpset
 leax 1,x
 leay -1,y
 deca
 bne loop@

 * Horizontal lines at top and bottom of edges screen
 ldx #0
 ldb #$11
 lda #160
loop@
 ldy #0
 lbsr gfxpset
 ldy #224
 lbsr gfxpset
 leax 1,x
 ldy #0
 lbsr gfxpset
 ldy #224
 lbsr gfxpset
 leax 1,x
 deca
 bne loop@

 * Vertical lines at left and right edges of screen
 ldx #0
 ldy #0
 ldb #$11
 lda #225
loop@
 ldx #0
 lbsr gfxpset
 ldx #319
 lbsr gfxpset
 leay 1,y
 deca
 bne loop@

 * Colored dots to show palette colors
 ldx #10
 ldy #12
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
 leay 14,y
 addb #$11
 deca
 bne loop@
 * END SCREEN DRAWING

 lbra mainloop

IRQ
 orcc #%01010000  ; disable IRQ
 tst $FF02	  ; dismiss interrupt
 ;andcc #%10101111 ; enable IRQ
 rti

 incl video.asm
 incl utils.asm

SCREEN EQU $6000

 end start

