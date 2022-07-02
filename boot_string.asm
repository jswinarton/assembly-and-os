[org 0x7c00]

mov bx, HELLO_MSG
call print_string

mov bx, GOODBYE_MSG
call print_string

mov dx, 0x1fb6
call print_hex

mov dx, 0xabcd
call print_hex

mov dx, 0x00ff
call print_hex

mov dx, 0x7c00
call print_hex

jmp $

%include "print.asm"

HELLO_MSG:
    db 'Hello, world!', 0

GOODBYE_MSG:
    db 'Goodbye!', 0

times 510-($-$$) db 0
dw 0xaa55
