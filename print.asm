; Print the "string" (null-terminated series of characters)
; that begins at the address in bx.
print_string:
    pusha  ; Push all register values onto the stack
    mov ah, 0x0e  ; Set our ax high bit (turns 0x10 BIOS interrupt into a screen print)

    print_byte:
        mov al, [bx] ; Move the value at bx into the register
        cmp al, 0  ; Check that the value is not NUL (\0)
        je reached_null_terminator  ; If NUL, jump to the end of the "function"
        int 0x10  ; If not NUL, print the character
        add bx, 0x01  ; Increment bx to the next character in the "string"
        jmp print_byte  ; Back to the beginning

    reached_null_terminator:
        ; We've reached the end of the string -- print a new line (\r\n) and exit
        mov al, 0x0d  ; 0x0d is a carriage return
        int 0x10
        mov al, 0x0a  ; 0x0a is a newline
        int 0x10
        popa  ; Restore register values to their state before the "function" started
        ret  ; Return to the location stored in the instruction pointer stack (?), i.e. the point where the "call" instruction was made
