
* X xposition
* Y yposition
* U sprite
DrawSprite
	pshs d,x,y,u
	pshs u		; save sprite data pointer
	clr even
	lbsr ScreenByte
	puls x		; put sprite data pointer in x
	bcs no@
	inc even	; set even flag if even
no@
	lda #8		; loop counter for 8 rows
	pshs a
row@
* BEGIN ROW *
	tst even	; is it even?
	lbne even@
* BEGIN ODD ROW
odd@
* BYTE 1
	lda ,x		; sprite data
	ldb ,u		; screen byte
	anda #$F0	; anything in left nibble of sprite data?
	beq >
	andb #$F0	; clear out right screen nibble then
!	lsra		; shift right one nibble
	lsra
	lsra
	lsra
	pshs a
	orb ,s+
	stb ,u		; write it out to the screen
* BYTE 2
	lda ,x+		; sprite data
	ldb 1,u		; screen byte
	anda #$0F	; anything in right nibble of sprite data?
	beq >
	andb #$0F	; clear out left screen nibble then
!	lsla
	lsla
	lsla
	lsla
	pshs a
	orb ,s+
	lda ,x		; next sprite data
	anda #$F0	; anything in left nibble of sprite data?
	beq >
	andb #$F0	; clear out right screen nibble then
!	lsra
	lsra
	lsra
	lsra
	pshs a
	orb ,s+
	stb 1,u		; write it out to the screen
* BYTE 3
	lda ,x+		; sprite data
	ldb 2,u		; screen byte
	anda #$0F	; anything in right nibble of sprite data?
	beq >
	andb #$0F	; clear out left screen nibble then
!	lsla
	lsla
	lsla
	lsla
	pshs a
	orb ,s+
	lda ,x		; next sprite data
	anda #$F0	; anything in left nibble of sprite data?
	beq >
	andb #$F0	; clear out right screen nibble then
!	lsra
	lsra
	lsra
	lsra
	pshs a
	orb ,s+
	stb 2,u		; write it out to the screen
* BYTE 4
	lda ,x+		; sprite data
	ldb 3,u		; screen byte
	anda #$0F	; anything in right nibble of sprite data?
	beq >
	andb #$0F	; clear out left screen nibble then
!	lsla
	lsla
	lsla
	lsla
	pshs a
	orb ,s+
	lda ,x		; next sprite data
	anda #$F0	; anything in left nibble of sprite data?
	beq >
	andb #$F0	; clear out right screen nibble then
!	lsra
	lsra
	lsra
	lsra
	pshs a
	orb ,s+
	stb 3,u		; write it out to the screen
* BYTE 5
	lda ,x+		; sprite data
	ldb 4,u		; screen byte
	anda #$0F	; anything in right nibble of sprite data?
	beq >
	andb #$0F	; clear out left screen nibble then
!	lsla
	lsla
	lsla
	lsla
	pshs a
	orb ,s+
	stb 4,u
 lbra endrow@
* END ODD ROW
* BEGIN EVEN ROW
even@
* BYTE 1
	lda ,x+		; next sprite data
	ldb ,u		; screen byte
	bita #$F0	; anything in left nibble of sprite data?
	beq >
	andb #$0F	; clear out left screen nibble then
!	bita #$0F	; anything in right nibble of sprite data
	beq >
	andb #$F0	; clear out right screen nibble then
!	pshs a
	orb ,s+
	stb ,u		; write it out to the screen
* BYTE 2
	lda ,x+		; next sprite data
	ldb 1,u		; screen byte
	bita #$F0	; anything in left nibble of sprite data?
	beq >
	andb #$0F	; clear out left screen nibble then
!	bita #$0F	; anything in right nibble of sprite data
	beq >
	andb #$F0	; clear out right screen nibble then
!	pshs a
	orb ,s+
	stb 1,u		; write it out to the screen
* BYTE 3
	lda ,x+		; next sprite data
	ldb 2,u		; screen byte
	bita #$F0	; anything in left nibble of sprite data?
	beq >
	andb #$0F	; clear out left screen nibble then
!	bita #$0F	; anything in right nibble of sprite data
	beq >
	andb #$F0	; clear out right screen nibble then
!	pshs a
	orb ,s+
	stb 2,u		; write it out to the screen
* BYTE 4
	lda ,x+		; next sprite data
	ldb 3,u		; screen byte
	bita #$F0	; anything in left nibble of sprite data?
	beq >
	andb #$0F	; clear out left screen nibble then
!	bita #$0F	; anything in right nibble of sprite data
	beq >
	andb #$F0	; clear out right screen nibble then
!	pshs a
	orb ,s+
	stb 3,u		; write it out to the screen
* END EVEN ROW *
endrow@
	leau 64,u	; next row
* END ROW *
	dec ,s
	lbne row@
	leas 1,s
	puls d,x,y,u,pc

* Targeting reticule
reticule
	fqb %00100010001000000000000000000000 ; GGG.....
	fqb %00100000000000000000000000000000 ; G.......
	fqb %00100000000000000000000000000000 ; G.......
	fqb %00000000000000000000000000000000 ; ........
	fqb %00000000000000000000000000000000 ; ........
	fqb %00000000000000000000000000000010 ; .......G
	fqb %00000000000000000000000000000010 ; .......G
	fqb %00000000000000000000001000100010 ; .....GGG

explosion
	fqb %00000000000000000000000000000000 ; ........
	fqb %00000000000000000000000000000000 ; ........
	fqb %00000000000011110000000000000000 ; ...W....
	fqb %00000000111111111111000000000000 ; ..WWW...
	fqb %00000000000011110000000000000000 ; ...W....
	fqb %00000000000000000000000000000000 ; ........
	fqb %00000000000000000000000000000000 ; ........
	fqb %00000000000000000000000000000000 ; ........

	fqb %11110000000000000000000011110000 ; W.....W.
	fqb %00001111000000000000111100000000 ; .W...W..
	fqb %00000000111100111111000000000000 ; ..WRW...
	fqb %00000000001100110011000000000000 ; ..RRR...
	fqb %00000000111100111111000000000000 ; ..WRW...
	fqb %00001111000000000000111100000000 ; .W...W..
	fqb %11110000000000000000000011110000 ; W.....W.
	fqb %00000000000000000000000000000000 ; ........

	fqb %00000000000000000000001100000000 ; .....R..
	fqb %00000011000000001111000000000000 ; .R..W...
	fqb %00000000001100000011000000000000 ; ..R.R...
	fqb %11110000001100110000000000000000 ; W.RR....
	fqb %00000000111100000011000000000000 ; ..W.R...
	fqb %00000000000000000000000000000000 ; ........
	fqb %00110000000000000000111100000000 ; R....W..
	fqb %00000000000000000000000000000000 ; ........

	fqb %00000000000000000000000000000000 ; ........
	fqb %00000000111100000000000000000000 ; ..W.....
	fqb %00000000000000000000001100000000 ; .....R..
	fqb %00000000000011110000000000000000 ; ..R.....
	fqb %00000000001100000000000000000000 ; ........
	fqb %00000000000000000000000000000000 ; ........
	fqb %00000000000000000000000000000000 ; ........
	fqb %00000000000000000000000000000000 ; ........

	fdb $FFFF

spider1
	fqb %00000011000000000000000000110000 ; .R....R.
	fqb %00000000001100000000001100000000 ; ..R..R..
	fqb %00000000000011111111000000000000 ; ...WW...
	fqb %00110011001111111111001100110011 ; RRRWWRRR
	fqb %00000000001111111111001100000000 ; ..RWWR..
	fqb %00000011000011111111000000110000 ; .R.WW.R.
	fqb %00110000000011111111000000000011 ; R..WW..R
	fqb %00110000000000000000000000000011 ; R......R

spider2
	fqb %00000000001100000000001100000000 ; ..R..R..
	fqb %00110000001100000000001100000011 ; R.R..R.R
	fqb %00000011000011111111000000110000 ; .R.WW.R.
	fqb %00000000001111111111001100000000 ; ..RWWR..
	fqb %00000000000011111111000000000000 ; .RRWWRR.
	fqb %00000011001111111111001100110000 ; .R.WW.R.
	fqb %00110000000011111111000000000011 ; R..WW..R
	fqb %00000000000000000000000000000000 ; ........

fireball1
	fqb %00000011000000000000001100000000 ; .R...R..
	fqb %00000000000000110000000000110000 ; ...R..R.
	fqb %00000011000000000011000000000000 ; .R..R...
	fqb %00000011001100110000001100000000 ; .RRR.R..
	fqb %00000000001100110011000000110000 ; ..RRR.R.
	fqb %00000000001100110011001100000000 ; ..RRRR..
	fqb %00000000001100110011001100000000 ; ..RRRR..
	fqb %00000000000000110011000000000000 ; ...RR...

fireball2
	fqb %00000000000000110000000000000000 ; ...R....
	fqb %00000011000000000011000000000000 ; .R..R...
	fqb %00000000001100000011000000000000 ; ..R.R...
	fqb %00000011000000000000000000110000 ; .R....R.
	fqb %00000011001100000011001100000000 ; .RR.RR..
	fqb %00000000001100110011001100000000 ; ..RRRR..
	fqb %00000000001100110011001100000000 ; ..RRRR..
	fqb %00000000000000110011000000000000 ; ...RR...

InitSprites
 ldu #sprites
 lda #NSPRITES
 ldx #0
loop@
 stx SPRITE.ADDR,u
 leau sizeof{SPRITE},u
 deca
 bne loop@
 rts

* U sprite 
* Y xpos
* X ypos
AddSprite
 pshs u
 ldu #sprites
 lda #NSPRITES
 pshs a
loop@
 ldd SPRITE.ADDR,u
 bne endloop@
 ldd 1,s
 std SPRITE.ADDR,u
 tfr x,d
 stb SPRITE.XPOS,u
 tfr y,d
 stb SPRITE.YPOS,u
 bra exit@
endloop@
 leau sizeof{SPRITE},u
 dec ,s
 bne loop@
exit@
 leas 3,s
 rts

DrawSprites
 ldu #sprites
 lda #NSPRITES
 pshs a
loop@
 ldd SPRITE.ADDR,u
 beq endloop@
 IFDEF M6309
 tfr u,w
 ELSE
 stu wreg
 ENDC
 ;clra
 ;ldb SPRITE.XPOS,u
 ;tfr d,x
 ;ldb SPRITE.YPOS,u
 ;tfr d,y
 ;ldu SPRITE.ADDR,u
 ;lbsr DrawSprite
 lda SPRITE.YPOS,u
 ldb SPRITE.XPOS,u
 ldu SPRITE.ADDR,u
 lbsr sprite
 IFDEF M6309
 tfr w,u
 ELSE
 ldu wreg
 ENDC
 lda frame ; slow down animation (this could be parameterized)
 anda #1
 bne endloop@
 ldd SPRITE.ADDR,u ; advance to next sprite
 addd #32
 std SPRITE.ADDR,u
 ldd [SPRITE.ADDR,u] ; last sprite?
 cmpd #$FFFF
 bne endloop@
 ldd #0	; deallocate sprite
 std SPRITE.ADDR,u
endloop@
 leau sizeof{SPRITE},u
 dec ,s
 bne loop@
 leas 1,s
 rts

 * Running player animation
player0
 fqb %00000000111111110000000000000000	;..WW.... STANDING STILL
 fqb %00000011001100110011000000000000	;.RRRR...
 fqb %00000011001100110011000000000000	;.RRRR...
 fqb %00000000011001100000000000000000	;..BB....
 fqb %00000000011001100000000000000000	;..BB....
 fqb %00000000011001100000000000000000	;..BB....
 fqb %00000000000000000000000000000000	;........
 fqb %00000000000000000000000000000000	;........
	
playerr1
 fqb %00000000111111110000000000000000	;..WW.... RUNNING RIGHT
 fqb %00000011001100110011000000000000	;.RRRR...
 fqb %00110000001100110011000000000000	;R.RRR...
 fqb %00000000011001100000000000000000	;..BB....
 fqb %00000000011000000110000000000000	;..B.B...
 fqb %00000000011000000110000000000000	;..B.B...
 fqb %00000000000000000000000000000000	;........
 fqb %00000000000000000000000000000000	;........
	
playerr2
 fqb %00000000111111110000000000000000	;..WW....
 fqb %00000011001100110011000000000000	;.RRRR...
 fqb %00000011001100110000001100000000	;.RRR.R..
 fqb %00000000011001100000000000000000	;..BB....
 fqb %00000000011001100000000000000000	;..BB....
 fqb %00000000011001100000000000000000	;..BB....
 fqb %00000000000000000000000000000000	;........
 fqb %00000000000000000000000000000000	;........
	
playerl1
 fqb %00000000111111110000000000000000	;..WW.... RUNNING LEFT
 fqb %00000011001100110011000000000000	;.RRRR...
 fqb %00000011001100110000001100000000	;.RRR.R..
 fqb %00000000011001100000000000000000	;..BB....
 fqb %00000110000001100000000000000000	;.B.B....
 fqb %00000110000001100000000000000000	;.B.B....
 fqb %00000000000000000000000000000000	;........
 fqb %00000000000000000000000000000000	;........
	
playerl2
 fqb %00000000111111110000000000000000	;..WW....
 fqb %00000011001100110011000000000000	;.RRRR...
 fqb %00110000001100110011000000000000	;R.RRR...
 fqb %00000000011001100000000000000000	;..BB....
 fqb %00000000011001100000000000000000	;..BB....
 fqb %00000000011001100000000000000000	;..BB....
 fqb %00000000000000000000000000000000	;........
 fqb %00000000000000000000000000000000	;........

; Render a sprite at coordinates (B,A); exit with Z set if a collision occurred
; with pixels that were already set. collision will also be set if a collision occurred.
; The sprite is pointed to in U and has 2 bits per pixel. It is 8 pixels by 8 pixels
; which means 16 bytes of data.
;
; B x coordinate
; A y coordinate
; U sprite data
;
; STACK:
;	0 loop counter
;	1 X coordinate of sprite
;	2 Y coordinate of sprite
;	3 current X value

sprite	pshs b,a	; save render coordinates
	pshs b		; save X coordinate for later
	clr collision	; reset collision flag
	lda #8		; we're rendering 8 pixels high
	pshs a		; save counter
LD589	ldd ,u++	; get pixel data for rendering
	std sdata	; save pixel data
	ldd ,u++	; get pixel data for rendering
	std sdata+2	; save pixel data
LD58D	ldd sdata	; look at remaining pixel data
	addd sdata+2
	beq LD5AF	; brif no more pixels set
	clra		; clear out extra bits in A
	lsl sdata+3	; shift 4 bits of pixel data into A
	rol sdata+2
	rol sdata+1
	rol sdata
	rola
	lsl sdata+3
	rol sdata+2
	rol sdata+1
	rol sdata
	rola
	lsl sdata+3
	rol sdata+2
	rol sdata+1
	rol sdata
	rola
	lsl sdata+3
	rol sdata+2
	rol sdata+1
	rol sdata
	rola
	anda #$0F	; isolate just those 4 bits
	beq LD5AB	; brif pixel is not set
	leay colors,pcr	; point to all pixel color masks
	lda a,y		; get color mask for this color
	sta color	; save color mask for rendering
	ldd 2,s		; get render coordinates
	bsr pset	; render pixel on screen
LD5AB	inc 3,s		; bump X render coordinate
	bra LD58D	; move on to next pixel
LD5AF	dec ,s		; have we rendered all rows?
	beq LD5BB	; brif so
	inc 2,s		; bump render Y coordinate
	lda 1,s		; reset render X coordinate
	sta 3,s
	bra LD589	; go render another pixel row
LD5BB	leas 4,s	; deallocate local storage
	tst collision	; set Z if no collision
	rts

* A = y coord
* B = x coord
* color = color black, blue, red or white
* (%00000000, %01010101, %10101010, %11111111)
* collision = 0 (false), 1 (true)
pset	cmpa #95	; is the Y coordinate off bottom of screen?
	bhi LD52E	; brif so
	cmpb #127	; is the X coordinate off the right of the screen?
	bhi LD52E	; brif so
	;cmpa #8	; is the Y coordinate within the text row at the top?
	;bcs LD52E	; brif so
	pshs b		; save X coordinate
	lslb		; compensate for the right shifts below
	lsra		; * calcuate offset from start of screen; this needs to
	rorb		; * multiply the row number by 64 and add the column
	lsra		; * number divided by 2.
	rorb
	addd #SCREEN	; add in screen start address
	tfr d,x		; save byte address in a pointer register
	puls a		; get back X coordinate
	anda #1		; find offset in byte
	leay masks,pcr	; point to pixel masks
	ldb a,y		; get pixel mask
	tfr b,a		; put it also in A - we need it twice
	coma		; flip mask so we clear bits in the screen byte
	anda ,x		; clear pixel in data byte
	bitb ,x		; was the pixel set?
	bne LD524	; brif so - flag collision
	andb color	; get correct pixel data in the all color byte
	sta ,x		; save cleared pixel data
	orb ,x		; merge it with new pixel data
	stb ,x		; set screen data
	orcc #4		; set Z (no collision)
	rts

LD524	inc collision	; flag collision
	andb color	; get correct pixel data in all color byte
	sta ,x		; save cleared pixel data
	orb ,x		; merge it with new pixel data
	stb ,x		; set screen data
LD52E	andcc #$fb	; flag collision (Z clear)
	rts

masks	fcb $F0,$0F
