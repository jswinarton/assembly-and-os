;
; Read some sectors from the boot disk using our disk_read function
;

[org 0x7c00]

; BIOS starts by storing the boot drive in DL, so save this for later
mov [BOOT_DRIVE], dl

; Set the stack safely out of the way
mov bp, 0x8000
mov sp, bp

; Load 2 sectors to 0x0000(ES):0x9000(BX) from the boot disk
mov bx, 0x9000
mov dh, 2
mov dl, [BOOT_DRIVE]
call disk_load

; Print out the first loaded word, which we expect to be 0xdada, stored at
; address 0x9000
mov dx, [0x9000]
call print_hex

call print_newline

; Print the first word from the second loaded sector, which should be 0xface
mov dx, [0x9000 + 512]
call print_hex

jmp $

%include "lib/string.asm"
%include "lib/disk.asm"

BOOT_DRIVE: db 0

times 510-($-$$) db 0
dw 0xaa55

; We know that BIOS will load only the first 512-byte sector from the disk, so
; we purposely add a few more sectors to our code by repeating some numbers.
; Therefore we can prove to ourselves that we actually loaded these two
; additional sectors from the disk we booted from
times 256 dw 0xdada
times 256 dw 0xface
