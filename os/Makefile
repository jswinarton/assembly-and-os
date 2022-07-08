all: os.img

# TODO
# Run QEMU to simulate a real system boot
run: all
	qemu-system-x86_64 -monitor stdio os.img

# The actual disk image that the computer loads, which is the combination of the
# compiled boot sector and kernel
os.img: boot/boot_sect.bin kernel/kernel.bin
	cat $^ > os.img

# This builds the binary of the kernel from two object files:
#  - the kernel_entry, which jumps to main() in our kernel
#  - the compiled C kernel
kernel/kernel.bin: kernel/kernel_entry.o kernel/kernel.o
	ld -m elf_i386 -o kernel/kernel.bin -Ttext 0x1000 $^ --oformat binary

# Build the kernel object file
kernel/kernel.o: kernel/kernel.c
	gcc -m32 -fno-pic -ffreestanding -c $< -o $@

# Build the kernel entry object file
kernel/kernel_entry.o: kernel/kernel_entry.asm
	nasm $< -f elf -o $@

# Assemble the boot sector to raw machine code
boot/boot_sect.bin: boot/boot_sect.asm
	nasm $< -f bin -I './boot' -o $@

# Disassemble the kernel -- might be useful for debugging
kernel/kernel.dis: kernel/kernel.bin
	ndisasm -b 32 $< > $@

# Clear away all generated files
clean:
	rm -r **/*.bin **/*.dis **/*.o **/*.map os.img
