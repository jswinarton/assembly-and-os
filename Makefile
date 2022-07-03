SRCS = $(wildcard *.asm)

PROGS = $(patsubst boot_%.asm, boot_%.bin, $(SRCS))

all: $(PROGS)

boot_%.bin: boot_%.asm print.asm
	nasm $< -f bin -o $@

# TODO this currently deletes print.asm. Not sure how to fix
clean:
	rm -rf $(PROGS)
