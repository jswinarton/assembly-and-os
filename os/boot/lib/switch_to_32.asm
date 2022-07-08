[bits 16]

; Switch to protected mode
switch_to_32:
    ; We must switch off interrupts until we have set up the protected mode
    ; interrupt vector.
    cli

    ; Load the global descriptor table
    lgdt [gdt_descriptor]

    ; To make the switch to protected mode, we set the first bit of CR0, a
    ; control register
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    ; Make a far jump (i.e. to a new segment) to our 32-bit code. This also
    ; forces the CPU to flush its cache of pre-fetched and real-mode decoded
    ; instructions, which can cause problems.
    jmp CODE_SEG:init_32


[bits 32]

; Initialize registers and the stack once in PM.
init_32:

    ; Now in PM, our old segments are meaningless, so we point our segment
    ; registers to the data selector we defined in our GDT
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; Update our stack position so it is right at the top of the free space
    mov ebp, 0x90000
    mov esp, ebp

    ; Finally, call some well-known label
    ; NOTE: it is up to the calling code to determine the position of this label
    call BEGIN_32
