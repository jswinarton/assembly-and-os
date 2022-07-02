; Print the "string" (null-terminated series of characters)
; that begins at the address in bx.
print_string:
    pusha  ; Push all register values onto the stack
    mov ah, 0x0e  ; Set our ax high byte (turns 0x10 BIOS interrupt into a screen print)

    print_string_print_byte:
        mov al, [bx] ; Move the value at bx into the register
        cmp al, 0  ; Check that the value is not NUL (\0)
        je print_string_reached_null_terminator  ; If NUL, jump to the end of the "function"
        int 0x10  ; If not NUL, print the character
        add bx, 0x01  ; Increment bx to the next character in the "string"
        jmp print_string_print_byte  ; Back to the beginning

    print_string_reached_null_terminator:
        ; We've reached the end of the string -- print a new line (\r\n) and exit
        mov al, 0x0d  ; 0x0d is a carriage return
        int 0x10
        mov al, 0x0a  ; 0x0a is a newline
        int 0x10
        popa  ; Restore register values to their state before the "function" started
        ret  ; Return to the location stored in the instruction pointer stack (?), i.e. the point where the "call" instruction was made

; Prints the value of dx as a hexadecimal.
print_hex:
    pusha

    ; Essentially we are converting a number to ASCII characters, four bits at a
    ; time. A single-digit hex number takes up four bits, which is why a byte is
    ; represented by a two-digit hex number. Thus 0xfa is 11111010 in binary,
    ; and 0xa is 1010.
    ; In order to print a word (2 bytes in 16-bit real mode) like 0xfa00, we
    ; need to iterate through the number four bits at a time by a series of bit
    ; shift and mask operations to get the value of each bit "group", then
    ; translate that to the final ASCII character value.

    ; ah: stores the counter that we will increment to determine how many
    ;     segments we have covered
    ; bx: stores the memory location of the byte in HEX_TEMPLATE we plan to
    ;     write over in this iteration
    ; cx: temporary store for necessary operations on the last four bits of the
    ;     value for comparison (bit masking)
    ; dx: stores the original value. On each iteration (production of a
    ;     character) this is modified by a bit shift operation.

    ; start the counter.
    mov ah, 0

    ; store the memory address of the *last* byte of the template.
    ; since this is a known length we can just add. We will be working
    ; backwards.
    mov bx, HEX_TEMPLATE
    add bx, 0x05

    print_hex_begin_iter:
        ; move the low byte of dx into cl. Since we are only working on the last
        ; four bits, rather than the whole byte, we need to "mask" the byte with
        ; an "and" operation to unset the first four bits of the byte. This will
        ; give us the correct value for the ASCII conversion.
        mov cl, dl
        and cl, 0x0f ; "mask" cl such that only last four bits are set ("the character")

        ; shift four bits off of dx. in the next iteration, we will be working on
        ; the next "character" (the four bits to the left).
        shr dx, 4

        ; convert to ASCII.
        ; characters 0-9 are stored in the ASCII table at 0x30-0x39. characters a-f
        ; are stored at 0x61-0x66. Compare the numerical value of the character to
        ; determine if we should print a letter or a number.
        cmp cl, 0x09
        jge print_hex_ascii_letters

    print_hex_ascii_numbers:  ; not referenced, just for readability
        mov al, cl
        ; add the low ASCII value to the register so we are in the right range
        add al, 0x30
        jmp print_hex_end_iter

    print_hex_ascii_letters:
        mov al, cl
        ; add the low ASCII value to the register so we are in the right range
        ; "a" is 0x61. Since the value we are receiving is 0xa (10), we need to
        ; offset by 0x0a to get to the right place in the table
        add al, 0x57 ; 0x61 - 0x0a

    print_hex_end_iter:
        ; write over the value in the hex template string (currently stored in
        ; bx) with our character. note that we are moving into memory (the byte
        ; represented by the address stored at bx), NOT a register.
        mov [bx], al

        ; decrement the address of the template so we are in the right place
        ; on the next iteration.
        sub bx, 1

        ; increment the counter
        add ah, 1

        ; if we're not done yet, start from the beginning
        cmp ah, 3
        jle print_hex_begin_iter

        ; all done. move HEX_TEMPLATE to bx and print the string.
        mov bx, HEX_TEMPLATE
        call print_string
        popa
        ret

HEX_TEMPLATE:
    db '0x0000', 0
