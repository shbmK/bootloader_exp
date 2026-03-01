ENTRY(stage2_main)

SECTIONS
{
    /* Stage 2 expected load address (to be wired by stage 1 in next iterations). */
    . = 0x00007E00;

    .text : {
        *(.text*)
    }

    .rodata : {
        *(.rodata*)
    }

    .data : {
        *(.data*)
    }

    .bss : {
        *(COMMON)
        *(.bss*)
    }
}
