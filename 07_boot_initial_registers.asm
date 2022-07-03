; Simple script that prints the values in the registers at initialization
; More info: https://en.wikibooks.org/wiki/X86_Assembly/X86_Architecture

[org 0x7c00]

; Print the value in the data register (DX)
call print_hex
call print_newline

; Print the value in the counter register (CX)
mov dx, cx
call print_hex
call print_newline

; Print the value in the base register (BX)
mov dx, bx
call print_hex
call print_newline

; Print the value in the accumulator register (AX)
mov dx, ax
call print_hex
call print_newline

call print_newline

; Print the value in the stack pointer register (SP)
mov dx, sp
call print_hex
call print_newline

; Print the value in the stack base pointer register (BP)
mov dx, bp
call print_hex
call print_newline

; Print the value in the source index register (SI)
mov dx, si
call print_hex
call print_newline

; Print the value in the destination index register (DI)
mov dx, di
call print_hex
call print_newline

call print_newline

; Print the value in the stack segment register (SS)
mov dx, ss
call print_hex
call print_newline

; Print the value in the code segment register (CS)
mov dx, cs
call print_hex
call print_newline

; Print the value in the data segment register (DS)
mov dx, ds
call print_hex
call print_newline

; Print the value in the first extra segment register (ES)
mov dx, es
call print_hex
call print_newline

; Print the value in the second extra segment register (FS)
mov dx, fs
call print_hex
call print_newline

; Print the value in the third extra segment register (GS)
mov dx, gs
call print_hex
call print_newline

jmp $

%include "lib/string.asm"

times 510-($-$$) db 0
dw 0xaa55
