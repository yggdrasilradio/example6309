
enable6309
; MODE/ERROR REGISTER
; 0    Zero division error flag
; 0    Illegal instruction error flag
; 0000 Unused
; 1    FIRQ mode: same as IRQ
; 1    Execution mode: 6309 native mode
 ldmd #$03
 rts

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
