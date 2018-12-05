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
 lda DOT.XPOS,u
 cmpa #1
 bhi no1@
 ldb #1
 stb DOT.XDELTA,u
no1@
 cmpa #125
 blo no2@
 ldb #$FF
 stb DOT.XDELTA,u
no2@
 * BOUNCE Y
 lda DOT.YPOS,u
 cmpa #1
 bhi no3@
 ldb #1
 stb DOT.YDELTA,u
no3@
 cmpa #93
 blo no4@
 ldb #$FF
 stb DOT.YDELTA,u
no4@
 lda DOT.XPOS,u	; update X
 adda DOT.XDELTA,u
 sta DOT.XPOS,u
 lda DOT.YPOS,u	; update Y
 adda DOT.YDELTA,u
 sta DOT.YPOS,u
 clra		; draw dot
 ldb DOT.XPOS,u
 tfr d,x
 ldb DOT.YPOS,u
 tfr d,y
 ldb DOT.COLOR,u
 lbsr DrawDot
 leau sizeof{DOT},u
 tst ,u
 bne loop@
 * END SCREEN DRAWING

 * Try drawing a sprite
 ldx #31
 ldy #31
 leau spider1,pcr
 lbsr DrawSprite

 * Draw scheduled sprites
 lbsr DrawSprites

 rts
