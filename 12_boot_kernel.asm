;
; A boot sector that boots a C kernel in 32-bit protected mode
;

[org 0x7c00]
KERNEL_OFFSET equ 0x1000  ; This is the memory offset to which we will load our kernel

; BIOS stores our boot drive in DL, so it's best to remember this for later
mov [BOOT_DRIVE], dl

; Set up the stack
mov bp, 0x9000
mov sp, bp

; Announce that we are starting booting from 16-bit real mode
mov bx, MSG_REAL_MODE
call print_string

call load_kernel

; We will not return from here
call switch_to_32

jmp $

%include "lib/string.asm"
%include "lib/disk.asm"
%include "lib/gdt.asm"
%include "lib/string_32.asm"
%include "lib/switch_to_32.asm"

[bits 16]

; kernel load routine
load_kernel:
    mov bx, MSG_LOAD_KERNEL
    call print_string

    ; Set up parameters for our disk load routine, so that we load the first 15
    ; sectors (excluding the boot sector) from the boot disk (i.e. our kernel
    ; code) to address KERNEL_OFFSET
    mov bx, KERNEL_OFFSET
    mov dh, 15
    mov dl, [BOOT_DRIVE]
    call disk_load

    ret

[bits 32]
; This is where we arrive to after switching to and initializing protected mode

BEGIN_32:
    ; Announce we are in protected mode
    mov ebx, MSG_PROT_MODE
    call print_string_32

    ; Jump to the kernel ...
    call KERNEL_OFFSET

    jmp $

BOOT_DRIVE      db 0
MSG_REAL_MODE   db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE   db "Successfully landed in 32-bit Protected Mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory", 0

times 510-($-$$) db 0
dw 0xaa55


