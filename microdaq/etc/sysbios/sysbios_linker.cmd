/* This is an additional linker script which places */
/* global variables in non cacheable memory         */

SECTIONS
{
    GROUP: load > L3_CBA_RAM
    {
        .bss:
        .neardata:
        .rodata:
    }
}
 