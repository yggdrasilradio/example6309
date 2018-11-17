JOYDEADZONE EQU 8 ; total deadzone is 8/64 (this number must be even)

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
 leas ,s++	; 7 / 6 cycle NOP to let comparator settle
 leas ,s++	; 7 / 6 cycle NOP to let comparator settle
 tst $FF00	; check comparator result
 bpl XNotHigh@
 lda #1		; RIGHT
 sta joyx
 bra EndJoyX@
XNotHigh@
 lda #($7E-JOYDEADZONE*2)
 sta $FF20
 leas ,s++	; 7 / 6 cycle NOP to let comparator settle
 leas ,s++	; 7 / 6 cycle NOP to let comparator settle
 tst $FF00	; check comparator result
 bpl XLow@
 lda #0		; NEUTRAL
 sta joyx
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
 leas ,s++	; 7 / 6 cycle NOP to let comparator settle
 leas ,s++	; 7 / 6 cycle NOP to let comparator settle
 tst $FF00	; check comparator result
 bpl YNotHigh@
 lda #1		; DOWN
 sta joyy
 bra EndJoyY@
YNotHigh@
 lda #($7E-JOYDEADZONE*2)
 sta $FF20
 leas ,s++	; 7 / 6 cycle NOP to let comparator settle
 leas ,s++	; 7 / 6 cycle NOP to let comparator settle
 tst $FF00	; check comparator result
 bpl YLow@
 clr joyy	; NEUTRAL
 bra EndJoyY@
YLow@
 lda #$FF	; UP
 sta joyy
EndJoyY@
 * read joystick button state
 lda #$FF
 sta $FF02 * set all keyboard column outputs to 1, to ignore keypresses
 lda $FF00
 sta joyb
 rts
