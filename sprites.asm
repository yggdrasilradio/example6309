
* X xposition
* Y yposition
* U sprite data
DrawSprite
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
	lda ,w		; sprite data
	ldb ,u		; screen byte
	anda #$F0	; anything in left nibble of sprite data?
	beq >
	andb #$F0	; clear out right screen nibble then
!	lsra		; shift right one nibble
	lsra
	lsra
	lsra
	orr a,b		; put in the sprite data
	stb ,u		; write it out to the screen
* BYTE 2
	lda ,w		; sprite data
	ldb ,u		; screen byte
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
	ldb ,u		; screen byte
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
	ldb ,u		; screen byte
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
	lda ,u		; screen byte
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
	rts

; 4 explosion sprites 8x8

sprite1
 fqb %00000011000000000000000000110000
 fqb %00000000001100000000001100000000
 fqb %00000000000011111111000000000000
 fqb %00110011001111111111001100110011
 fqb %00000000001111111111001100000000
 fqb %00000011000011111111000000110000
 fqb %00110000000011111111000000000011
 fqb %00110000000000000000000000000011

sprite2
 fqb %00000000001100000000001100000000
 fqb %00110000001100000000001100000011
 fqb %00000011000011111111000000110000
 fqb %00000000001111111111001100000000
 fqb %00000000000011111111000000000000
 fqb %00000011001111111111001100110000
 fqb %00110000000011111111000000000011
 fqb %00000000000000000000000000000000

sprite3
 fqb %00000011000000000000001100000000
 fqb %00000000000000110000000000110000
 fqb %00000011000000000011000000000000
 fqb %00000011001100110000001100000000
 fqb %00000000001100110011000000110000
 fqb %00000000001100110011001100000000
 fqb %00000000001100110011001100000000
 fqb %00000000000000110011000000000000

sprite4
 fqb %00000000000000110000000000000000
 fqb %00000011000000000011000000000000
 fqb %00000000001100000011000000000000
 fqb %00000011000000000000000000110000
 fqb %00000011001100000011001100000000
 fqb %00000000001100110011001100000000
 fqb %00000000001100110011001100000000
 fqb %00000000000000110011000000000000
