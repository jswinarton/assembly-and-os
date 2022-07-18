all: _build/os.iso

run: all
	qemu-system-x86_64 -cdrom _build/os.iso

_build/os.iso: _build/os.bin grub.cfg
	mkdir -p _build/iso_filesystem/boot/grub
	cp _build/os.bin _build/iso_filesystem/boot/os.bin
	cp grub.cfg _build/iso_filesystem/boot/grub/grub.cfg
	grub-mkrescue -o _build/os.iso _build/iso_filesystem

_build/os.bin: src/boot.o src/kernel.o src/linker.ld
	mkdir -p _build
	i686-elf-gcc -T src/linker.ld -o $@ -ffreestanding -O2 -nostdlib src/boot.o src/kernel.o -lgcc

src/boot.o: src/boot.s
	i686-elf-as $< -o $@

src/kernel.o: src/kernel.c
	i686-elf-gcc -c $< -o $@ -std=gnu99 -ffreestanding -O2 -Wall -Wextra

.PHONY: clean
clean:
	rm -r _build src/*.o

.PHONY: docs
docs:
	doxygen

.PHONY: serve-docs
serve-docs:
	python3 -m http.server --bind 0.0.0.0 8080 --directory ./docs
