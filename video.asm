
* Init CPU

cpuinit

; INITIALIZATION REGISTER 0 $FF90
; 0    Coco 1/2 compatible: NO
; 1    MMU enabled: YES
; 1    GIME IRQ enabled: NO
; 1    GIME FIRQ enabled: NO
; 1    RAM at FExx is constant: YES
; 0    Standard SCS (spare chip select): OFF
; 00   ROM map control: 16k internal, 16K external
 ldb #$78
 stb $FF90

; INITIALIZATION REGISTER 1 $FF91
; 0    Unused
; 1    Memory type 1=256K, 0=64K chips
; 1    TINS Timer clock source 1=279.365 ns, 0=63.695 us
; 0000 Unused
; 0    MMU task select: TASK0
 ldb #$60
 sta $ff91

; IRQ ENABLE/STATUS REGISTER $FF92
; 00 Undefined
; 0  Timer
; 0 HBORD Horizontal Border
; 1 VBORD Vertical Border
; 0 EI2 Serial Data
; 0 EI1 Keyboard
; 0 EI0 Cartridge
 ldb #$08
 stb $ff92

; FIRQ ENABLE/STATUS REGISTER $FF93
; 00 Undefined
; 1  Timer
; 0 HBORD Horizontal Border
; 0 VBORD Vertical Border
; 0 EI2 Serial Data
; 0 EI1 Keyboard
; 0 EI0 Cartridge
 ldb #$20
 stb $ff93

 rts

* Init Graphics

gfxinit

; VIDEO MODE REGISTER $FF98
; 1   Graphics bitplane mode: YES
; 0   Unused
; 0   Composite color phase invert: NO
; 0   Monochrome on composite video out: NO
; 0   50Hz video: NO
; 010 LPR: two lines per row
 ldb #$82
 stb $FF98

; VIDEO RESOLUTION REGISTER $FF99
; 0   Unused
; 00  LPF: 192 rows
; 100 HRES: 64 bytes per row
; 10  CRES: 16 colors, 2 pixels per byte
 ldb #$12
 stb $FF99

; DISTO MEMORY UPGRADE $FF9B
 clr $FF9B

; VERTICAL SCROLL REGISTER $FF9C
 clr $FF9C

; HORIZONTAL OFFSET REGISTER $FF9F
 clr $FF9F

; COLOR PALETTE REGISTERS $FFB0 - $FFBF
 lda #0		; 0 BLACK
 sta $FFB0
 lda #55	; 1 YELLOW
 sta $FFB1
 lda #23	; 2 BRIGHT GREEN
 sta $FFB2
 lda #32 	; 3 RED
 sta $FFB3
 lda #20 	; 4 DARK GREEN
 sta $FFB4
 lda #7 	; 5 DARK GRAY
 sta $FFB5
 lda #9 	; 6 BLUE
 sta $FFB6
 lda #56 	; 7 LIGHT GRAY
 sta $FFB7
 lda #23 	; 8 LIGHT GREEN
 sta $FFB8
 lda #62 	; 9 LIGHT YELLOW
 sta $FFB9
 lda #47 	; 10 MAGENTA
 sta $FFBA
 lda #53 	; 11 PUMPKIN
 sta $FFBB
 lda #31 	; 12 CYAN
 sta $FFBC
 lda #41 	; 13 PURPLE
 sta $FFBD
 lda #38 	; 14 ORANGE
 sta $FFBE
 lda #63 	; 15 WHITE
 sta $FFBF

; BORDER COLOR REGISTER $FF9A
 lda #$FF	; WHITE
 sta $ff9A

 rts

* X xpos
* Y ypos
* U pointer to screen byte
* bcc even
ScreenByte
 pshs d
 ldu #SCREEN
 tfr y,d
 lda #64
 mul
 IFDEF M6309
 addr d,u ; u now points to beginning of row
 tfr x,d
 lsrd
 ELSE
 leau d,u
 tfr x,d
 lsra
 rorb
 ENDC
 leau d,u ; u now points to screen byte
 puls d,pc

; Clear screen
gfxcls

 IFDEF M6309
 tfr s,v
 tfr 0,u
 tfr 0,x
 tfr 0,y
 ELSE
 sts sreg
 ldu #0
 ldx #0
 ldy #0
 ENDC

 * 21 x 32 x 9 bytes 
 IFDEF M6309
 tfr 0,d
 lde #19
 ELSE
 lda #19
 sta ereg
 ldd #0
 ENDC
 lds #SCREEN+6144
loop@
; 19 x 32 x 9 bytes = 5472 bytes
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 IFDEF M6309
 dece
 ELSE
 dec ereg
 ENDC
 bne loop@
 * 17 x 9 bytes = 153 bytes
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 pshs d,x,y,u,dp
 * 7 bytes
 pshs a,x,y,u
* WHITE FOR 8 ROWS = 512 bytes
 IFDEF M6309
 lde #4
 ELSE
 lda #4
 sta ereg
 ENDC
 ldd #$ffff
 ldx #$ffff
 ldy #$ffff
 ldu #$ffff
; 4 x 16 x 8 bytes = 512 bytes
loop2@
 pshs d,x,y,u
 pshs d,x,y,u
 pshs d,x,y,u
 pshs d,x,y,u
 pshs d,x,y,u
 pshs d,x,y,u
 pshs d,x,y,u
 pshs d,x,y,u
 pshs d,x,y,u
 pshs d,x,y,u
 pshs d,x,y,u
 pshs d,x,y,u
 pshs d,x,y,u
 pshs d,x,y,u
 pshs d,x,y,u
 pshs d,x,y,u
 IFDEF M6309
 dece
 ELSE
 dec ereg
 ENDC
 bne loop2@
 IFDEF M6309
 tfr v,s
 ELSE
 lds sreg
 ENDC
 rts

FlipScreens
 lbsr WaitForVSync
 com tick
 bne task0@
 bsr Screen1
 bsr Task0
 rts
task0@
 bsr Screen0
 bsr Task1
 rts

Task0
 ldb #$60	; switch to task 0
 stb $FF91
 rts

Task1
 ldb #$61	; switch to task 1
 stb $FF91
 rts

Screen0
 ldd #$FC00
 sta $FF9D	; MSB = $7E000 / 2048
 stb $FF9E	; LSB = (addr / 8) AND $ff
 rts

Screen1
 ldd #$DC00
 sta $FF9D	; MSB = $6E000 / 2048
 stb $FF9E	; LSB = (addr / 8) AND $ff
 rts

 * Draw vertical line
 * A = top Y coordinate
 * B = bottom Y coordinate
 * X = X coordinate

* X = X coordinate
* Y = Y coordinate
* A length
* B color
VLine
 IFDEF M6309
 tfr d,w ; length in e, color in f
 ELSE
 std wreg
 ENDC
 lbsr ScreenByte
loop@
* BEGIN ONE PIXEL
 IFDEF M6309
 tfr f,a
 ELSE
 lda freg
 ENDC
 ldb ,u ; screen byte
 bcc even@
 IFDEF M6309
 andd #$0FF0
 ELSE
 anda #$0F
 andb #$F0
 ENDC
 bra cont@
even@
 IFDEF M6309
 andd #$F00F
 ELSE
 anda #$F0
 andb #$0F
 ENDC
cont@
 IFDEF M6309
 orr a,b  
 ELSE
 pshs a
 orb ,s+
 ENDC
 stb ,u ; replace screen byte
* END ONE PIXEL
 leau 64,u
 IFDEF M6309
 dece
 ELSE
 dec ereg
 ENDC
 bgt loop@
 rts

* X xpos
* Y ypos
* A length
* B color
HLine
 IFDEF M6309
 tfr d,w ; length in e, color in f
 ELSE
 std wreg
 ENDC
 lbsr ScreenByte
 bcc even1@
; line begins on 2nd nibble
 IFDEF M6309
 tfr f,a
 ELSE
 lda freg
 ENDC
 ldb ,u ; get screen byte
 IFDEF M6309
 andd #$0FF0
 orr a,b  
 ELSE
 anda #$0F
 andb #$F0
 pshs a
 orb ,s+
 ENDC
 stb ,u+ ; replace screen byte, point to next byte
 bra cont1@
even1@
; line begins on 1st nibble
cont1@
 stu addr1
 IFDEF M6309
 tfr e,b
 ELSE
 ldb ereg
 ENDC
 decb
 abx
 lbsr ScreenByte
 bcs odd2@
 ; line ends on 1st nibble
 IFDEF M6309
 tfr f,a
 ELSE
 lda freg
 ENDC
 ldb ,u
 IFDEF M6309
 andd #$F00F
 orr a,b
 ELSE
 anda #$F0
 andb #$0F
 pshs a
 orb ,s+
 ENDC
 stb ,u
 leau -1,u
 bra cont2@
odd2@
; line ends on 2nd nibble
cont2@
 stu addr2
; write full bytes
 IFDEF M6309
 tfr f,b
 ELSE
 ldb freg
 ENDC
 ldu addr1
loop@
 stb ,u+
 cmpu addr2
 bls loop@
 rts

; Draw dot
; A is y 0-95
; B is x 0-127
; color is color
DrawDot
 lbsr SetPixel
 incb
 lbsr SetPixel
 inca
 lbsr SetPixel
 decb
 lbsr SetPixel
 rts

colors
 fcb $00
 fcb $11
 fcb $22
 fcb $33
 fcb $44
 fcb $55
 fcb $66
 fcb $77
 fcb $88
 fcb $99
 fcb $AA
 fcb $BB
 fcb $CC
 fcb $DD
 fcb $EE
 fcb $FF
