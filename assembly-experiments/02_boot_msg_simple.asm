;
; A simple boot sector that prints a message to the screen using a BIOS routine.
;

mov ah, 0x0e  ; int 10 when ah = 0x0e produces scrolling teletype BIOS routine

mov al, 'H'
int 0x10
mov al, 'e'
int 0x10
mov al, 'l'
int 0x10
mov al, 'l'
int 0x10
mov al, 'o'
int 0x10

jmp $  ; jump to the current address (i.e. forever)

;
; Padding and magic BIOS number.
;

times 510-($-$$) db 0  ; pad the boot sector out with zeros

dw 0xaa55  ; last two bytes form the magic number, so BIOS knows we are a boot sector.
