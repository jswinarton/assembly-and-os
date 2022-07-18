# Declare constants for the multiboot header
.set ALIGN, 1<<0  # align loaded modules on page boundaries
.set MEMINFO, 1<<1  # provide memory map
.set FLAGS, ALIGN | MEMINFO  # this is the Multiboot 'flag' field
.set MAGIC, 0x1BADB002  # 'magic number' lets bootloader find the header
.set CHECKSUM,  -(MAGIC + FLAGS)  # checksum of above, to prove we are multiboot

# Declare a multiboot header that marks the program as a kernel. The bootloader
# will search for this signature in the first 8 KiB of the kernel file, aligned
# at a 32-bit boundary. The signature is in its own section so the header can be
# forced to be within the first 8 KiB of the kernel file.
.section multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

# The multiboot standard does not define the value of the stack pointer register
# (esp) and it is up to the kernel to provide a stack. This allocates room for a
# small stack by creating a symbol at the bottom of it, then allocating 16384
# bytes for it, and finally creating a symbol at the top. The stack grows
# downwards on x86. The stack is in its own section so it can be marked nobits,
# which means the kernel file is smaller because it does not contain an
# uninitialized stack. The stack on x86 must be 16-byte aligned according to the
# System V ABI standard and de-facto extensions. The compiler will assume the
# stack is properly aligned and failure to align the stack will result in
# undefined behavior.
.section bss
.align 16
stack_bottom:
.skip 0x4000  # 16KiB
stack_top:

# The linker script specifies _start as the entry point to the kernel and the
# bootloader will jump to this position once the kernel has been loaded.
.section .text
.global _start
.type _start, @function
_start:
    # The bootloader has loaded us into 32-bit protected mode on an x86 machine.
    # Interrupts are disabled. Paging is disabled. The processor state is
    # part of the multiboot standard. The kernel has full control of the CPU.
    # The kernel can only make sure of hardware features and any code it
    # provides as part of itself. There are also no security restrictions,
    # safeguards or debugging mechanisms.

    # Start by setting up a stack. Set the esp register to point to the top of
    # the stack (stack grows downwards on x86 systems). Necessary in assembly as
    # C cannot function without a stack.
    mov $stack_top, %esp

    # This is a good place to initialize crucial processor state before the
    # high-level kernel is entered. It's best to minimize the early environment
    # where crucial features are offline. Note that the processor is not fully
    # initialized yet: Features such as floating point instructions and
    # instruction set extensions are not initialized yet. The GDT should be
    # loaded here. Paging should be enabled here. C++ features such as global
    # constructors and exceptions will require runtime support to work as well.

    # Enter the kernel. The ABI requires the stack to be 16-byte aligned at the
    # time of the call instruction (which afterwards pushes the return pointer
    # of size 4 bytes). The stack was originally 16-byte aligned and we haven't
    # pushed anything to it yet, so the alignment is maintained and the call is
    # well defined.
    call kernel_main

    # Run an infinite loop:
    # 1. Disable interrupts with the `cli` command (clear interrupt enable in
    # eflags). Technically not necessary since the bootloader already disables
    # them, but this is a safety incase something weird happens in the kernel.
    # 2. Wait for the next interrupt with hlt (halt instruction)
    # 3. Jump to the hlt instruction if we ever wake up due to a non-maskable
    # interrupt.
    cli
1:  hlt
    jmp 1b

# Set the size of the _start symbol to the current location '.' minus its start
# This is useful when debugging or for implementation of call tracing
.size _start, . - _start
