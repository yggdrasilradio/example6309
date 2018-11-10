 IFDEF M6309
enable6309
; MODE/ERROR REGISTER
; 0    Zero division error flag
; 0    Illegal instruction error flag
; 0000 Unused
; 1    FIRQ mode: same as IRQ
; 1    Execution mode: 6309 native mode
 ldmd #$03
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
 ldd  #$8c00
 tfr b,dp        ; reset direct page
 std $ff90       ; turn off MMU and task 0
 stb $ffd8       ; slow CPU
 stb $ffd6
 stb $ffde       ; turn on ROMs
 stb $0071
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

* Enable IRQ
EnableIRQ
 andcc #%10101111
 rts

InitIRQ
 * Set IRQ interrupt vector
 lda #$7e
 sta $10c
 leau IRQ,pcr
 stu $10d

 * Disable HSYNC
 lda $ff01
 anda #$fe
 sta $ff01

 * Enable VSYNC
 lda $ff03
 ora #$01
 sta $ff03
 rts

KeyIn
 lbsr romson
 lbsr slow
 jsr [$a000]
 lbsr fast
 lbsr romsoff
 rts

SndInit
 pshs a
 lda $ff01
 anda #$f7
 sta $ff01
 lda $ff03
 anda #$f7
 sta $ff03
 lbsr SndOn
 puls a,pc

SndOff
 pshs a
 lda $ff23
 anda #$f7
 sta $ff23
 puls a,pc

SndOn
 pshs a
 lda $ff23
 ora #8
 sta $ff23
 puls a,pc

JoyIn
 lbsr SndOff
 ldb $ff20
 stb dac
 lbsr slow
 jsr [$a00a]
 lbsr fast
 ldb dac
 stb $ff20
 lbsr SndOn
 lbsr SndInit
 rts
