SRCS = $(wildcard *.asm)

PROGS = $(patsubst %.asm, %.bin, $(SRCS))

all: $(PROGS)

%.bin: %.asm
	nasm $< -f bin -o $@

clean:
	rm -rf $(PROGS)
