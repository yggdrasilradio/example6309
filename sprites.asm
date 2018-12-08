
* X xposition
* Y yposition
* U sprite
DrawSprite
	pshs d,x,y,u
	IFDEF M6309
	pshsw
	ELSE

	ENDC
	tfr u,w
	clr even
	lbsr ScreenByte
	bcs no@
	inc even	; set even flag if even
no@
	lda #8		; loop counter for 8 rows
	pshs a
row@
* BEGIN ROW *
	lda ,w		; sprite data
	tst even	; is it even?
	lbne even@
* BEGIN ODD ROW
odd@
* BYTE 1
	IFDEF M6309
	lda ,w		; sprite data
	ELSE
	lda wreg
	ENDC
	ldb ,u		; screen byte
	anda #$F0	; anything in left nibble of sprite data?
	beq >
	andb #$F0	; clear out right screen nibble then
!	lsra		; shift right one nibble
	lsra
	lsra
	lsra
	IFDEF M6309
	orr a,b  	; put in the sprite data
	ELSE
	pshs a
	orb ,s+
	ENDC
	stb ,u		; write it out to the screen
* BYTE 2
	lda ,w		; sprite data
	ldb 1,u		; screen byte
	anda #$0F	; anything in right nibble of sprite data?
	beq >
	andb #$0F	; clear out left screen nibble then
!	lsla
	lsla
	lsla
	lsla
	orr a,b
	incw		; next sprite data
	lda ,w		; sprite data
	anda #$F0	; anything in left nibble of sprite data?
	beq >
	andb #$F0	; clear out right screen nibble then
!	lsra
	lsra
	lsra
	lsra
	orr a,b
	stb 1,u		; write it out to the screen
* BYTE 3
	lda ,w		; sprite data
	ldb 2,u		; screen byte
	anda #$0F	; anything in right nibble of sprite data?
	beq >
	andb #$0F	; clear out left screen nibble then
!	lsla
	lsla
	lsla
	lsla
	orr a,b
	incw		; next sprite data
	lda ,w		; sprite data
	anda #$F0	; anything in left nibble of sprite data?
	beq >
	andb #$F0	; clear out right screen nibble then
!	lsra
	lsra
	lsra
	lsra
	orr a,b
	stb 2,u		; write it out to the screen
* BYTE 4
	lda ,w		; sprite data
	ldb 3,u		; screen byte
	anda #$0F	; anything in right nibble of sprite data?
	beq >
	andb #$0F	; clear out left screen nibble then
!	lsla
	lsla
	lsla
	lsla
	orr a,b
	incw		; next sprite data
	lda ,w		; sprite data
	anda #$F0	; anything in left nibble of sprite data?
	beq >
	andb #$F0	; clear out right screen nibble then
!	lsra
	lsra
	lsra
	lsra
	orr a,b
	stb 3,u		; write it out to the screen
* BYTE 5
	lda ,w		; sprite data
	ldb 4,u		; screen byte
	anda #$0F	; anything in right nibble of sprite data?
	beq >
	andb #$0F	; clear out left screen nibble then
!	lsla
	lsla
	lsla
	lsla
	orr a,b
	stb 4,u
	incw
 lbra endrow@
* END ODD ROW
* BEGIN EVEN ROW
even@
* BYTE 1
	lda ,w		; sprite data
	ldb ,u		; screen byte
	bita #$F0	; anything in left nibble of sprite data?
	beq >
	andb #$0F	; clear out left screen nibble then
!	bita #$0F	; anything in right nibble of sprite data
	beq >
	andb #$F0	; clear out right screen nibble then
!	orr a,b		; put in the sprite data
	stb ,u		; write it out to the screen
	incw		; next byte of sprite data
* BYTE 2
	lda ,w		; sprite data
	ldb 1,u		; screen byte
	bita #$F0	; anything in left nibble of sprite data?
	beq >
	andb #$0F	; clear out left screen nibble then
!	bita #$0F	; anything in right nibble of sprite data
	beq >
	andb #$F0	; clear out right screen nibble then
!	orr a,b		; put in the sprite data
	stb 1,u		; write it out to the screen
	incw		; next byte of sprite data
* BYTE 3
	lda ,w		; sprite data
	ldb 2,u		; screen byte
	bita #$F0	; anything in left nibble of sprite data?
	beq >
	andb #$0F	; clear out left screen nibble then
!	bita #$0F	; anything in right nibble of sprite data
	beq >
	andb #$F0	; clear out right screen nibble then
!	orr a,b		; put in the sprite data
	stb 2,u		; write it out to the screen
	incw		; next byte of sprite data
* BYTE 4
	lda ,w		; sprite data
	ldb 3,u		; screen byte
	bita #$F0	; anything in left nibble of sprite data?
	beq >
	andb #$0F	; clear out left screen nibble then
!	bita #$0F	; anything in right nibble of sprite data
	beq >
	andb #$F0	; clear out right screen nibble then
!	orr a,b		; put in the sprite data
	stb 3,u		; write it out to the screen
	incw		; next byte of sprite data
* END EVEN ROW *
endrow@
	leau 64,u	; next row
* END ROW *
	dec ,s
	lbne row@
	leas 1,s
	pulsw
	puls d,x,y,u,pc

explosion
	fqb %00000000000000000000000000000000
	fqb %00000000000000000000000000000000
	fqb %00000000000011110000000000000000
	fqb %00000000111111111111000000000000
	fqb %00000000000011110000000000000000
	fqb %00000000000000000000000000000000
	fqb %00000000000000000000000000000000
	fqb %00000000000000000000000000000000

explosion2
	fqb %11110000000000000000000011110000
	fqb %00001111000000000000111100000000
	fqb %00000000111100111111000000000000
	fqb %00000000001100110011000000000000
	fqb %00000000111100111111000000000000
	fqb %00001111000000000000111100000000
	fqb %11110000000000000000000011110000
	fqb %00000000000000000000000000000000

explosion3
	fqb %00000000000000000000001100000000
	fqb %00000011000000001111000000000000
	fqb %00000000001100000011000000000000
	fqb %11110000001100110000000000000000
	fqb %00000000111100000011000000000000
	fqb %00000000000000000000000000000000
	fqb %00110000000000000000111100000000
	fqb %00000000000000000000000000000000

explosion4
	fqb %00000000000000000000000000000000
	fqb %00000000111100000000000000000000
	fqb %00000000000000000000001100000000
	fqb %00000000000011110000000000000000
	fqb %00000000001100000000000000000000
	fqb %00000000000000000000000000000000
	fqb %00000000000000000000000000000000
	fqb %00000000000000000000000000000000

	fdb $FFFF

spider1
	fqb %00000011000000000000000000110000
	fqb %00000000001100000000001100000000
	fqb %00000000000011111111000000000000
	fqb %00110011001111111111001100110011
	fqb %00000000001111111111001100000000
	fqb %00000011000011111111000000110000
	fqb %00110000000011111111000000000011
	fqb %00110000000000000000000000000011

spider2
	fqb %00000000001100000000001100000000
	fqb %00110000001100000000001100000011
	fqb %00000011000011111111000000110000
	fqb %00000000001111111111001100000000
	fqb %00000000000011111111000000000000
	fqb %00000011001111111111001100110000
	fqb %00110000000011111111000000000011
	fqb %00000000000000000000000000000000

fireball1
	fqb %00000011000000000000001100000000
	fqb %00000000000000110000000000110000
	fqb %00000011000000000011000000000000
	fqb %00000011001100110000001100000000
	fqb %00000000001100110011000000110000
	fqb %00000000001100110011001100000000
	fqb %00000000001100110011001100000000
	fqb %00000000000000110011000000000000

fireball2
	fqb %00000000000000110000000000000000
	fqb %00000011000000000011000000000000
	fqb %00000000001100000011000000000000
	fqb %00000011000000000000000000110000
	fqb %00000011001100000011001100000000
	fqb %00000000001100110011001100000000
	fqb %00000000001100110011001100000000
	fqb %00000000000000110011000000000000

InitSprites
 ldu #sprites
 lda #NSPRITES
 pshs a
 ldd #0
loop@
 std SPRITE.ADDR,u
 leau sizeof{SPRITE},u
 dec ,s
 bne loop@
 leas 1,s
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
 clra
 ldb SPRITE.XPOS,u
 tfr d,x
 ldb SPRITE.YPOS,u
 tfr d,y
 ldu SPRITE.ADDR,u
 lbsr DrawSprite
 IFDEF M6309
 tfr w,u
 ELSE
 ldu wreg
 ENDC
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

 * Running man animation
 fqb %00000000111111110000000000000000	;..WW.... IDLE
 fqb %00000011001100110011000000000000	;.RRRR...
 fqb %00000011001100110011000000000000	;.RRRR...
 fqb %00000000011001100000000000000000	;..BB....
 fqb %00000000011001100000000000000000	;..BB....
 fqb %00000000011001100000000000000000	;..BB....
 fqb %00000000000000000000000000000000	;........
 fqb %00000000000000000000000000000000	;........
	
 fqb %00000000111111110000000000000000	;..WW.... RUNNING RIGHT
 fqb %00000011001100110011000000000000	;.RRRR...
 fqb %00110000001100110011000000000000	;R.RRR...
 fqb %00000000011001100000000000000000	;..BB....
 fqb %00000000011000000110000000000000	;..B.B...
 fqb %00000000011000000110000000000000	;..B.B...
 fqb %00000000000000000000000000000000	;........
 fqb %00000000000000000000000000000000	;........
	
 fqb %00000000111111110000000000000000	;..WW....
 fqb %00000011001100110011000000000000	;.RRRR...
 fqb %00000011001100110000001100000000	;.RRR.R..
 fqb %00000000011001100000000000000000	;..BB....
 fqb %00000000011001100000000000000000	;..BB....
 fqb %00000000011001100000000000000000	;..BB....
 fqb %00000000000000000000000000000000	;........
 fqb %00000000000000000000000000000000	;........
	
 fqb %00000000111111110000000000000000	;..WW.... RUNNING LEFT
 fqb %00000011001100110011000000000000	;.RRRR...
 fqb %00000011001100110000001100000000	;.RRR.R..
 fqb %00000000011001100000000000000000	;..BB....
 fqb %00000110000001100000000000000000	;.B.B....
 fqb %00000110000001100000000000000000	;.B.B....
 fqb %00000000000000000000000000000000	;........
 fqb %00000000000000000000000000000000	;........
	
 fqb %00000000111111110000000000000000	;..WW....
 fqb %00000011001100110011000000000000	;.RRRR...
 fqb %00110000001100110011000000000000	;R.RRR...
 fqb %00000000011001100000000000000000	;..BB....
 fqb %00000000011001100000000000000000	;..BB....
 fqb %00000000011001100000000000000000	;..BB....
 fqb %00000000000000000000000000000000	;........
 fqb %00000000000000000000000000000000	;........
