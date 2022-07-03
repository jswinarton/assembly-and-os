; Can't get this one working for some reason. But 09 works so that's good.

mov ah, 0x02  ; BIOS read sector function

mov dl, 0  ; Read drive 0 (i.e. first floppy (?) drive)
mov ch, 3  ; Select cylinder 3 (1-indexed!)
mov dh, 1  ; Select track (head) on second side of floppy disk (0-indexed)
mov cl, 4  ; Select fourth sector on head (1-indexed!)
mov al, 5  ; Read 5 sectors from the start point

; Set the memory address that we'd like BIOS to read the sectors to, which BIOS
; expects to find in ES:BX (i.e. segment ES with offset BX) This becomes
; 0xa000:0x1234, which resolves to 0xa1234 (0xa000 * 16 = 0xa0000 + 0x1234)
mov bx, 0xa000
mov es, bx
mov bx, 0x1234

; Do the actual read
int 0x13

; "jc" is a jump instruction that jumps only if the carry flag was set
jc disk_error

; After read, AL is set to number of sectors actually read.
; This jumps if what BIOS reported as the number of sectors actually read in AL
; is not equal to the number we expected
; cmp al, 5
; jne disk_error

jmp disk_ok

disk_error:
    mov bx, DISK_ERROR_MSG
    call print_string
    jmp $

disk_ok:
    mov bx, DISK_ERROR_MSG
    call print_string
    jmp $

%include "lib/string.asm"

DISK_ERROR_MSG:
    db "Disk read error!", 0

DISK_OK_MSG:
    db "Disk read OK", 0

times 510-($-$$) db 0
dw 0xaa55
