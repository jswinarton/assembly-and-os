SRCS = $(wildcard *.asm)

PROGS = $(patsubst boot_%.asm, boot_%.bin, $(SRCS))

all: $(PROGS)

boot_%.bin: boot_%.asm
	nasm $< -f bin -o $@

clean:
	rm -rf $(PROGS)
