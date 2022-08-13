JOYDEADZONE EQU 8 ; total deadzone is 8/64 (this number must be even)

; ReadJoystick
; fire buttons in A
; coords in joyx, joyy

ReadJoystick
 * LEFT JOYSTICK X AXIS
 lda $FF03	; set axis 0
 anda #$F7
 sta $FF03
 lda $FF01
 anda #$F7
 sta $FF01
 lda #($7E+JOYDEADZONE*2)
 sta $FF20
 leas ,s++	; let comparator settle
 leas ,s++
 tst $FF00	; check comparator result
 bpl XNotHigh@
 lda #1		; RIGHT
 sta joyx
 bra EndJoyX@
XNotHigh@
 lda #($7E-JOYDEADZONE*2)
 sta $FF20
 leas ,s++	; let comparator settle
 leas ,s++
 tst $FF00	; check comparator result
 bpl XLow@
 clr joyx	; NEUTRAL
 bra EndJoyX@
XLow@
 lda #$FF	; LEFT
 sta joyx
EndJoyX@
 * LEFT JOYSTICK Y AXIS
 lda $FF01	; set axis 1
 ora #8
 sta $FF01
 lda #($7E+JOYDEADZONE*2)
 sta $FF20
 leas ,s++	; let comparator settle
 leas ,s++
 tst $FF00	; check comparator result
 bpl YNotHigh@
 lda #1		; DOWN
 sta joyy
 bra EndJoyY@
YNotHigh@
 lda #($7E-JOYDEADZONE*2)
 sta $FF20
 leas ,s++	; let comparator settle
 leas ,s++
 tst $FF00	; check comparator result
 bpl YLow@
 clr joyy	; NEUTRAL
 bra EndJoyY@
YLow@
 lda #$FF	; UP
 sta joyy
EndJoyY@
 * JOYSTICK BUTTON
 lda #$FF
 sta $FF02	; set all keyboard column outputs to 1, to ignore keypresses
 lda $FF00
 anda #$01
 bne nobutton@	; $FF if not pressed, $FE if right button, $FD if left
 tst joyf
 bne no@
 inc joyb	; raise button press
no@
 lda #2		; debounce button press
 sta joyf
nobutton@
 rts
