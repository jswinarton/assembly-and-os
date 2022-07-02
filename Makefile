SRCS = $(wildcard *.asm)

PROGS = $(patsubst boot_%.asm, boot_%.bin, $(SRCS))

all: $(PROGS)

boot_string.bin: boot_string.asm print.asm
	nasm boot_string.asm -f bin -o boot_string.bin

boot_%.bin: boot_%.asm
	nasm $< -f bin -o $@

clean:
	rm -rf $(PROGS)
