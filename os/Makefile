# TODO make sure builds go to 32-bit mode

all: os.img

# TODO
# Run QEMU to simulate a real system boot
# run: all

# The actual disk image that the computer loads, which is the combination of the
# compiled boot sector and kernel
os.img: boot_sect.bin kernel.bin
	cat $^ os.img

# This builds the binary of the kernel from two object files:
#  - the kernel_entry, which jumps to main() in our kernel
#  - the compiled C kernel
kernel.bin: kernel_entry.o kernel.o
	ld -o kernel.bin -Ttext 0x1000 $^ --oformat binary

# Build the kernel object file
kernel.o: kernel.c
	gcc -ffreestanding -c $< -o $@

# Build the kernel entry object file
kernel_entry.o: kernel_entry.asm
	nasm $< -f elf -o $@

# TODO
# Assemble the boot sector to raw machine code
# boot_sect.bin: boot_sect.asm
# 	nasm $< -f bin -I '../../16bit/' -o $@

# Clear away all generated files
clean:
	rm -r *.bin *.dis *.o os.img *.map

# Disassemble the kernel -- might be useful for debugging
kernel.dis: kernel.bin
	ndisasm -b 32 $< > $@
