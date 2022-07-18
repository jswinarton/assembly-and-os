/** @file kernel.c */

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

// Check if the compiler thinks you are targeting the wrong operating system
#if defined(__linux__)
#error "You are not using a cross-compiler, you will most certainly run into trouble"
#endif

// This will only work on 32-bit ix86 targets
#if !defined(__i386__)
#error "This kernel must be compiled with an ix86-elf compiler"
#endif

// Hardware text mode color constants
enum vga_color
{
    VGA_COLOR_BLACK = 0,
    VGA_COLOR_BLUE = 1,
    VGA_COLOR_GREEN = 2,
    VGA_COLOR_CYAN = 3,
    VGA_COLOR_RED = 4,
    VGA_COLOR_MAGENTA = 5,
    VGA_COLOR_BROWN = 6,
    VGA_COLOR_LIGHT_GREY = 7,
    VGA_COLOR_DARK_GREY = 8,
    VGA_COLOR_LIGHT_BLUE = 9,
    VGA_COLOR_LIGHT_GREEN = 10,
    VGA_COLOR_LIGHT_CYAN = 11,
    VGA_COLOR_LIGHT_RED = 12,
    VGA_COLOR_LIGHT_MAGENTA = 13,
    VGA_COLOR_LIGHT_BROWN = 14,
    VGA_COLOR_WHITE = 15,
};

// TODO make sure this shows up in doxygen
/**
 * Return a uint8_t describing a fg/bg color combo.
 *
 * The low 4 bits represent the foreground color and the high four bits
 * represent the background color
 */
static inline uint8_t
vga_entry_color(enum vga_color fg, enum vga_color bg)
{
    return fg | bg << 4;
}

// TODO make sure static inline methods show up in doxygen
// TODO how to document the specification for colors?

/**
 * Return a uint16_t describing a character and its colors.
 *
 * The low 8 bits represent the character, and the high 8 bits represent a fg/bg
 * color combination (see vga_entry_color for the specification).
 */
static inline uint16_t vga_entry(unsigned char uc, uint8_t color)
{
    return (uint16_t)uc | (uint16_t)color << 8;
}

/**
 * Return the length of a string.
 */
size_t strlen(const char *str)
{
    // This works because each char is just an int, and the null character '\0'
    // is just the int 0. This is the only thing that evaluates to false.
    size_t len = 0;
    while (str[len])
        len++;
    return len;
}

static const size_t VGA_WIDTH = 80;
static const size_t VGA_HEIGHT = 25;

size_t terminal_row;
size_t terminal_column;
uint8_t terminal_color;
uint16_t *terminal_buffer;

void terminal_initialize(void)
{
    terminal_row = 0;
    terminal_column = 0;
    terminal_color = vga_entry_color(VGA_COLOR_LIGHT_GREY, VGA_COLOR_BLACK);
    terminal_buffer = (uint16_t *)0xB8000;

    for (size_t y = 0; y < VGA_HEIGHT; y++)
    {
        for (size_t x = 0; x < VGA_WIDTH; x++)
        {
            const size_t index = y * VGA_WIDTH + x;
            terminal_buffer[index] = vga_entry(' ', terminal_color);
        }
    }
}

void terminal_setcolor(uint8_t color)
{
    terminal_color = color;
}

/// @brief Put a character at a specified position in the terminal.
/// @param c The character to be rendered. This should be a printable
/// character. (No processing is done to ensure that it isn't.)
/// @param color The color of the character.
/// @param x The x-coordinate of the terminal location to print at.
/// @param y The y-coordinate of the terminal location to print at.
void terminal_putentryat(char c, uint8_t color, size_t x, size_t y)
{
    const size_t index = y * VGA_WIDTH + x;
    terminal_buffer[index] = vga_entry(c, color);
}

/// @brief Put a character at the position indicated by the column and row
/// counters and advance the counters.
/// @details If the character is a newline, no character will be printed, but
/// the column and row counters will advance to the beginning of the next row.
/// @param c The character to be rendered.
void terminal_putchar(char c)
{
    // TODO why does this work ...
    if (c == *"\n")
    {
        terminal_column = 0;
        if (++terminal_row == VGA_HEIGHT)
            terminal_row = 0;
        return;
    }

    terminal_putentryat(c, terminal_color, terminal_column, terminal_row);

    if (++terminal_column == VGA_WIDTH)
    {
        terminal_column = 0;
        if (++terminal_row == VGA_HEIGHT)
            terminal_row = 0;
    }
}

void terminal_write(const char *data)
{
    size_t len = 0;
    while (data[len])
    {
        terminal_putchar(data[len]);
        len++;
    }
}

int abs(int value)
{
    if (value < 0)
    {
        return value / -1;
    }
    return value;
}

char *itoa(int value, char *str, int base)
{
    // We only support bases between 2 and 36.
    if (base < 2 || base > 36)
    {
        *str = '\0';
        return str;
    }

    // TODO this is a bad variable name
    char *rc;
    char *ptr;
    char *low;

    rc = ptr = str;

    // Set '-' for negative decimals
    // TODO why only for decimals?
    if (value < 0 && base == 10)
    {
        // The postfix operator means the increment happens AFTER assignment.
        // So this assigns to the memory pointed to by ptr and then increments.
        *ptr++ = '-';
    }

    // Remember where the numbers start
    // TODO document this better
    low = ptr;

    // The main conversion routine
    // Divide the value by the base. The remainder (modulo) is the last digit.
    // Feed the quotient back into the algorithm and repeat to get each digit.
    // Since this works backwards, we will need to reverse the order of the
    // digits at the end.
    do
    {
        *ptr++ = "0123456789abcdefghijklmnopqrstuvwxyz"[abs(value % base)];
        value /= base;
    } while (value);

    // Terminate the string
    // Decrement the pointer so that it points at the last character in the
    // string, so that we can do the reversal properly
    // Remember that postfix operator means decrement happens after assignment
    *ptr-- = '\0';

    // Reverse the numbers
    // TODO there is probably a better way to do this.
    // See http://www.strudel.org.uk/itoa/
    // You could create some kind of buffer of a set size and add the digits in
    // backwards, then produce a null-terminated string from this
    while (low < ptr)
    {
        char tmp = *low;
        *low++ = *ptr;
        *ptr-- = tmp;
    }

    return rc;
}

void kernel_main(void)
{
    terminal_initialize();

    char *itoastr = "";
    for (size_t i = 0; i <= 30; i++)
    {
        itoa(i, itoastr, 10);
        terminal_write("Line ");
        terminal_write(itoastr);
        terminal_write("\n");
    }
}
