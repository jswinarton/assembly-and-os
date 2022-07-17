; Ensure that we step into the kernel's main entry function
[bits 32]

; Declare that we will be referencing the external symbol "main" so the linker
; can substitute the final address
[extern main]

; invoke main() in our C kernel
call main

jmp $

