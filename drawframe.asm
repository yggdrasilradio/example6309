DrawFrame

 * BEGIN SCREEN DRAWING
 lbsr gfxcls

* Turn on border (DEBUG)
; lda #55
; sta $ff9a

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
 ldx #0
 ldy #0
 ldb xline
 addb joyx
 stb xline
 andb #$7F
 abx
 ldb #$22
 lda #96
 lbsr VLine

 * Horizontal line following joystick
 ldx #0
 ldy #0
 ldb yline
 addb joyy ; 0 to 95
 cmpb #96
 bne no1@ ; overflow?
 clrb
no1@
 cmpb #255 ; underflow?
 bne no2@
 ldb #95
no2@
 stb yline
 leay b,y
 ldb #$22
 lda #128
 lbsr HLine

* Turn on border (DEBUG)
; lda #5
; sta $ff9a

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

 rts
