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

 * Bouncing colored dots
 ldu #table
loop@
 * BOUNCE X
 lda XPOS,u
 cmpa #1
 bhi no1@
 ldb #1
 stb XDELTA,u
no1@
 cmpa #125
 blo no2@
 ldb #$FF
 stb XDELTA,u
no2@
 * BOUNCE Y
 lda YPOS,u
 cmpa #1
 bhi no3@
 ldb #1
 stb YDELTA,u
no3@
 cmpa #93
 blo no4@
 ldb #$FF
 stb YDELTA,u
no4@
 lda XPOS,u	; update X
 adda XDELTA,u
 sta XPOS,u
 lda YPOS,u	; update Y
 adda YDELTA,u
 sta YPOS,u
 clra		; draw dot
 ldb XPOS,u
 tfr d,x
 ldb YPOS,u
 tfr d,y
 ldb COLOR,u
 lbsr DrawDot
 leau 5,u
 tst ,u
 bne loop@
 * END SCREEN DRAWING

 rts
