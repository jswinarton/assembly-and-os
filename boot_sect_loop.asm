;
; A simple boot sector program that loops forever.
;

; Define a label, "loop", that will allow us to jump back to it, forever.
loop:
  ; Use a simple CPU instruction that jumps to a new memory address to continue
  ; execution. In our case, jump to the address of the current instruction.
  jmp loop

; When compiled, our program must fit into 512 bytes, with the last two bytes
; being the magic number. So here, tell our assembly compiler to pad out our
; program with enough zero bytes (db 0) to bring us to the 510th byte.
times 510-($-$$) db 0

; Last two bytes (one word) form the magic number, so BIOS knows we are a boot
; sector.
dw 0xaa55
