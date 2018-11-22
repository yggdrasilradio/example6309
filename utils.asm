 IFDEF M6309
enable6309
; MODE/ERROR REGISTER
; 0    Zero division error flag
; 0    Illegal instruction error flag
; 0000 Unused
; 0    FIRQ mode: normal
; 1    Execution mode: 6309 native mode
 ldmd #$01
 rts

disable6309
; MODE/ERROR REGISTER
; 0    Zero division error flag
; 0    Illegal instruction error flag
; 0000 Unused
; 0    FIRQ mode: normal
; 0    Execution mode: 6809 mode
 ldmd #$00
 rts
 ENDC

* Set CPU to 1.79 Mhz
fast
 sta $FFD9
 rts

* Set CPU to 0.89 Mhz
slow
 sta $FFD8
 rts

* Map system ROMs into memory
romson
 sta $FFDE
 rts

* Take system ROMs out of memory map, set all-RAM mode
romsoff
 sta $FFDF
 rts

* Hard boot to RSDOS
reset
 orcc #$50       ; turn off interrupts
 IFDEF M6309
 lbsr disable6309
 ENDC
 ldd  #$8c00
 tfr b,dp        ; reset direct page
 std $ff90       ; turn off MMU and task 0
 stb $ffd8       ; slow CPU
 stb $ffd6
 stb $ffde       ; turn on ROMs
 stb >$0071
 jmp [$fffe]

rand
 clr    ,-s         ; clear holder of LFSB
 lda    seed        ; get high byte of 16-bit random seed
 anda   #%10110100  ; get the bits check in shifting
 ldb    #6          ; use the top 6 bits for xoring
loop@
 lsla               ; move top bit into the carry flag
 bcc    no@	    ; skip incing the LFSB if no carry
 inc    ,s          ; add one to the LFSB test holder
no@
 decb               ; count down loop counter
 bne    loop@       ; loop if all bits are not done
 lda    ,s+         ; get LFSB off of stack
 inca               ; invert lower bit by adding one
 rora               ; move bit 0 into carry
 rol    seed+1      ; shift carry into bit 0
 rol    seed        ; one more shift to complete the 16 bit shift
 ldd    seed        ; load up a and b with the new random seed
 rts

hang
 bra hang

InitMMU
 leau taskmap0,pcr
 ldx #$ffa0
 ldd ,u++
 std ,x++
 ldd ,u++
 std ,x++
 ldd ,u++
 std ,x++
 ldd ,u++
 std ,x++
 leau taskmap1,pcr
 ldx #$ffa8
 ldd ,u++
 std ,x++
 ldd ,u++
 std ,x++
 ldd ,u++
 std ,x++
 ldd ,u++
 std ,x++
 rts

;Task 0: $38 $39 $3A $3B $3C $3D $3E $3F

taskmap0
 fdb $3839
 fdb $3A3B
 fdb $3C3D
 fdb $3E3F

;Task 1: $38 $39 $3A $3B $3C $3D $3E $37

taskmap1
 fdb $3839
 fdb $3A3B
 fdb $3C3D
 fdb $3E37

* Disable IRQ and FIRQ
DisableIRQ
 orcc #%01010000
 rts

* Enable IRQ and FIRQ
EnableIRQ
 andcc #%10101111
 rts

InitIRQ

 * Set IRQ interrupt vector
 lda #$7e
 sta $fef7
 leau IRQ,pcr
 stu $fef8

 * Set FIRQ interrupt vector
 lda #$7e
 sta $fef4
 leau FIRQ,pcr
 stu $fef5

 * Disable HSYNC
 lda $ff01
 anda #$fe
 sta $ff01

 * Disable VSYNC
 lda $ff03
 anda #$fe
 sta $ff03

 * Enable TIMER
 ldd #459	; timer value (12 bit) 459 = 7798Hz
 std $ff94

 rts

SndOff
 lda $ff23 ; 6 bit sound disable
 anda #$f7
 sta $ff23
 rts

SndOn
 lda $ff01 ; set mux to 00
 anda #$f7
 sta $ff01
 lda $ff03
 anda #$f7
 sta $ff03
 lda $ff23 ; 6 bit sound enable
 ora #8
 sta $ff23
 rts

JoyIn
 lbsr SndOff
 ldb $ff20
 pshs b
 lbsr ReadJoystick
 puls b
 stb $ff20
 lbsr SndOn
 rts

KEYCLEAR equ $FD
KEYENTER equ $FE
KEYBREAK equ $FB

* Check for keypress
* B: $FD CLEAR
*    $FE ENTER
*    $FB BREAK
* bne no@
KeyIn
 ldb #$FB	; BREAK
 stb $ff02 	; save column strobe
 ldb $ff00 	; read keyboard data
 andb #$7f	; mask off comparator
 cmpb #$3f	; do we have a key press in row 6?
 rts

WaitForVSync
 clr vsync
loop@
 tst vsync
 beq loop@
 rts
