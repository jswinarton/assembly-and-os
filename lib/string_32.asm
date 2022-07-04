[bits 32]

VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

; prints a null-terminated string pointed to by EBX
print_string_32:
    pusha
    ; Set EDX to the start of video memory
    mov edx, VIDEO_MEMORY

    print_string_32_loop:
        mov al, [ebx]  ; Store the character at EBX (the one we want to print) in AL
        mov ah, WHITE_ON_BLACK  ; Store the attributes in AH

        ; If at the null character, we are done
        cmp al, 0
        je print_string_32_done

        ; Write the character and its attributes at the address stored in EDX
        ; (i.e. the cell that we want to write to in video memory)
        mov [edx], ax
        ; Increment to the next character in the string
        add ebx, 1
        ; Move to the next character cell in video memory
        add edx, 2

        ; Loop to next char
        jmp print_string_32_loop

    print_string_32_done:
        popa
        ret

