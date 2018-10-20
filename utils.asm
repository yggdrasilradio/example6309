enable6309
; MODE/ERROR REGISTER
; 0    Zero division error flag
; 0    Illegal instruction error flag
; 0000 Unused
; 1    FIRQ mode: same as IRQ
; 1    Execution mode: 6309 native mode
 IFDEF M6309
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
