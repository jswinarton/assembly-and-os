SRCS = $(wildcard *.asm)

PROGS = $(patsubst %.asm, %.bin, $(SRCS))

all: $(PROGS)

%.bin: %.asm lib/*.asm
	nasm $< -f bin -o $@

clean:
	rm -rf $(PROGS)
