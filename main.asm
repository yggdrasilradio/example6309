 org $0

seed rmb 2
ssave rmb 2
ff90 rmb 1

 org $1000
STACK rmb 1

 org $3000

start

 * Enable 6309 native mode
 IFDEF M6309
 lbsr enable6309
 ENDC

 * Disable IRQ and FIRQ
 orcc #%01010000

 * Relocate stack
 lds #STACK

 * Set direct page
 clra
 tfr a,dp

 * Turn off ROMs
 lbsr romsoff

 * 1.78 Mhz CPU
 lbsr fast

 * Seed random number routine
 ldd $112
 bne no@ ; can't be zero
 ldd #123
no@
 std seed

 * Clear screen
 lbsr gfxcls

 * Init graphics
 lbsr gfxinit

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

 * Hang forever doing nothing
loop
 bra loop

SCREEN equ $7000

 incl video.asm
 incl utils.asm

 end start
