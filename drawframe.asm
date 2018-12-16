DrawFrame

 inc frame

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
; lbsr HLine
 ldx #1
 ldy #95
 ldb #$11
 lda #126
; lbsr HLine

 * Vertical lines at left and right edges of screen
 ldx #0
 ldy #1
 ldb #$11
 lda #94
; lbsr VLine
 ldx #127
 ldy #1
 ldb #$11
 lda #94
; lbsr VLine

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
 cmpa #9
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
 lda DOT.COLOR,u
 sta color
 lda DOT.YPOS,u
 ldb DOT.XPOS,u
 lbsr DrawDot
 leau sizeof{DOT},u
 tst ,u
 bne loop@

 * Draw animated spider
 leau spider1,pcr
 lda frame
 anda #4	; speed
 beq no@
 leau spider2,pcr
no@
 lda yspid ; y
 ldb xspid ; x
 lbsr DrawSprite

 * Move spider
 lda xspid
 adda xspidd
 sta xspid
 cmpa #127-8
 blo >
 ldb #$ff
 stb xspidd
!
 cmpa #2
 bhi >
 ldb #1
 stb xspidd
!
 
 * Draw animated fireball
 leau fireball1,pcr
 lda frame
 anda #4	; speed
 beq no@
 leau fireball2,pcr
no@
 lda yfire
 ldb xfire
 lbsr DrawSprite

 * Move fireball
 lda xfire
 adda xfired
 sta xfire
 cmpa #127-8
 blo >
 ldb #$ff
 stb xfired
!
 cmpa #2
 bhi >
 ldb #1
 stb xfired
!
 * Draw scheduled sprites
 lbsr DrawSprites

 * Update location of targeting reticule
 ldd xcurs ; update cursor location
 adda joyx
 addb joyy
 cmpa #1 ; x from 1 to 119
 bhs >
 lda #1
! cmpa #119
 bls >
 lda #119
! cmpb #9 ; y from 9 to 87
 bhs >
 ldb #9
! cmpb #87
 bls >
 ldb #87
! std xcurs

 * Draw player
 leau playerr1,pcr
 lda frame
 anda #4	; speed
 beq no@
 leau playerr2,pcr
no@
 ldb #10
 lda #10
 lbsr DrawSprite

 * Draw targeting reticule
 leau reticule,pcr
 ldb xcurs
 lda ycurs
 lbsr DrawSprite

 * END SCREEN DRAWING

 rts
