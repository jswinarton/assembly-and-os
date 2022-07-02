;
; A simple boot sector program that demonstrates the stack.
;

; int 0x10 while ah = 0x0e is BIOS teletype routine
mov ah, 0x0e

; set the base of the stack a little above where the BIOS loads the boot sector
; so we don't get overwritten
mov bp, 0x8000
mov sp, bp

; note that these end up being 16 bit values where the high bit is 0x00
push 'A'
push 'B'
push 'C'

; pop off the stack and print
pop bx
mov al, bl
int 0x10

pop bx
mov al, bl
int 0x10

; demonstrate that stack grows DOWN from bp
; fetch the char at -0x2 (16 bits) from start of stack
mov al, [0x7ffe]
int 0x10

jmp $

times 510-($-$$) db 0
dw 0xaa55
