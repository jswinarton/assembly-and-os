/* The bootloader will look at this image and start execution at the symbol
 * designated as the entrypoint. */
ENTRY(_start)

/* Declare where the various sections of object files will be placed in the final
 * kernel image. */
SECTIONS
{
    /* Start by putting sections at 1MiB, a conventional place for kernels to be
     * loaded at by the bootloader. */
    . = 1M;

    /* Start with the multiboot header, as it is required to be put very early in
     * the image or the bootloader won't recognize the file format. This is
     * followed by the .text section. */
    .text BLOCK(4K): ALIGN(4K)
    {
        *(.multiboot)
        *(.text)
    }

    /* Read-only data */
    .rodata BLOCK(4K) : ALIGN(4K)
    {
        *(.rodata)
    }

    /* Read-write data (initialized) */
    .data BLOCK(4K) : ALIGN(4K)
    {
        *(.data)
    }

    /* Read-write data (uninitialized) and stack */
    .bss BLOCK(4K) : ALIGN(4K)
    {
        *(COMMON)
        *(.bss)
    }

    /* The compiler may produce other sections, by default it will put them in a
     * segment with the same name. Simply add stuff here as needed. */
}
