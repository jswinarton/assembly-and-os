;
; A simple boot sector program that demonstrates addressing by segment offset
;

mov ah, 0x0e  ; int 10 when ah = 0x0e produces scrolling teletype BIOS routine

; This does not print an X as the_secret has been declared relative to the
; bootloader, not to memory
mov al, [the_secret]
int 0x10

; get to the secret by segment addressing
; since what is stored in the segment register is multiplied by 16
; (0x7c0 x 16 = 0x7c00), this is the equivalent of calling [org 0x7c00].
mov bx, 0x7c0  ; can't set ds directly, so set bx and copy
mov ds, bx
mov al, [the_secret]
int 0x10  ; prints an X.

; two attempts to print by explicitly setting a different general purpose
; register
mov al, [es:the_secret]
int 0x10 ; this won't print because we haven't set es yet

mov bx, 0x7c0
mov es, bx
mov al, [es:the_secret]
int 0x10 ; this will work

jmp $

the_secret:
    db "X"

; Padding and magic BIOS number.
times 510-($-$$) db 0
dw 0xaa55
