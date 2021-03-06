
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
 lda SPRITE.YPOS,u
 ldb SPRITE.XPOS,u
 ldu SPRITE.ADDR,u
 lbsr DrawSprite
 IFDEF M6309
 tfr w,u
 ELSE
 ldu wreg
 ENDC
 lda frame
 anda #1 ; slow down animation (this could be parameterized)
 bne endloop@
 ldd SPRITE.ADDR,u ; advance to next sprite
 addd #64
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

; Render a sprite at coordinates (B,A)
; Exit with Z set if a collision occurred
;
; U sprite data
; B x coordinate
; A y coordinate
;
; STACK:
;	0 row counter
;	1 X coordinate of sprite
;	2 Y coordinate of sprite
;	3 current X value

DrawSprite pshs b,a	; save render coordinates
	pshs b		; save X coordinate for later
	clr collision	; reset collision flag
	leay masks,pcr
	lda #8		; we're rendering 8 pixels high
	pshs a		; save counter
sloop
	lda ,u+
	beq >		; brif pixel is not set
	sta color	; save color mask for rendering
	ldd 2,s		; get render coordinates
	bsr Pset	; render pixel on screen
!	inc 3,s		; bump X render coordinate

	lda ,u+
	beq >		; brif pixel is not set
	sta color	; save color mask for rendering
	ldd 2,s		; get render coordinates
	bsr Pset	; render pixel on screen
!	inc 3,s		; bump X render coordinate

	lda ,u+
	beq >		; brif pixel is not set
	sta color	; save color mask for rendering
	ldd 2,s		; get render coordinates
	bsr Pset	; render pixel on screen
!	inc 3,s		; bump X render coordinate

	lda ,u+
	beq >		; brif pixel is not set
	sta color	; save color mask for rendering
	ldd 2,s		; get render coordinates
	bsr Pset	; render pixel on screen
!	inc 3,s		; bump X render coordinate

	lda ,u+
	beq >		; brif pixel is not set
	sta color	; save color mask for rendering
	ldd 2,s		; get render coordinates
	bsr Pset	; render pixel on screen
!	inc 3,s		; bump X render coordinate

	lda ,u+
	beq >		; brif pixel is not set
	sta color	; save color mask for rendering
	ldd 2,s		; get render coordinates
	bsr Pset	; render pixel on screen
!	inc 3,s		; bump X render coordinate

	lda ,u+
	beq >		; brif pixel is not set
	sta color	; save color mask for rendering
	ldd 2,s		; get render coordinates
	bsr Pset	; render pixel on screen
!	inc 3,s		; bump X render coordinate

	lda ,u+
	beq >		; brif pixel is not set
	sta color	; save color mask for rendering
	ldd 2,s		; get render coordinates
	bsr Pset	; render pixel on screen
!	inc 3,s		; bump X render coordinate

	dec ,s		; have we rendered all rows?
	beq sexit	; brif so

	inc 2,s		; bump Y coordinate
	lda 1,s		; reset X coordinate
	sta 3,s
	bra sloop	; go render another pixel row

sexit	leas 4,s	; deallocate local storage
	tst collision	; set Z if no collision
	rts

SetPixel
	pshs d
	leay masks,pcr	; point to pixel masks
	bsr Pset
	puls d,pc

* A = y coord
* B = x coord
* color = color (%00000000, %01010101, %10101010, ... %11111111)
* collision = 0 (false), 1 (true)
Pset	cmpa #95	; is the Y coordinate off bottom of screen?
	bhi pclip	; brif so
	cmpb #127	; is the X coordinate off the right of the screen?
	bhi pclip	; brif so
	cmpa #8		; is the Y coordinate within the text row at the top?
	bcs pclip	; brif so
	stb temp	; save X coordinate
	lslb		; compensate for the right shifts below
	lsra		; * calcuate offset from start of screen; this needs to
	rorb		; * multiply the row number by 64 and add the column
	lsra		; * number divided by 2
	rorb
	adda #$E0	; add in screen start address
	tfr d,x		; save byte address in a pointer register
	lda temp	; get back X coordinate
	anda #1		; find offset in byte
	lsla		; *2
	ldd a,y		; get pixel masks
	anda ,x		; clear pixel in data byte
	bitb ,x		; was the pixel set?
	beq >		; brif not
	inc collision	; flag collision
!	andb color	; get correct pixel data in the all color byte
 IFDEF M6309
	orr a,b		; merge cleared pixel data with new pixel data
 ELSE
	sta temp	; save cleared pixel data
	orb temp	; merge it with new pixel data
 ENDC
	stb ,x		; set screen data
pclip	rts

masks	fdb $0FF0,$F00F
