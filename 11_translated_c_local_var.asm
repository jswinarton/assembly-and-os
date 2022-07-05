;
; A boot sector that carries out the assembly instructions that are the
; equivalent of the function declaration in c/local_var.c.
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

    push ebp
    mov ebp, esp
    mov dword [ebp-0x4],0xbaba
    mov eax, [ebp-0x4]
    pop ebp


    jmp $

MSG_REAL_MODE  db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE  db "Successfully landed in 32-bit Protected Mode", 0

times 510-($-$$) db 0
dw 0xaa55
