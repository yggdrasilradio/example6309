
* init graphics

gfxinit
 pshs d

; INITIALIZATION REGISTER 0 $FF90
; 0    Coco 1/2 compatible: NO
; 0    MMU enabled: NO
; 0    GIME IRQ enabled: NO
; 0    GIME FIRQ enabled: NO
; 1    RAM at FExx is constant: YES
; 0    Standard SCS (spare chip select): OFF
; 00   ROM map control: 16k internal, 16K external
 ldb #$08
 stb $FF90

; INITIALIZATION REGISTER 1 $FF91
; 0    Unused
; 1    Memory type 1=256K, 0=64K chips
; 1    TINS Timer clock source 1=279.365 nsec, 0=63.695 usec
; 0000 Unused
; 0    MMU task select 0=enable FFA0-FFA7, 1=enable FFA8-FFAF
 ldb #$60

; VIDEO MODE REGISTER $FF98
; 1  Graphic mode: YES
; 0  Unused
; 0  Composite color phase invert: NO
; 0  Monochrome on composite video out: NO
; 0  50Hz video: NO
; 00 Lines per row: one line per row		 ???
 ldb #$80
 stb $FF98

; VIDEO RESOLUTION REGISTER $FF99
; 0   Unused
; 11  LPF: 225
; 111 HRES: 160 bytes per row
; 10  CRES: 16 colors, 2 pixels per byte
 ldb #$7E
 stb $FF99

; VERTICAL OFFSET REGISTERS $FF9D - $FF9E
 ldd #$EE00
 sta $FF9D	MSB = ($70000 + addr) / 2048
 stb $FF9E	LSB = (addr / 8) AND $ff

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
 lda #38 	; 13 ORANGE
 sta $FFBE
 lda #63 	; 14 WHITE
 sta $FFBF

; BORDER COLOR REGISTER $FF9A
 lda #0		; BLACK
 sta $ff9A

 puls d,pc

; Clear screen
gfxcls
 clr ,-s
 ldx #SCREEN
 ldw #36000
 tfm s,x+
 leas 1,s
 rts

; Set pixel
; 320 x 225, 16 colors
; X is x 0-320
; Y is y 0-224
; B is color 0-15
gfxpset
 pshs x,y,u,d
 pshs b
 ldu #SCREEN
 tfr y,d
 lda #160
 mul
 leau d,u ; u now points to beginning of row
 tfr x,d
 lsra
 rorb
 leau d,u ; u now points to screen byte
 tfr x,d
 andb #1
 leax bytetbl1,pcr
 leay bytetbl2,pcr
 lda ,u
 anda b,x
 sta ,u
 lda ,s
 anda b,y
 ora ,u
 sta ,u
 leas 1,s
 puls x,y,u,d,pc

bytetbl1
 fcb $0F
 fcb $F0
bytetbl2
 fcb $F0
 fcb $0F
