;
; A boot sector that enters 32-bit protected mode.
;
[org 0x7c00]

; Set the stack
mov bp, 0x9000
mov sp, bp

mov bx, MSG_REAL_MODE
call print_string

call switch_to_32  ; note that we never return from here

jmp $

%include "lib/string.asm"
%include "lib/gdt.asm"
%include "lib/string_32.asm"
%include "lib/switch_to_32.asm"

[bits 32]

; This is where we arrive after switching to and initalizing 32-bit protected
; mode
BEGIN_32:
    mov ebx, MSG_PROT_MODE
    call print_string_32  ; Use the 32-bit print routine

    jmp $

MSG_REAL_MODE  db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE  db "Successfully landed in 32-bit Protected Mode", 0

times 510-($-$$) db 0
dw 0xaa55
