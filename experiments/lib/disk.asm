; NOTE including this file also requires lib/string.asm to be included.
; This is not included here to prevent double writing to disk.

; load DH sectors to ES:BX from drive DL
disk_load:
    ; Store DX on stack so later we can recall how many sectors were requested
    ; to be read, even if it is altered in the meantime
    push dx

    mov ah, 0x02  ; BIOS read sector function
    mov al, dh  ; Read the number of sectors stored in DH
    mov ch, 0x00  ; Select cylinder 0
    mov dh, 0x00  ; Select head 0
    mov cl, 0x02  ; Start reading from second sector (i.e. after the boot sector)
    int 0x13  ; BIOS interrupt

    jc disk_error  ; Jump if error (i.e. carry flag set)

    ; if sectors read (AL) does not match sectors expected (DH), jump to error)
    pop dx
    cmp dh, al
    jne disk_error
    ret

disk_error:
    mov bx, DISK_ERROR_MSG
    call print_string
    jmp $

DISK_ERROR_MSG:
    db "Disk read error!", 0

DISK_SUCCESS_MSG:
    db "Disk read success!", 0
