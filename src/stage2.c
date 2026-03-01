#include <stdint.h>
#include "io.h"

static volatile uint16_t *const VGA = (uint16_t *)0xB8000;

static void write_banner(const char *text, uint8_t color)
{
    for (uint32_t i = 0; text[i] != '\0'; ++i) {
        VGA[i] = ((uint16_t)color << 8) | (uint8_t)text[i];
    }
}

void stage2_main(void)
{
    /* Placeholder C stage: this will run once stage1 disk loading is added. */
    write_banner("Bootloader skeleton: stage2 C entry", 0x0F);

    /* QEMU debug port (optional trace hook). */
    outb(0xE9, 'O');
    outb(0xE9, 'K');

    for (;;) {
        __asm__ volatile ("hlt");
    }
}
